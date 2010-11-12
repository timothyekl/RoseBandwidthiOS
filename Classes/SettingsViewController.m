//
//  SettingsViewController.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/25/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "KerberosAccountManager.h"
#import "RoseBandwidthTabBarController.h"


@implementation SettingsViewController

@synthesize usernameField, passwordField;

#pragma mark -
#pragma mark Init and load

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    self.usernameField.text = [[KerberosAccountManager defaultManager] getUsername];
    self.passwordField.text = [[KerberosAccountManager defaultManager] getPassword];
}

#pragma mark -
#pragma mark View methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _username = [[[[KerberosAccountManager defaultManager] getUsername] copy] retain];
    _password = [[[[KerberosAccountManager defaultManager] getPassword] copy] retain];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(![_username isEqualToString:[[KerberosAccountManager defaultManager] getUsername]] ||
       ![_password isEqualToString:[[KerberosAccountManager defaultManager] getPassword]]) {
        [((RoseBandwidthTabBarController *)self.tabBarController) kerberosAccountInfoChanged];
    }
}

#pragma mark -
#pragma mark UIResponder methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.usernameField) {
        [self.usernameField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    } else if(textField == self.passwordField) {
        [self.passwordField resignFirstResponder];
    }
    return YES;
}

#pragma mark -
#pragma mark Action response methods

- (IBAction)kerberosInfoDidChange:(id)sender {
    if(sender == self.usernameField) {
        [[KerberosAccountManager defaultManager] setUsername:self.usernameField.text];
    } else if(sender == self.passwordField) {
        [[KerberosAccountManager defaultManager] setPassword:self.passwordField.text];
    } else {
        NSLog(@"sender unknown for kerberos info change");
    }
}

#pragma mark -
#pragma mark Memory management methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark Unload and dealloc

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
