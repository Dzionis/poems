//
//  PMPoemEntity+CoreDataProperties.h
//
//
//  Created by Dzionis Brek on 2/25/17.
//
//

#import "PMPoemEntity+CoreDataClass.h"

// Magical Record
#import <MagicalRecord/MagicalRecord.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMPoemEntity (CoreDataProperties)

+ (NSFetchRequest<PMPoemEntity *> *)fetchRequest;

@property(nullable, nonatomic, copy) NSNumber *authorID;
@property(nullable, nonatomic, copy) NSNumber *poemID;
@property(nullable, nonatomic, copy) NSString *name;
@property(nullable, nonatomic, copy) NSString *text;
@property(nullable, nonatomic, copy) NSNumber *year;
@property(nullable, nonatomic, copy) NSNumber *favorite;

@end

NS_ASSUME_NONNULL_END
