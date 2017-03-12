//
//  PMDataManager.h
//  Poems
//
//  Created by Dzionis Brek on 2/25/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PMDataManagerCompletionHandler)(BOOL success, NSError *error);

@interface PMDataManager : NSObject

+ (instancetype)sharedManager;

- (void)clearData;
- (void)saveData;

@end
