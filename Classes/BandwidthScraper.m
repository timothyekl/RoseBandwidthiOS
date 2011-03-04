//
//  BandwidthScraper.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/26/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "BandwidthScraper.h"

#import "KerberosAccountManager.h"

#import "XPathQuery.h"

#import "BandwidthUsageRecord.h"

#import "RoseBandwidthAppDelegate.h"

#define FETCH_TIMEOUT 10.0

@interface BandwidthScraper()

- (NSNumber *)numberFromMBUsageString:(NSString *)str;

@end

@implementation BandwidthScraper

@synthesize delegate = _delegate;
@synthesize username = _username;
@synthesize password = _password;

#pragma mark -
#pragma mark Initializer

- (id)initWithDelegate:(id<BandwidthScraperDelegate>)delegate username:(NSString *)username password:(NSString *)password {
    if((self = [super init])) {
        self.delegate = delegate;
        self.username = username;
        self.password = password;
        
        _data = [[NSMutableData alloc] init];
        _state = BandwidthScraperStatePrefix;
    }
    return self;
}

#pragma mark -
#pragma mark Actions

- (void)beginScraping {
    //NSLog(@"scraper received beginScraping");
    
    NSMutableURLRequest * request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[[KerberosAccountManager defaultManager] sourceURL]] 
                                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                              timeoutInterval:FETCH_TIMEOUT] autorelease];
    _conn = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    [_conn start];
    
    if([self.delegate respondsToSelector:@selector(scraper:didDispatchPageRequest:)]) {
        [self.delegate scraper:self didDispatchPageRequest:request];
    }
}

- (void)cancelScraping {
    //NSLog(@"scraper received cancelScraping");
    
    [_conn cancel];
    if([self.delegate respondsToSelector:@selector(scraper:encounteredError:)]) {
        NSError * err = [[[NSError alloc] initWithDomain:@"canceled" code:-1 userInfo:nil] autorelease];
        [self.delegate scraper:self encounteredError:err];
    }
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    //NSLog(@"connection did receive authentication challenge");
    
    NSURLCredential * cred = [[[NSURLCredential alloc] initWithUser:self.username password:self.password persistence:NSURLCredentialPersistenceForSession] autorelease];
    [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"connection did receive data");
    
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"connection did finish loading");
    
    if([self.delegate respondsToSelector:@selector(scraper:didFinishLoadingConnection:)]) {
        [self.delegate scraper:self didFinishLoadingConnection:connection];
    }
    
    NSArray * results = PerformHTMLXPathQuery(_data, @"//div[@class='mainContainer']/table[@class='ms-rteTable-1'][1]/tr[@class='ms-rteTableOddRow-1']/td");
    
    BandwidthUsageRecord * usage = [NSEntityDescription insertNewObjectForEntityForName:@"BandwidthUsageRecord" inManagedObjectContext:[self managedObjectContext]];
    
    [usage setKerberosName:self.username];
    [usage setTimestamp:[NSDate date]];
    [usage setBandwidthClass:[[results objectAtIndex:0] objectForKey:@"nodeContent"]];
    [usage setPolicyReceived:[self numberFromMBUsageString:[[results objectAtIndex:1] objectForKey:@"nodeContent"]]];
    [usage setPolicySent:[self numberFromMBUsageString:[[results objectAtIndex:2] objectForKey:@"nodeContent"]]];
    [usage setActualReceived:[self numberFromMBUsageString:[[results objectAtIndex:3] objectForKey:@"nodeContent"]]];
    [usage setActualSent:[self numberFromMBUsageString:[[results objectAtIndex:4] objectForKey:@"nodeContent"]]];
    
    NSError *error;
    if(![[self managedObjectContext] save:&error]) {
        NSLog(@"error saving MOC: %@", error);
    }
    
    if([self.delegate respondsToSelector:@selector(scraper:foundBandwidthUsageAmounts:)]) {
        [self.delegate scraper:self foundBandwidthUsageAmounts:usage];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"connection did fail with error: %@",[error description]);
    
    if([self.delegate respondsToSelector:@selector(scraper:encounteredError:)]) {
        [self.delegate scraper:self encounteredError:error];
    }
}

#pragma mark -
#pragma mark Helper methods

- (NSNumber *)numberFromMBUsageString:(NSString *)str {
    NSString * stripped = [[str stringByReplacingOccurrencesOfString:@" MB" withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumber * number = [NSDecimalNumber decimalNumberWithString:stripped];
    return number;
}

#pragma mark -
#pragma mark Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    return [((RoseBandwidthAppDelegate *)[[UIApplication sharedApplication] delegate]) managedObjectContext];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [_username release];
    [_password release];
    
    [_data release];
    [_usage release];
    
    [super dealloc];
}

@end
