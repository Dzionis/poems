//
//  PMPoemsDataSource.m
//  Poems
//
//  Created by Dzionis Brek on 2/25/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMPoemsDataSource.h"

// Models
#import "PMPoem.h"
#import "PMPoemEntity+CoreDataClass.h"

// Cells
#import "PMPoemTableViewCell.h"

// Managers
#import "PMTheme.h"

NSString *const kPMPoemEmptySearchString =
    @"Сярод вершаў такіх не маем, пашукайце "
    @"іншыя творы.";
NSString *const kPMPoemEmptyFavoriteString = @"Вы яшчэ не дадалі вершы ў "
                                             @"абранае. Дадаць верш ў абранае "
                                             @"можна на старонцы верша.";

@interface PMPoemsDataSource ()

@property(strong, nonatomic)
NSFetchedResultsController *fetchedResultsController;

@end

@implementation PMPoemsDataSource

#pragma mark - Custom Accessors

- (void)setFetchedResultsController:(NSFetchedResultsController *)controller {
  _fetchedResultsController = controller;
}

#pragma mark - Private

- (UIView *)emptyViewForFrame:(CGRect)frame {
  UIView *view =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame),
                                               CGRectGetHeight(frame))];
  CGFloat labelOffset = 16.0f;
  UILabel *noDataLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(labelOffset, 0, CGRectGetWidth(view.bounds) - labelOffset * 2,
                               CGRectGetHeight(view.bounds))];
  NSString *emptyStateText;
  if (self.isFilterString) {
    emptyStateText = kPMPoemEmptySearchString;
  } else if (self.favorite) {
    emptyStateText = kPMPoemEmptyFavoriteString;
  }
  id<PMTheme> theme = [PMThemeManager sharedTheme];

  noDataLabel.text = emptyStateText;
  noDataLabel.numberOfLines = 0;
  noDataLabel.font = [theme emptyStateFont];
  noDataLabel.textColor = [theme mainColor];
  noDataLabel.textAlignment = NSTextAlignmentCenter;
  [view addSubview:noDataLabel];
  return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.fetchedResultsController.sections.count) {
    tableView.backgroundView = nil;
  } else {
    tableView.backgroundView = [self emptyViewForFrame:tableView.bounds];
  }
  return self.fetchedResultsController.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> sectionInfo =
  self.fetchedResultsController.sections[section];
  return [sectionInfo name];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> sectionInfo =
  self.fetchedResultsController.sections[section];
  
  return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PMPoemEntity *poemEntity =
  [self.fetchedResultsController objectAtIndexPath:indexPath];
  PMPoem *poem = [poemEntity mantleModel];
  
  PMPoemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PMPoemTableViewCell class])];
  [cell fillCellWithTitle:poem.name];
  
  id<NSFetchedResultsSectionInfo> sectionInfo =
  self.fetchedResultsController.sections[indexPath.section];
  BOOL showSeparator = [sectionInfo numberOfObjects] != indexPath.row + 1;
  [cell showSeparator:showSeparator];
  return cell;
}

@end
