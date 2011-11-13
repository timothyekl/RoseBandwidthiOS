//
//  BandwidthScraper.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/26/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BandwidthScraperDelegate.h"

//@class BandwidthUsage;

typedef enum {
    BandwidthScraperStatePrefix,
    BandwidthScraperStateOverall,
    BandwidthScraperStateIndividual,
    BandwidthScraperStateSuffix
} BandwidthScraperState;

@interface BandwidthScraper : NSObject <NSXMLParserDelegate> {
    id<BandwidthScraperDelegate> __unsafe_unretained _delegate;
    
    NSMutableData * _data;
    //BandwidthUsage * _usage;
    BandwidthScraperState _state;
    
    NSURLConnection * _conn;
}

@property (nonatomic, unsafe_unretained) id<BandwidthScraperDelegate> delegate;

- (id)initWithDelegate:(id<BandwidthScraperDelegate>)delegate;
- (void)beginScraping;
- (void)cancelScraping;

- (NSManagedObjectContext *)managedObjectContext;

@end
