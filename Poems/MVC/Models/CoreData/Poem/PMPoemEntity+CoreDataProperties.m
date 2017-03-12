//
//  PMPoemEntity+CoreDataProperties.m
//
//
//  Created by Dzionis Brek on 2/25/17.
//
//

#import "PMPoemEntity+CoreDataProperties.h"

@implementation PMPoemEntity (CoreDataProperties)

+ (NSFetchRequest<PMPoemEntity *> *)fetchRequest {
  return [[NSFetchRequest alloc] initWithEntityName:@"PMPoemEntity"];
}

@dynamic authorID;
@dynamic poemID;
@dynamic name;
@dynamic text;
@dynamic year;
@dynamic favorite;

@end
