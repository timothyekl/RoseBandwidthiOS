//
//  BandwidthUsageRecord.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "BandwidthUsageRecord.h"

NSInteger dateIdentifier(NSInteger year, NSInteger month, NSInteger day) {
    return 1000000 * year + 1000 * month + day;
}

@implementation BandwidthUsageRecord

@dynamic kerberosName;
@dynamic timestamp;
@dynamic policyReceived;
@dynamic policySent;
@dynamic actualReceived;
@dynamic actualSent;
@dynamic bandwidthClass;

@dynamic sectionIdentifier;
@dynamic primitiveSectionIdentifier;

#pragma mark - Transient identifiers

- (NSString *)sectionIdentifier {
    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString * tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];
    
    if(nil == tmp) {
        NSCalendar * calendar = [NSCalendar currentCalendar];
        NSDateComponents * components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[self timestamp]];
        tmp = [NSString stringWithFormat:@"%d", dateIdentifier([components year], [components month], [components day])];
        [self setPrimitiveSectionIdentifier:tmp];
    }
    
    return tmp;
}

@end
