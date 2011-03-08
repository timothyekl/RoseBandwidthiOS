//
//  BandwidthHistoryTableViewController.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BandwidthUsageRecord;

@interface BandwidthHistoryTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSMutableArray * _usageHistory;
    
    NSFetchedResultsController * _fetchedResultsController;
}

@property (nonatomic, retain) NSMutableArray * usageHistory;

@property (nonatomic, readonly) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsController;

- (void)forceHistoryReload;

@end