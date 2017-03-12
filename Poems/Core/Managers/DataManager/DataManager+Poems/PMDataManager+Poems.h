//
//  PMDataManager+Poems.h
//  Poems
//
//  Created by Dzionis Brek on 2/25/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMDataManager.h"

@interface PMDataManager (Poems)

- (void)fetchAllPoemsWithCompletion:(PMDataManagerCompletionHandler)
completion;

@end
