//
//  StoredSettingsManager.m
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoredSettingsManager.h"

static NSString * kWarningLevelKey = @"warningLevel";
static NSString * kAlertLevelKey = @"alertLevel";
static NSString * kFirstRunKey = @"firstRun";

@implementation StoredSettingsManager

@synthesize warningLevel = _warningLevel;
@synthesize alertLevel = _alertLevel;
@synthesize firstRun = _firstRun;

#pragma mark - Lifecycle

- (id)init {
    if((self = [super init])) {
        [self readSettingsFromFile];
    }
    return self;
}

- (void)readSettingsFromFile {
    NSLog(@"Reading settings property list...");
    
    // Find file path - search app directory first, then bundle if no local copy exists
    NSString * plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"Settings.plist"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    }
    
    // Grab data and parse
    NSData * plistXML = [NSData dataWithContentsOfFile:plistPath];
    NSDictionary * plistData = [NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:NULL errorDescription:nil];
    if(!plistData) {
        NSLog(@"Error reading settings property list");
    }
    
    // Set properties
    self.warningLevel = [[plistData objectForKey:kWarningLevelKey] floatValue];
    self.alertLevel = [[plistData objectForKey:kAlertLevelKey] floatValue];
    if(nil == [plistData objectForKey:kFirstRunKey]) {
        self.firstRun = YES;
    } else {
        self.firstRun = [[plistData objectForKey:kFirstRunKey] boolValue];
    }
}

- (void)writeSettingsToFile {
    NSLog(@"Writing settings property list...");
    
    // Find file path - always write to app directory
    NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * plistPath = [rootPath stringByAppendingPathComponent:@"Settings.plist"];
    
    NSMutableDictionary * plistDict = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    [plistDict setValue:[NSNumber numberWithFloat:self.warningLevel] forKey:kWarningLevelKey];
    [plistDict setValue:[NSNumber numberWithFloat:self.alertLevel] forKey:kAlertLevelKey];
    [plistDict setValue:[NSNumber numberWithBool:self.firstRun] forKey:kFirstRunKey];
    NSData * plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    } else {
        NSLog(@"Error writing settings property list");
    }
}

#pragma mark - Singleton methods

+ (StoredSettingsManager *)sharedManager {
    static dispatch_once_t dispatch_token;
    __strong static StoredSettingsManager * _defaultManager = nil;
    dispatch_once(&dispatch_token, ^{
        _defaultManager = [[self alloc] init];
    });
    return _defaultManager;
}

@end