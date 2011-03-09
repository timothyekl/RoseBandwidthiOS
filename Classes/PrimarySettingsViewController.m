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

#import "StoredSettingsManager.h"

#import "RoseBandwidthTabBarController.h"

@implementation PrimarySettingsViewController

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:2] autorelease];
    
    Setting * usernameSetting = [[[Setting alloc] initWithTitle:NSLocalizedString(@"Username", @"Username")
                                                         target:self 
                                                        onValue:@selector(username) 
                                                       onAction:@selector(editAction:) 
                                                       onChange:@selector(usernameChanged:)] autorelease];
    Setting * passwordSetting = [[[Setting alloc] initWithTitle:NSLocalizedString(@"Password", @"Password")
                                                         target:self 
                                                        onValue:@selector(password) 
                                                       onAction:@selector(editAction:) 
                                                       onChange:@selector(passwordChanged:)] autorelease];
    passwordSetting.secure = YES;
    NSArray * authenticationSettings = [[[NSArray alloc] initWithObjects:usernameSetting, passwordSetting, nil] autorelease];
    [self.settings setObject:authenticationSettings forKey:NSLocalizedString(@"Authentication", @"Authentication")];
    
    Setting * warningLevelSetting = [[[Setting alloc] initWithTitle:NSLocalizedString(@"Warning level", @"Warning level")
                                                             target:self
                                                            onValue:@selector(warningLevel)
                                                           onAction:@selector(editAction:)
                                                           onChange:@selector(warningLevelChanged:)] autorelease];
    warningLevelSetting.valueType = SettingValueTypeDecimal;
    Setting * alertLevelSetting = [[[Setting alloc] initWithTitle:NSLocalizedString(@"Alert level", @"Alert level")
                                                           target:self 
                                                          onValue:@selector(alertLevel)
                                                         onAction:@selector(editAction:)
                                                         onChange:@selector(alertLevelChanged:)] autorelease];
    alertLevelSetting.valueType = SettingValueTypeDecimal;
    NSArray * displaySettings = [[[NSArray alloc] initWithObjects:warningLevelSetting, alertLevelSetting, nil] autorelease];
    [self.settings setObject:displaySettings forKey:NSLocalizedString(@"Display", @"Display")];
    
    Setting * sourceSetting = [[[Setting alloc] initWithTitle:NSLocalizedString(@"Source", @"Source")
                                                       target:self 
                                                      onValue:@selector(source) 
                                                     onAction:@selector(editAction:) 
                                                     onChange:@selector(sourceChanged:)] autorelease];
    NSArray * networkSettings = [[[NSArray alloc] initWithObjects:sourceSetting, nil] autorelease];
    [self.settings setObject:networkSettings forKey:NSLocalizedString(@"Network", @"Network")];
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

- (NSString *)warningLevel {
    return [NSString stringWithFormat:@"%.1f", [[StoredSettingsManager sharedManager] warningLevel]];
}

- (NSString *)alertLevel {
    return [NSString stringWithFormat:@"%.1f", [[StoredSettingsManager sharedManager] alertLevel]];
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
    
    [(RoseBandwidthTabBarController *)(self.tabBarController) kerberosAccountInfoChanged];
}

- (void)passwordChanged:(NSString *)password {
    [[KerberosAccountManager defaultManager] setPassword:password];
    
    NSUInteger indexes[2] = {0,1};
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathWithIndexes:indexes length:2], nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [(RoseBandwidthTabBarController *)(self.tabBarController) kerberosAccountInfoChanged];
}

- (void)sourceChanged:(NSString *)source {
    [[KerberosAccountManager defaultManager] setSourceURL:source];
    
    NSUInteger indexes[2] = {2,0};
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathWithIndexes:indexes length:2], nil] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)warningLevelChanged:(NSString *)level {
    NSScanner * scanner = [NSScanner scannerWithString:level];
    float value;
    if(![scanner scanFloat:&value]) {
        value = 0.0;
    }
    [[StoredSettingsManager sharedManager] setWarningLevel:value];
    [[StoredSettingsManager sharedManager] writeSettingsToFile];
    
    NSUInteger indexes[2] = {1,0};
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathWithIndexes:indexes length:2], nil] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)alertLevelChanged:(NSString *)level {
    NSScanner * scanner = [NSScanner scannerWithString:level];
    float value;
    if(![scanner scanFloat:&value]) {
        value = 0.0;
    }
    [[StoredSettingsManager sharedManager] setAlertLevel:value];
    [[StoredSettingsManager sharedManager] writeSettingsToFile];
    
    NSUInteger indexes[2] = {1,1};
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathWithIndexes:indexes length:2], nil] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Special case table view footer

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 0) {
        return NSLocalizedString(@"disclaimer", @"disclaimer");
    }
    return nil;
}

@end
