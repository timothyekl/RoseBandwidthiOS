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

@property (nonatomic, strong) NSString * kerberosName;
@property (nonatomic, strong) NSDate * timestamp;
@property (nonatomic, strong) NSNumber * policyReceived;
@property (nonatomic, strong) NSNumber * policySent;
@property (nonatomic, strong) NSNumber * actualReceived;
@property (nonatomic, strong) NSNumber * actualSent;
@property (nonatomic, strong) NSString * bandwidthClass;

@property (nonatomic, strong) NSString * sectionIdentifier;
@property (nonatomic, strong) NSString * primitiveSectionIdentifier;

@end
