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

@implementation RoseBandwidthTabBarController

@synthesize usageViewController = _usageViewController;
@synthesize historyViewController = _historyViewController;
@synthesize settingsViewController = _settingsViewController;

#pragma mark -
#pragma mark BandwidthScraperDelegate methods

- (void)scraper:(BandwidthScraper *)scraper foundBandwidthUsageAmounts:(BandwidthUsageRecord *)usage {
    [self.usageViewController updateVisibleBandwidthWithUsageRecord:usage];
    [self.historyViewController addRecordForBandwidthUsage:usage];
}

- (void)scraper:(BandwidthScraper *)scraper encounteredError:(NSError *)error {
    [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't load bandwidth usage" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    [self.usageViewController updateVisibleBandwidthWithUsageRecord:self.usageViewController.currentUsage];
}

#pragma mark -
#pragma mark Update notification methods

- (void)kerberosAccountInfoChanged {
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
