//
//  BandwidthUsageViewController.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/25/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "BandwidthUsageViewController.h"
#import "KerberosAccountManager.h"
#import "BandwidthScraper.h"
#import "VerticalProgressView.h"
#import "RoseBandwidthAppDelegate.h"
#import "RoseBandwidthTabBarController.h"
#import "BandwidthUsageRecord.h"
#import "StoredSettingsManager.h"

@interface BandwidthUsageViewController()
- (void)updateVisibleBandwidthWithType:(kBandwidthUsage)type;
- (void)showUpdating;
@end

@implementation BandwidthUsageViewController

@synthesize titleLabel = _titleLabel;

@synthesize measureControl = _measureControl;

@synthesize leftUsageView = _leftUsageView;
@synthesize rightUsageView = _rightUsageView;

@synthesize leftUsageLabel = _leftUsageLabel;
@synthesize rightUsageLabel = _rightUsageLabel;

@synthesize currentUsage = _currentUsage;

@synthesize adBannerView = _adBannerView;

@synthesize updating = _updating;

- (IBAction)requestBandwidthUpdate {
    if(!self.updating && ![[StoredSettingsManager sharedManager] isFirstRun]) {
        [[[[BandwidthScraper alloc] initWithDelegate:((RoseBandwidthTabBarController *)self.tabBarController)] autorelease] beginScraping];
        self.updating = YES;
    }
}

- (void)showUpdating {
    //NSLog(@"showing updating: %@", (self.updating ? @"YES" : @"NO"));
    if(self.updating) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)forceBandwidthDisplayReload {
    // Load cached bandwidth usage record if available
    NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:@"BandwidthUsageRecord" inManagedObjectContext:[self managedObjectContext]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"kerberosName == %@", [[KerberosAccountManager defaultManager] username]]];
    [request setFetchLimit:1];
    [request setSortDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO] autorelease]]];
    NSError * error;
    NSArray * results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if(nil == results) {
        NSLog(@"error fetching past bandwidth: %@", error);
    } else {
        if([results count] > 0) {
            self.currentUsage = [results objectAtIndex:0];
            [self updateVisibleBandwidthWithUsageRecord:self.currentUsage];
        } else {
            [self updateVisibleBandwidthWithUsageRecord:nil];
        }
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver:self forKeyPath:@"updating" options:NSKeyValueObservingOptionNew context:NULL];
    [[StoredSettingsManager sharedManager] addObserver:self forKeyPath:@"warningLevel" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    [[StoredSettingsManager sharedManager] addObserver:self forKeyPath:@"alertLevel" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    
    // Handle ad banner stuff
    self.adBannerView.delegate = self;
    
    // Resize control
    CGRect frame = self.measureControl.frame;
    frame.size.height = 30.0;
    self.measureControl.frame = frame;
    
    // Shift content for ad banner load duration
    [self shiftContentWithMultiplier:-1.0 animated:NO];
    _failedAdLoad = YES;
    
    // Show cached bandwidth no matter what
    [self forceBandwidthDisplayReload];
    
    // Grab new bandwidth on app load
    [self requestBandwidthUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[[KerberosAccountManager defaultManager] username] isEqualToString:@""]) {
        self.navigationItem.title = [NSString stringWithFormat:@"Usage: %@", [[KerberosAccountManager defaultManager] username]];
    } else {
        self.navigationItem.title = @"Usage";
    }
}

#pragma mark -
#pragma mark Action response methods

- (float)warningLevel {
    return [[StoredSettingsManager sharedManager] warningLevel];
}

- (float)alertLevel {
    return [[StoredSettingsManager sharedManager] alertLevel];
}

- (void)updateVisibleBandwidthWithUsageRecord:(BandwidthUsageRecord *)usage {
    self.currentUsage = usage;
    [self updateVisibleBandwidthWithType:[self.measureControl selectedSegmentIndex]];
    self.updating = NO;
}

- (UIColor *)barColorForUsageValue:(NSNumber *)val {
    float valf = [val floatValue];
    if(valf > [self alertLevel]) {
        return [UIColor redColor];
    } else if(valf > [self warningLevel]) {
        return [UIColor yellowColor];
    } else {
        //return [UIColor greenColor];
        return [UIColor colorWithRed:0.0/255.0 green:146.0/255.0 blue:74.0/255.0 alpha:1.0];
    }
}

- (void)updateVisibleBandwidthWithType:(kBandwidthUsage)type {
    [self.measureControl setSelectedSegmentIndex:type];
    
    NSNumber * received;
    NSNumber * sent;
    
    if(type == kBandwidthUsagePolicy) {
        received = [self.currentUsage policyReceived];
        sent = [self.currentUsage policySent];
    } else if(type == kBandwidthUsageActual) {
        received = [self.currentUsage actualReceived];
        sent = [self.currentUsage actualSent];
    } else {
        NSLog(@"what?");
        [self updateVisibleBandwidthWithType:kBandwidthUsagePolicy];
        return;
    }
    
    self.leftUsageLabel.text = [NSString stringWithFormat:@"Received:\n%.2f MB", [received floatValue]];
    self.rightUsageLabel.text = [NSString stringWithFormat:@"Sent:\n%.2f MB", [sent floatValue]];
    
    float usageDisplayMax = 5000.0;
    
    self.leftUsageView.currentValue = [received floatValue];
    self.rightUsageView.currentValue = [sent floatValue];
    
    self.leftUsageView.maxValue = usageDisplayMax;
    self.rightUsageView.maxValue = usageDisplayMax;
    
    [self.leftUsageView addLabelAt:[self warningLevel]];
    [self.rightUsageView addLabelAt:[self warningLevel]];
    [self.leftUsageView addLabelAt:[self alertLevel]];
    [self.rightUsageView addLabelAt:[self alertLevel]];
    
    self.leftUsageView.barColor = [self barColorForUsageValue:received];
    self.rightUsageView.barColor = [self barColorForUsageValue:sent];
    
    [self.leftUsageView setNeedsDisplay];
    [self.rightUsageView setNeedsDisplay];
}

- (IBAction)measureControlValueChanged:(id)sender {
    [self updateVisibleBandwidthWithType:[self.measureControl selectedSegmentIndex]];
}

#pragma mark -
#pragma mark KVO response method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //NSLog(@"value changed for object:%@ keypath:%@", object, keyPath);
    
    if(object == self && [keyPath isEqualToString:@"updating"]) {
        [self showUpdating];
    } else if(object == [StoredSettingsManager sharedManager] && [keyPath isEqualToString:@"warningLevel"]) {
        [self.leftUsageView removeLabelAt:[[change valueForKey:NSKeyValueChangeOldKey] floatValue]];
        [self.leftUsageView addLabelAt:[[change valueForKey:NSKeyValueChangeNewKey] floatValue]];
        self.leftUsageView.barColor = [self barColorForUsageValue:[NSNumber numberWithFloat:self.leftUsageView.currentValue]];
        
        [self.rightUsageView removeLabelAt:[[change valueForKey:NSKeyValueChangeOldKey] floatValue]];
        [self.rightUsageView addLabelAt:[[change valueForKey:NSKeyValueChangeNewKey] floatValue]];
        self.rightUsageView.barColor = [self barColorForUsageValue:[NSNumber numberWithFloat:self.rightUsageView.currentValue]];
    } else if(object == [StoredSettingsManager sharedManager] && [keyPath isEqualToString:@"alertLevel"]) {
        [self.leftUsageView removeLabelAt:[[change valueForKey:NSKeyValueChangeOldKey] floatValue]];
        [self.leftUsageView addLabelAt:[[change valueForKey:NSKeyValueChangeNewKey] floatValue]];
        self.leftUsageView.barColor = [self barColorForUsageValue:[NSNumber numberWithFloat:self.leftUsageView.currentValue]];
        
        [self.rightUsageView removeLabelAt:[[change valueForKey:NSKeyValueChangeOldKey] floatValue]];
        [self.rightUsageView addLabelAt:[[change valueForKey:NSKeyValueChangeNewKey] floatValue]];
        self.rightUsageView.barColor = [self barColorForUsageValue:[NSNumber numberWithFloat:self.rightUsageView.currentValue]];
    } else {
        NSLog(@"Observed unknown value change for key %@", keyPath);
    }
}

#pragma mark -
#pragma mark Managed object stack

- (NSManagedObjectContext *)managedObjectContext {
    return [((RoseBandwidthAppDelegate *)[[UIApplication sharedApplication] delegate]) managedObjectContext];
}

#pragma mark -
#pragma mark Unload and dealloc

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"updating"];
    [[StoredSettingsManager sharedManager] removeObserver:self forKeyPath:@"warningLevel"];
    [[StoredSettingsManager sharedManager] removeObserver:self forKeyPath:@"alertLevel"];
    
    self.adBannerView.delegate = nil;
    [_adBannerView release];
    
    [_measureControl release];
    [_leftUsageView release];
    [_rightUsageView release];
    [_leftUsageLabel release];
    [_rightUsageLabel release];
    [_currentUsage release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark ADBannerViewDelegate methods

- (void)shiftContentWithMultiplier:(float)mult animated:(BOOL)animated {
    CGFloat adOffset = [ADBannerView sizeFromBannerContentSizeIdentifier:self.adBannerView.currentContentSizeIdentifier].height;
    
    if(animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
    }
    self.titleLabel.frame = CGRectOffset(self.titleLabel.frame, 0, mult * adOffset);
    self.measureControl.frame = CGRectOffset(self.measureControl.frame, 0, mult * adOffset);
    self.adBannerView.frame = CGRectOffset(self.adBannerView.frame, 0, mult * adOffset);
    
    for(VerticalProgressView * progressView in [NSArray arrayWithObjects:self.leftUsageView, self.rightUsageView, nil]) {
        CGRect frame = progressView.frame;
        frame.size.height = frame.size.height - (mult * adOffset);
        frame.origin.y = frame.origin.y + (mult * adOffset);
        progressView.frame = frame;
    }
    if(animated) {
        [UIView commitAnimations];
    }
    
    [self.leftUsageView setNeedsDisplay];
    [self.rightUsageView setNeedsDisplay];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    //NSLog(@"loaded iAd");
    if(_failedAdLoad) {
        // Past ad failed - move things downward
        [self shiftContentWithMultiplier:1.0 animated:YES];
    }
    
    _failedAdLoad = NO;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    //NSLog(@"failed to receive iAd");
    if(_failedAdLoad == NO) {
        // Past ad did not fail - move things upward
        [self shiftContentWithMultiplier:-1.0 animated:YES];
    }
    
    _failedAdLoad = YES;
}


@end
