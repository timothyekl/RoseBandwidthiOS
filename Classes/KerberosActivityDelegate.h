//
//  KerberosActivityDelegate.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KerberosActivityDelegate <NSObject>

@optional
- (void)kerberosAccountChanged;

@end
