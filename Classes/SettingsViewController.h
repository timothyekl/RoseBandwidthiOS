//
//  SettingsViewController.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/25/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController <UITextFieldDelegate> {
    UITextField * usernameField;
    UITextField * passwordField;
}

@property (nonatomic, retain) IBOutlet UITextField * usernameField;
@property (nonatomic, retain) IBOutlet UITextField * passwordField;

- (IBAction)kerberosInfoDidChange:(id)sender;

@end
