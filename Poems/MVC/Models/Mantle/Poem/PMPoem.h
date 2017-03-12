//
//  PMPoem.h
//  Poems
//
//  Created by Dzionis Brek on 2/25/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PMPoem : MTLModel<MTLJSONSerializing>

@property(strong, nonatomic) NSNumber *poemID;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *text;
@property(strong, nonatomic) NSNumber *year;
@property(strong, nonatomic) NSNumber *favorite;
@property(strong, nonatomic) NSNumber *authorID;

@end
