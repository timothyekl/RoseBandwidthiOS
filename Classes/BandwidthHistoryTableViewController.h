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

@property (nonatomic, strong) NSMutableArray * usageHistory;

@property (unsafe_unretained, nonatomic, readonly) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;

- (void)forceHistoryReload;

@end