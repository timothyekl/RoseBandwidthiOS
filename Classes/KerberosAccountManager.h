//
//  KerberosAccountManager.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/25/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KeychainItemWrapper.h"

@interface KerberosAccountManager : NSObject {
    KeychainItemWrapper * itemWrapper;
}

@property (nonatomic, retain) KeychainItemWrapper * itemWrapper;

+ (KerberosAccountManager *)defaultManager;

- (NSString *)getUsername;
- (void)setUsername:(NSString *)username;

- (NSString *)getPassword;
- (void)setPassword:(NSString *)password;

@end
