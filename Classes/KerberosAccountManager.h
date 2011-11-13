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
    
    NSDictionary * _itemWrappers;
}

@property (nonatomic, strong) KeychainItemWrapper * itemWrapper;

@property(nonatomic, strong) NSDictionary * itemWrappers;

@property(nonatomic, unsafe_unretained) NSString * username;
@property(nonatomic, unsafe_unretained) NSString * password;
@property(nonatomic, unsafe_unretained) NSString * sourceURL;

+ (KerberosAccountManager *)defaultManager;

@end
