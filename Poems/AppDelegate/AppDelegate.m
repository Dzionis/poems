//
//  AppDelegate.m
//  Poems
//
//  Created by Dzionis Brek on 2/19/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "AppDelegate.h"

// MagicalRecord
#import <MagicalRecord/MagicalRecord.h>

// Theme
#import "PMTheme.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self setupCoreDataStackWithMagicalRecord];
  [PMThemeManager customizeAppAppearance];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark - Core Data

- (void)setupCoreDataStackWithMagicalRecord {
  [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];
  [MagicalRecord cleanUp];
  [MagicalRecord setupCoreDataStack];
  [MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
}

@end
