//
//  FirstRunSettingsViewController.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstRunSettingsViewController.h"

#import "KerberosAccountManager.h"
#import "PropertyEditorViewController.h"

#import "RoseBandwidthTabBarController.h"

@implementation FirstRunSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                              target:self 
                                                                                              action:@selector(dismiss)] autorelease] animated:YES];
    self.navigationItem.title = @"Settings";
}

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:1] autorelease];
    
    Setting * usernameSetting = [[[Setting alloc] initWithTitle:@"Username" 
                                                         target:self 
                                                        onValue:@selector(username) 
                                                       onAction:@selector(editAction:) 
                                                       onChange:@selector(usernameChanged:)] autorelease];
    Setting * passwordSetting = [[[Setting alloc] initWithTitle:@"Password" 
                                                         target:self 
                                                        onValue:@selector(password) 
                                                       onAction:@selector(editAction:) 
                                                       onChange:@selector(passwordChanged:)] autorelease];
    passwordSetting.secure = YES;
    NSArray * authenticationSettings = [[[NSArray alloc] initWithObjects:usernameSetting, passwordSetting, nil] autorelease];
    [self.settings setObject:authenticationSettings forKey:@"Authentication"];
}

- (void)dismiss {
    [self.presentingTabBarController dismissedFirstRunDialog];
    [self dismissModalViewControllerAnimated:YES];
}

- (RoseBandwidthTabBarController *)presentingTabBarController {
    return (RoseBandwidthTabBarController *)(self.parentViewController.parentViewController);
}

#pragma mark - Settings value methods

- (NSString *)username {
    return [[KerberosAccountManager defaultManager] username];
}

- (NSString *)password {
    return [[KerberosAccountManager defaultManager] password];
}

#pragma mark - Setting action methods

- (void)editAction:(Setting *)setting {
    PropertyEditorViewController * editor = [[[PropertyEditorViewController alloc] initWithSetting:setting] autorelease];
    [self.navigationController pushViewController:editor animated:YES];
}

#pragma mark - Setting change methods

//TODO find an easier reload solution

- (void)usernameChanged:(NSString *)username {
    [[KerberosAccountManager defaultManager] setUsername:username];
    
    NSUInteger indexes[2] = {0,0};
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathWithIndexes:indexes length:2], nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.presentingTabBarController kerberosAccountInfoChanged];
}

- (void)passwordChanged:(NSString *)password {
    [[KerberosAccountManager defaultManager] setPassword:password];
    
    NSUInteger indexes[2] = {0,1};
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathWithIndexes:indexes length:2], nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.presentingTabBarController kerberosAccountInfoChanged];
}

#pragma mark - Special case table view footer

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 0) {
        return @"Your Kerberos username and password is used only for fetching bandwidth data, and is stored securely.";
    }
    return nil;
}

@end
