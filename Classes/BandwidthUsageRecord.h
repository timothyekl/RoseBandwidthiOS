//
//  BandwidthUsageRecord.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BandwidthUsageRecord : NSManagedObject {

}

@property (nonatomic, retain) NSString * kerberosName;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * policyReceived;
@property (nonatomic, retain) NSNumber * policySent;
@property (nonatomic, retain) NSNumber * actualReceived;
@property (nonatomic, retain) NSNumber * actualSent;
@property (nonatomic, retain) NSString * bandwidthClass;

@end
