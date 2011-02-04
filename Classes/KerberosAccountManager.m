//
//  KerberosAccountManager.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/25/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "KerberosAccountManager.h"

static KerberosAccountManager * _defaultManager = nil;

static const NSString * kSecureDataItemIDUsername = @"kSecureDataItemIDUsername";
static const NSString * kSecureDataItemIDPassword = @"kSecureDataItemIDPassword";
static const NSString * kSecureDataItemIDSourceURL = @"kSecureDataItemIDSourceURL";

@implementation KerberosAccountManager

@synthesize itemWrapper;
@synthesize itemWrappers = _itemWrappers;

#pragma mark -
#pragma mark Singleton management methods

+ (KerberosAccountManager *)defaultManager {
    @synchronized(self) {
        if(nil == _defaultManager) {
            _defaultManager = [[KerberosAccountManager alloc] init];
        }
    }
    return _defaultManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if(nil == _defaultManager) {
            _defaultManager = [super allocWithZone:zone];
            return _defaultManager;
        }
    }
    return nil;
}

- (id)init {
    if((self = [super init])) {
        self.itemWrapper = [[[KeychainItemWrapper alloc] initWithIdentifier:@"Kerberos Info" accessGroup:@"KPAZKHDUAP.com.brousalis.RoseBandwidth"] autorelease];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

#pragma mark -
#pragma mark Kerberos info methods

- (NSString *)username {
    return [self.itemWrapper objectForKey:(id)kSecAttrAccount];
}
- (void)setUsername:(NSString *)username {
    [self.itemWrapper setObject:username forKey:(id)kSecAttrAccount];
}

- (NSString *)password {
    return [self.itemWrapper objectForKey:(id)kSecValueData];
}
- (void)setPassword:(NSString *)password {
    [self.itemWrapper setObject:password forKey:(id)kSecValueData];
}

- (NSString *)sourceURL {
    //TODO allow for changes here
    return @"https://netreg.rose-hulman.edu/tools/networkUsage.pl";
}
- (void)setSourceURL:(NSString *)sourceURL {
    //TODO handle this
}

@end
