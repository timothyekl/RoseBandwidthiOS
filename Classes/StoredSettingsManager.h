//
//  StoredSettingsManager.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StoredSettingsManager : NSObject {
@private
    float _warningLevel;
    float _alertLevel;
    BOOL _firstRun;
}

@property (nonatomic, assign) float warningLevel;
@property (nonatomic, assign) float alertLevel;
@property (nonatomic, assign, getter = isFirstRun) BOOL firstRun;

/**
 * The shared instance of this singleton class. Used to access an instance
 * of StoredSettingsManager, which can then be used to gain access to
 * individual stored settings.
 */
+ (StoredSettingsManager *)sharedManager;

/**
 * Read all stored settings from their backing plist file. This
 * method is called once when StoredSettingsManager is first instatiated,
 * populating all settings through the manager. It may be called at any
 * point subsequent to force a re-read of all settings.
 */
- (void)readSettingsFromFile;

/**
 * Write all stored settings to their backing plist file. This method is
 * called from the app delegate before the application terminates to save all
 * settings back to disk; it may be called at any time prior to that in order
 * to force a save (e.g. before a potentially dangerous or long-running
 * operation).
 */
- (void)writeSettingsToFile;

@end
