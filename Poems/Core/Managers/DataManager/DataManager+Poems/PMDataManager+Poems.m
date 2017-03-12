//
//  PMDataManager+Poems.m
//  Poems
//
//  Created by Dzionis Brek on 2/25/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMDataManager+Poems.h"

// Constants
#import "PMConstants.h"

// Managers
#import "PMNetworkManager.h"

// Models
#import "PMPoem.h"
#import "PMPoemEntity+CoreDataClass.h"

@implementation PMDataManager (Poems)

#pragma mark - Public Methods

- (void)fetchAllPoemsWithCompletion:(PMDataManagerCompletionHandler)completion {
  NSNumber *lastUpdate = [self lastUpdate];
  if (lastUpdate && [PMPoemEntity MR_countOfEntities] > 0) {
    [[PMNetworkManager sharedManager]
        checkUpdatesWithLastUpdate:lastUpdate.integerValue
        success:^(id responsedObject) {
          NSNumber *hasUpdate = responsedObject[@"has_update"];
          if (hasUpdate.boolValue) {
            [self poemsWithCompletion:completion];
          }
        }
        failure:^(NSError *error) {
          if (completion) {
            completion(NO, error);
          }
        }];
  } else {
    [self poemsWithCompletion:completion];
  }
}

#pragma mark - Private Methods

- (void)poemsWithCompletion:(PMDataManagerCompletionHandler)completion {
  [[PMNetworkManager sharedManager] allPoemsWithSuccess:^(id responsedObject) {
    NSError *error;
    NSArray<PMPoem *> *poemsArray =
        [MTLJSONAdapter modelsOfClass:[PMPoem class]
                        fromJSONArray:responsedObject
                                error:&error];
    NSLog(@"%@", poemsArray);
    if (poemsArray.count) {
      for (PMPoem *poem in poemsArray) {
        [PMPoemEntity insertPoemEntityWithPoem:poem];
      }
      [self saveLastUpdate];
      [self saveData];
    }
    if (completion) {
      completion(YES, nil);
    }
  }
      failure:^(NSError *error) {
        if (completion) {
          completion(NO, error);
        }
      }];
}

- (void)saveLastUpdate {
  NSTimeInterval lastUpdate = [[NSDate date] timeIntervalSince1970];
  [[NSUserDefaults standardUserDefaults]
      setObject:@(lastUpdate)
         forKey:kPMUserDefaultsLastUpdateKey];
}

- (NSNumber *)lastUpdate {
  return [[NSUserDefaults standardUserDefaults]
      objectForKey:kPMUserDefaultsLastUpdateKey];
}

@end
