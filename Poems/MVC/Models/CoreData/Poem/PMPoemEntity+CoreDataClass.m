//
//  PMPoemEntity+CoreDataClass.m
//  
//
//  Created by Dzionis Brek on 2/25/17.
//
//  This file was automatically generated and should not be edited.
//

#import "PMPoemEntity+CoreDataClass.h"

// Magical Record
#import <MagicalRecord/MagicalRecord.h>

// Models
#import "PMPoem.h"

@implementation PMPoemEntity

#pragma mark - Public

+ (instancetype)insertPoemEntityWithPoem:(PMPoem *)poem {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  return [PMPoemEntity insertPoemEntityWithPoem:poem inContext:context];
}

+ (instancetype)insertPoemEntityWithPoem:(PMPoem *)poem
                               inContext:(NSManagedObjectContext *)context {
  if (!context) {
    context = [NSManagedObjectContext MR_defaultContext];
  }
  
  NSPredicate *poemPredicate =
  [NSPredicate predicateWithFormat:@"poemID == %@", poem.poemID];
  
  PMPoemEntity* poemEntity =
  [PMPoemEntity MR_findFirstWithPredicate:poemPredicate inContext:context];
  
  if (!poemEntity) {
    poemEntity = [PMPoemEntity MR_createEntityInContext:context];
  }
  [poemEntity fillEntityWithModel:poem];
  return poemEntity;
}

- (PMPoem *)mantleModel {
  PMPoem *poem = [[PMPoem alloc] init];
  
  poem.poemID = self.poemID;
  poem.name = self.name;
  poem.text = self.text;
  poem.authorID = self.authorID;
  poem.year = self.year;
  poem.favorite = self.favorite;
  
  return poem;
}

- (void)fillEntityWithModel:(PMPoem *)model {
  self.poemID = model.poemID;
  self.name = model.name;
  self.text = model.text;
  self.authorID = model.authorID;
  self.year = model.year;
  if (model.favorite) {
    self.favorite = model.favorite;
  }
}

- (NSString *)firstLetter {
  NSString *firstLetter = [self.name substringToIndex:1];
  if (!firstLetter.length) {
    firstLetter = [self.text substringToIndex:1];
  }
  if (!firstLetter.length) {
    firstLetter = nil;
  }
  return firstLetter;
}

@end
