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

#define PI (3.14159265)

@interface BandwidthUsageViewController()
- (void)updateVisibleBandwidthWithType:(kBandwidthUsage)type;
@end

@implementation BandwidthUsageViewController

@synthesize measureControl = _measureControl;

@synthesize leftUsageView = _leftUsageView;
@synthesize rightUsageView = _rightUsageView;

@synthesize leftUsageLabel = _leftUsageLabel;
@synthesize rightUsageLabel = _rightUsageLabel;

@synthesize refreshButton = _refreshButton;

@synthesize currentUsage = _currentUsage;

@synthesize updating = _updating;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        [self addObserver:self forKeyPath:@"updating" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (IBAction)requestBandwidthUpdate {
    if(!self.updating) {
        KerberosAccountManager * manager = [KerberosAccountManager defaultManager];
        [[[[BandwidthScraper alloc] initWithDelegate:((RoseBandwidthTabBarController *)self.tabBarController)
                                            username:[manager getUsername]
                                            password:[manager getPassword]] autorelease] beginScraping];
        self.updating = YES;
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Resize control
    CGRect frame = self.measureControl.frame;
    frame.size.height = 30.0;
    self.measureControl.frame = frame;
    
    // Grab new bandwidth on app load
    [self requestBandwidthUpdate];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Action response methods

- (void)updateVisibleBandwidthWithUsageRecord:(BandwidthUsageRecord *)usage {
    self.currentUsage = usage;
    [self updateVisibleBandwidthWithType:[self.measureControl selectedSegmentIndex]];
    self.updating = NO;
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
    
    self.leftUsageLabel.text = [NSString stringWithFormat:@"Received:\n%@ MB", received];
    self.rightUsageLabel.text = [NSString stringWithFormat:@"Sent:\n%@ MB", sent];
    
    float pr = [received floatValue];
    float ps = [sent floatValue];
    
    self.leftUsageView.currentValue = pr;
    self.rightUsageView.currentValue = ps;
    
    float maxUsage = MAX(pr, ps);
    float usageDisplayMax = MAX((float)((int)(ceilf(maxUsage / 1000.0)) * 1000), 3000.0);
    
    self.leftUsageView.maxValue = usageDisplayMax;
    self.rightUsageView.maxValue = usageDisplayMax;
    
    [self.leftUsageView setNeedsDisplay];
    [self.rightUsageView setNeedsDisplay];
}

- (IBAction)measureControlValueChanged:(id)sender {
    [self updateVisibleBandwidthWithType:[self.measureControl selectedSegmentIndex]];
}

#pragma mark -
#pragma mark KVO response method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"value changed for key path: %@", keyPath);
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
    
    [_measureControl release];
    [_leftUsageView release];
    [_rightUsageView release];
    [_leftUsageLabel release];
    [_rightUsageLabel release];
    [_refreshButton release];
    [_currentUsage release];
    
    [super dealloc];
}


@end
