//
//  FirstRunSettingsViewController.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@class RoseBandwidthTabBarController;

@interface FirstRunSettingsViewController : SettingsViewController {
    
}

- (RoseBandwidthTabBarController *)presentingTabBarController;

@end
