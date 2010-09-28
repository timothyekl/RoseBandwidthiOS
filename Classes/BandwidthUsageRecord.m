//
//  BandwidthUsageRecord.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "BandwidthUsageRecord.h"


@implementation BandwidthUsageRecord

@dynamic kerberosName;
@dynamic timestamp;
@dynamic policyReceived;
@dynamic policySent;
@dynamic actualReceived;
@dynamic actualSent;
@dynamic bandwidthClass;

- (void)awakeFromInsert {
	// Custom initialization here
}

@end
