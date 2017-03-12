//
//  PMPoemEntity+CoreDataClass.h
//
//
//  Created by Dzionis Brek on 2/25/17.
//
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PMPoem;

NS_ASSUME_NONNULL_BEGIN

@interface PMPoemEntity : NSManagedObject

+ (instancetype)insertPoemEntityWithPoem:(PMPoem *)poem;
+ (instancetype)insertPoemEntityWithPoem:(PMPoem *)poem
                               inContext:(NSManagedObjectContext *)context;
- (PMPoem *)mantleModel;
- (void)fillEntityWithModel:(PMPoem *)model;
- (NSString *)firstLetter;

@end

NS_ASSUME_NONNULL_END

#import "PMPoemEntity+CoreDataProperties.h"
