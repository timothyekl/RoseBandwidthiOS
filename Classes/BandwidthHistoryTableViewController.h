//
//  BandwidthHistoryTableViewController.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BandwidthUsageRecord;

@interface BandwidthHistoryTableViewController : UITableViewController {
    NSMutableArray * _usageHistory;
}

@property (nonatomic, retain) NSMutableArray * usageHistory;

@property (nonatomic, readonly) NSManagedObjectContext * managedObjectContext;

- (void)addRecordForBandwidthUsage:(BandwidthUsageRecord *)usage;
- (void)forceHistoryReload;

@end