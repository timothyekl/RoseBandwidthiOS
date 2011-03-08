//
//  RoseBandwidthTabBarController.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/28/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BandwidthScraperDelegate.h"

@class BandwidthUsageViewController;
@class BandwidthHistoryTableViewController;
@class SettingsViewController;

@interface RoseBandwidthTabBarController : UITabBarController <BandwidthScraperDelegate> {
    BandwidthUsageViewController * _usageViewController;
    BandwidthHistoryTableViewController * _historyViewController;
    SettingsViewController * _settingsViewController;
}

@property (nonatomic, retain) IBOutlet BandwidthUsageViewController * usageViewController;
@property (nonatomic, retain) IBOutlet BandwidthHistoryTableViewController * historyViewController;
@property (nonatomic, retain) IBOutlet SettingsViewController * settingsViewController;

- (void)showFirstRunDialog;
- (void)dismissedFirstRunDialog;

- (void)kerberosAccountInfoChanged;

@end
