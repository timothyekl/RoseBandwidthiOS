//
//  RoseBandwidthTabBarController.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/28/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "RoseBandwidthTabBarController.h"

#import "BandwidthScraper.h"
#import "BandwidthUsageViewController.h"
#import "BandwidthHistoryTableViewController.h"
#import "SettingsViewController.h"

#import "FirstRunSettingsViewController.h"
#import "StoredSettingsManager.h"

@implementation RoseBandwidthTabBarController

@synthesize usageViewController = _usageViewController;
@synthesize historyViewController = _historyViewController;
@synthesize settingsViewController = _settingsViewController;

- (void)showFirstRunDialog {
    FirstRunSettingsViewController * firstRunController = [[[FirstRunSettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
    firstRunController.presentingTabBarController = self;
    UINavigationController * navController = [[[UINavigationController alloc] initWithRootViewController:firstRunController] autorelease];
    [self presentModalViewController:navController animated:YES];
}

- (void)dismissedFirstRunDialog {
    [[StoredSettingsManager sharedManager] setFirstRun:NO];
    [[StoredSettingsManager sharedManager] writeSettingsToFile];
    
    [self.usageViewController requestBandwidthUpdate];
}

#pragma mark -
#pragma mark BandwidthScraperDelegate methods

- (void)scraper:(BandwidthScraper *)scraper foundBandwidthUsageAmounts:(BandwidthUsageRecord *)usage {
    [self.usageViewController updateVisibleBandwidthWithUsageRecord:usage];
}

- (void)scraper:(BandwidthScraper *)scraper encounteredError:(NSError *)error {
    NSString * title = @"Error";
    NSString * message = @"Couldn't load bandwidth usage. Make sure that you are connected to the Rose-Hulman network via WiFi.";
    NSString * cancelButtonTitle = @"OK";
    
    if([[error domain] isEqualToString:NSURLErrorDomain] && [error code] == NSURLErrorUserCancelledAuthentication) {
        // Cancelled authentication (i.e. bad password)
        message = @"Bad username or password. Please make sure your Kerberos credentials are correct in Settings.";
    }
    
    [[[[UIAlertView alloc] initWithTitle:title
                                 message:message
                                delegate:nil 
                       cancelButtonTitle:cancelButtonTitle
                       otherButtonTitles:nil] autorelease] show];
    [self.usageViewController updateVisibleBandwidthWithUsageRecord:self.usageViewController.currentUsage];
}

#pragma mark -
#pragma mark Update notification methods

- (void)kerberosAccountInfoChanged {
    [self.usageViewController forceBandwidthDisplayReload];
    [self.historyViewController forceHistoryReload];
}

#pragma mark -
#pragma mark Memory management

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
    [_usageViewController release];
    [_historyViewController release];
    [_settingsViewController release];
    
    [super dealloc];
}


@end
