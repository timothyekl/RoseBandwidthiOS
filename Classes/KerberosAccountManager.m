//
//  KerberosAccountManager.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/25/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "KerberosAccountManager.h"

@implementation KerberosAccountManager

@synthesize itemWrapper;
@synthesize itemWrappers = _itemWrappers;

#pragma mark -
#pragma mark Singleton management methods

+ (KerberosAccountManager *)defaultManager {
    static dispatch_once_t dispatch_token;
    __strong static KerberosAccountManager * _defaultManager = nil;
    dispatch_once(&dispatch_token, ^{
        _defaultManager = [[self alloc] init];
    });
    return _defaultManager;
}

- (id)init {
    if((self = [super init])) {
        self.itemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Kerberos Info" accessGroup:@"XRNKDMNJWT.com.lithium3141.RoseBandwidth"];
    }
    return self;
}

#pragma mark -
#pragma mark Kerberos info methods

- (NSString *)username {
    return [self.itemWrapper objectForKey:(__bridge id)kSecAttrAccount];
}
- (void)setUsername:(NSString *)username {
    [self.itemWrapper setObject:username forKey:(__bridge id)kSecAttrAccount];
}

- (NSString *)password {
    return [self.itemWrapper objectForKey:(__bridge id)kSecValueData];
}
- (void)setPassword:(NSString *)password {
    [self.itemWrapper setObject:password forKey:(__bridge id)kSecValueData];
}

- (NSString *)sourceURL {
    //TODO allow for changes here
    //return @"https://netreg.rose-hulman.edu/tools/networkUsage.pl";
    return [self.itemWrapper objectForKey:(__bridge id)kSecAttrService];
}
- (void)setSourceURL:(NSString *)sourceURL {
    //TODO handle this
    [self.itemWrapper setObject:sourceURL forKey:(__bridge id)kSecAttrService];
}

@end
