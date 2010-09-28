//
//  BandwidthScraper.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/26/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BandwidthScraperDelegate.h"

@class BandwidthUsage;

typedef enum {
    BandwidthScraperStatePrefix,
    BandwidthScraperStateOverall,
    BandwidthScraperStateIndividual,
    BandwidthScraperStateSuffix
} BandwidthScraperState;

@interface BandwidthScraper : NSObject <NSXMLParserDelegate> {
    id<BandwidthScraperDelegate> _delegate;
    
    NSString * _username;
    NSString * _password;
    
    NSMutableData * _data;
    BandwidthUsage * _usage;
    BandwidthScraperState _state;
}

@property (nonatomic, assign) id<BandwidthScraperDelegate> delegate;

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;

- (id)initWithDelegate:(id<BandwidthScraperDelegate>)delegate username:(NSString *)username password:(NSString *)password;
- (void)beginScraping;

- (NSManagedObjectContext *)managedObjectContext;

@end
