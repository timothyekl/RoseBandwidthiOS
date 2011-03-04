//
//  PrimarySettingsViewController.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PrimarySettingsViewController.h"

#import "KerberosAccountManager.h"
#import "MutableOrderedDictionary.h"

#import "PropertyEditorViewController.h"

@implementation PrimarySettingsViewController

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:2] autorelease];
    
    Setting * usernameSetting = [[[Setting alloc] initWithTitle:@"Username" 
                                                         target:self 
                                                        onValue:@selector(username) 
                                                       onAction:@selector(usernameAction) 
                                                       onChange:@selector(usernameChanged:)] autorelease];
    Setting * passwordSetting = [[[Setting alloc] initWithTitle:@"Password" 
                                                         target:self 
                                                        onValue:@selector(password) 
                                                       onAction:@selector(passwordAction) 
                                                       onChange:@selector(passwordChanged:)] autorelease];
    passwordSetting.secure = YES;
    NSArray * authenticationSettings = [[[NSArray alloc] initWithObjects:usernameSetting, passwordSetting, nil] autorelease];
    [self.settings setObject:authenticationSettings forKey:@"Authentication"];
    
    Setting * sourceSetting = [[[Setting alloc] initWithTitle:@"Source" 
                                                       target:self 
                                                      onValue:@selector(source) 
                                                     onAction:@selector(sourceAction) 
                                                     onChange:@selector(sourceChanged:)] autorelease];
    NSArray * networkSettings = [[[NSArray alloc] initWithObjects:sourceSetting, nil] autorelease];
    [self.settings setObject:networkSettings forKey:@"Network"];
}

#pragma mark - Setting value methods

- (NSString *)username {
    return [[KerberosAccountManager defaultManager] username];
}

- (NSString *)password {
    return [[KerberosAccountManager defaultManager] password];
}

- (NSString *)source {
    return [[KerberosAccountManager defaultManager] sourceURL];
}

#pragma mark - Setting action methods

- (void)usernameAction {
    PropertyEditorViewController * editor = [[[PropertyEditorViewController alloc] initWithSetting:[[self.settings objectForKey:@"Authentication"] objectAtIndex:0]] autorelease];
    [self.navigationController pushViewController:editor animated:YES];
}

- (void)passwordAction {
    PropertyEditorViewController * editor = [[[PropertyEditorViewController alloc] initWithSetting:[[self.settings objectForKey:@"Authentication"] objectAtIndex:1]] autorelease];
    [self.navigationController pushViewController:editor animated:YES];
}

- (void)sourceAction {
    PropertyEditorViewController * editor = [[[PropertyEditorViewController alloc] initWithSetting:[[self.settings objectForKey:@"Network"] objectAtIndex:0]] autorelease];
    [self.navigationController pushViewController:editor animated:YES];
}

#pragma mark - Setting change methods

- (void)usernameChanged:(NSString *)username {
    [[KerberosAccountManager defaultManager] setUsername:username];
    
    NSUInteger indexes[2] = {0,0};
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathWithIndexes:indexes length:2], nil] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)passwordChanged:(NSString *)password {
    [[KerberosAccountManager defaultManager] setPassword:password];
    
    NSUInteger indexes[2] = {0,1};
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathWithIndexes:indexes length:2], nil] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)sourceChanged:(NSString *)source {
    [[KerberosAccountManager defaultManager] setSourceURL:source];
    
    NSUInteger indexes[2] = {1,0};
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathWithIndexes:indexes length:2], nil] withRowAnimation:UITableViewRowAnimationFade];
}

@end
