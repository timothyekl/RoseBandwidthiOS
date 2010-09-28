//
//  SettingsViewController.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/25/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "KerberosAccountManager.h"


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
    
    self.usernameField.text = [[KerberosAccountManager defaultManager] getUsername];
    self.passwordField.text = [[KerberosAccountManager defaultManager] getPassword];
}

#pragma mark -
#pragma mark Rotation

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
