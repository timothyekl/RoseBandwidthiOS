//
//  BandwidthUsageViewController.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/25/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "BandwidthScraperDelegate.h"

@class VerticalProgressView;
@class BandwidthUsageRecord;

typedef enum {
    kBandwidthUsagePolicy = 0,
    kBandwidthUsageActual = 1
} kBandwidthUsage;

@interface BandwidthUsageViewController : UIViewController <ADBannerViewDelegate> {
    UILabel * _titleLabel;
    
    UISegmentedControl * _measureControl;
    
    VerticalProgressView * _leftUsageView;
    VerticalProgressView * _rightUsageView;
    
    UILabel * _leftUsageLabel;
    UILabel * _rightUsageLabel;
    
    UIBarButtonItem * _refreshItem;
    
    BandwidthUsageRecord * _currentUsage;
    
    ADBannerView * _adBannerView;
    
    BOOL _updating;

@private
    BOOL _failedAdLoad;
}

@property (unsafe_unretained, nonatomic, readonly) NSManagedObjectContext * managedObjectContext;

@property (nonatomic, strong) IBOutlet UILabel * titleLabel;

@property (nonatomic, strong) IBOutlet UISegmentedControl * measureControl;

@property (nonatomic, strong) IBOutlet VerticalProgressView * leftUsageView;
@property (nonatomic, strong) IBOutlet VerticalProgressView * rightUsageView;

@property (nonatomic, strong) IBOutlet UILabel * leftUsageLabel;
@property (nonatomic, strong) IBOutlet UILabel * rightUsageLabel;

@property (nonatomic, strong) BandwidthUsageRecord * currentUsage;

@property (nonatomic, strong) IBOutlet ADBannerView * adBannerView;

@property (nonatomic, assign) BOOL updating;

- (IBAction)requestBandwidthUpdate;
- (IBAction)measureControlValueChanged:(id)sender;

- (void)forceBandwidthDisplayReload;
- (void)updateVisibleBandwidthWithUsageRecord:(BandwidthUsageRecord *)usage;

- (void)shiftContentWithMultiplier:(float)mult animated:(BOOL)animated;

@end
