//
//  PMDataManager.m
//  Poems
//
//  Created by Dzionis Brek on 2/25/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMDataManager.h"

// MagicalRecord
#import <MagicalRecord/MagicalRecord.h>

@implementation PMDataManager

#pragma mark - Public Methods

+ (instancetype)sharedManager {
  __strong static PMDataManager *sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[PMDataManager alloc] init];
  });
  return sharedInstance;
}

- (void)clearData {
  [MagicalRecord cleanUp];
}

- (void)saveData {
  [[NSManagedObjectContext MR_defaultContext]
      MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave,
                                               NSError *_Nullable error) {
        if (contextDidSave) {
          NSLog(@"ManagedObjectContext saved");
        } else {
          NSLog(@"ManagedObjectContext not saved");
        }
      }];
}

@end
