//
//  BandwidthScraperDelegate.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/26/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BandwidthScraper;
@class BandwidthUsageRecord;

@protocol BandwidthScraperDelegate <NSObject>

@optional
- (void)scraper:(BandwidthScraper *)scraper didDispatchPageRequest:(NSURLRequest *)request;
- (void)scraper:(BandwidthScraper *)scraper didFinishLoadingConnection:(NSURLConnection *)connection;
- (void)scraper:(BandwidthScraper *)scraper didBeginParsingData:(NSData *)data;
- (void)scraper:(BandwidthScraper *)scraper didFinishParsingData:(NSData *)data;
- (void)scraper:(BandwidthScraper *)scraper foundBandwidthUsageAmounts:(BandwidthUsageRecord *)usage;
- (void)scraper:(BandwidthScraper *)scraper encounteredError:(NSError *)error;

@end
