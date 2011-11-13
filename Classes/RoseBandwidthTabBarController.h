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

@property (nonatomic, strong) IBOutlet BandwidthUsageViewController * usageViewController;
@property (nonatomic, strong) IBOutlet BandwidthHistoryTableViewController * historyViewController;
@property (nonatomic, strong) IBOutlet SettingsViewController * settingsViewController;

- (void)showFirstRunDialog;
- (void)dismissedFirstRunDialog;

- (void)kerberosAccountInfoChanged;

@end
