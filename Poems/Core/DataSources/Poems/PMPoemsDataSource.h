//
//  PMPoemsDataSource.h
//  Poems
//
//  Created by Dzionis Brek on 2/25/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PMPoemsDataSource : NSObject<UITableViewDataSource>

@property(assign, nonatomic) BOOL favorite;
@property(assign, nonatomic, getter=isFilterString) BOOL filterString;

/*!
 *  @discussion Sets a fetched results controller that efficiently manages the
 *              results returned from a Core Data fetch request to provide data
 *              for the poems list view controller.
 *  @param controller A NSFetchedResultsController object.
 */
- (void)setFetchedResultsController:(NSFetchedResultsController *)controller;

@end
