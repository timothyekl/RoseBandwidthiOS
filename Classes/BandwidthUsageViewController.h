//
//  BandwidthUsageViewController.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/25/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BandwidthScraperDelegate.h"

@class VerticalProgressView;
@class BandwidthUsageRecord;

typedef enum {
    kBandwidthUsagePolicy = 0,
    kBandwidthUsageActual = 1
} kBandwidthUsage;

@interface BandwidthUsageViewController : UIViewController {
    UISegmentedControl * _measureControl;
    
    VerticalProgressView * _leftUsageView;
    VerticalProgressView * _rightUsageView;
    
    UILabel * _leftUsageLabel;
    UILabel * _rightUsageLabel;
    
    UIButton * _refreshButton;
    
    BandwidthUsageRecord * _currentUsage;
    
    BOOL _updating;
}

@property (nonatomic, readonly) NSManagedObjectContext * managedObjectContext;

@property (nonatomic, retain) IBOutlet UISegmentedControl * measureControl;

@property (nonatomic, retain) IBOutlet VerticalProgressView * leftUsageView;
@property (nonatomic, retain) IBOutlet VerticalProgressView * rightUsageView;

@property (nonatomic, retain) IBOutlet UILabel * leftUsageLabel;
@property (nonatomic, retain) IBOutlet UILabel * rightUsageLabel;

@property (nonatomic, retain) IBOutlet UIButton * refreshButton;

@property (nonatomic, retain) BandwidthUsageRecord * currentUsage;

@property (nonatomic, assign) BOOL updating;

- (IBAction)requestBandwidthUpdate;
- (IBAction)measureControlValueChanged:(id)sender;
- (void)updateVisibleBandwidthWithUsageRecord:(BandwidthUsageRecord *)usage;

@end
