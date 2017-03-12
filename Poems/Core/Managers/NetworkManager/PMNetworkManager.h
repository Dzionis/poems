//
//  PMNetworkManager.h
//  Poems
//
//  Created by Dzionis Brek on 2/25/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PMNetworkSuccessBlock)(id responsedObject);
typedef void (^PMNetworkFailedBlock)(NSError *error);

@interface PMNetworkManager : NSObject

+ (instancetype)sharedManager;

- (void)allPoemsWithSuccess:(PMNetworkSuccessBlock)success
                    failure:(PMNetworkFailedBlock)failure;

- (void)checkUpdatesWithLastUpdate:(NSUInteger)lastUpdate
                           success:(PMNetworkSuccessBlock)success
                           failure:(PMNetworkFailedBlock)failure;

@end
