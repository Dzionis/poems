//
//  PMPoem.m
//  Poems
//
//  Created by Dzionis Brek on 2/25/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMPoem.h"

@implementation PMPoem

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
           @"poemID" : @"id",
           @"name" : @"name",
           @"text" : @"text",
           @"year" : @"date",
           @"authorID" : @"author_id",
           };
}

@end
