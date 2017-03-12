//
//  ViewController.m
//  Poems
//
//  Created by Dzionis Brek on 2/19/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMListViewController.h"

// Constants
#import "PMConstants.h"

// Controllers
#import "PMPoemViewController.h"
#import "PMPoemPageViewController.h"

// Models
#import "PMPoemEntity+CoreDataClass.h"

// Managers
#import "PMDataManager+Poems.h"
#import "PMTheme.h"

// Models
#import "PMPoem.h"

// DataSource
#import "PMPoemsDataSource.h"

// Views
#import "PMPoemListSectionView.h"

// Categories
#import "UIImage+FromColor.h"

NSString *const kPMListTitle = @"УСЕ ТВОРЫ";
NSString *const kPMFavoriteTitle = @"АБРАНЫЯ ТВОРЫ";

@interface PMListViewController () <UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *poems;

/**
 DataSource provides poems for poems list view controller.
 */
@property(strong, nonatomic) PMPoemsDataSource *dataSource;

/**
 Fetched Results Controller used for fetching from Core Data.
 */
@property(strong, nonatomic)
NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UILabel *tableTitleLabel;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation PMListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self customizeNavigationBar];
  [self customizeSearchBar];
  [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  id<PMTheme> theme = [PMThemeManager sharedTheme];
  [self.navigationController.navigationBar setShadowImage:[UIImage imageFromColor:[theme grayColor]]];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Custom Accessors

- (NSFetchedResultsController *)fetchedResultsController {
  if (_fetchedResultsController == nil) {
    NSFetchRequest *fetchRequest =
    [NSFetchRequest fetchRequestWithEntityName:@"PMPoemEntity"];
    
    NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"name"
                                  ascending:YES
                                   selector:@selector(localizedCaseInsensitiveCompare:)];
    
    fetchRequest.sortDescriptors = @[ sortDescriptor ];
    fetchRequest.fetchBatchSize = 50;
    if (self.favorite) {
      fetchRequest.predicate = [NSPredicate predicateWithFormat:@"favorite = YES"];
    }
    
    NSManagedObjectContext *context =
    [NSManagedObjectContext MR_defaultContext];
    
    _fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:context
                                          sectionNameKeyPath:@"firstLetter"
                                                   cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    // This call retrieves the initial data to be displayed and causes the
    // NSFetchedResultsController instance to start monitoring
    // the managed object context for changes.
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
      NSLog(@"Failed to initialize FetchedResultsController: %@\n%@",
            [error localizedDescription], [error userInfo]);
      abort();
    }
  }
  
  return _fetchedResultsController;
}

#pragma mark - Private

- (void)hideKeyboard {
  [self.view endEditing:YES];
}

- (void)openFavorite:(UIBarButtonItem *)sender {
  PMListViewController *listViewController = [PMListViewController viewControllerFromStoryboard];
  listViewController.favorite = YES;
  [self.navigationController pushViewController:listViewController animated:YES];
}

- (void)backAction:(UIBarButtonItem *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)customizeSearchBar {
  id<PMTheme> theme = [PMThemeManager sharedTheme];
  
  [self.searchBar setImage:[theme imageSearch] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
  
  UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
  if ([searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
    UIColor *color = [theme mainColor];
    [searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: [color colorWithAlphaComponent:0.8f]}]];
  }
}

- (void)configureTableView {
  UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
  gestureRecognizer.cancelsTouchesInView = NO;
  [self.tableView addGestureRecognizer:gestureRecognizer];
  
  self.dataSource = [[PMPoemsDataSource alloc] init];
  [self.dataSource setFetchedResultsController:self.fetchedResultsController];
  self.dataSource.favorite = self.favorite;
  self.dataSource.filterString = NO;
  self.tableView.dataSource = self.dataSource;
  [self.tableView setContentOffset:CGPointMake(0, 38.0f)];
}

- (void)customizeNavigationBar {
  id<PMTheme> theme = [PMThemeManager sharedTheme];
  
  UILabel *titleLabel = [theme labelForMainNavigationTitle];
  self.navigationItem.titleView = titleLabel;
  self.title = @" ";
  
  if (!self.favorite) {
    [[PMDataManager sharedManager] fetchAllPoemsWithCompletion:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[theme imageFavoriteForNavigationBar] style:UIBarButtonItemStylePlain target:self action:@selector(openFavorite:)];
    
    self.tableTitleLabel.text = kPMListTitle;
  } else {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[theme imageBackForNavigationBar] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    self.tableTitleLabel.text = kPMFavoriteTitle;
  }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.view endEditing:YES];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  PMPoemEntity *poemEntity =
  [self.fetchedResultsController objectAtIndexPath:indexPath];
  PMPoem *poem = [poemEntity mantleModel];
  PMPoemPageViewController *poemPageViewController = [PMPoemPageViewController viewControllerFromStoryboard];
  poemPageViewController.title = poem.name;
  poemPageViewController.poem = poem;
  poemPageViewController.favorite = self.favorite;
  [self.navigationController pushViewController:poemPageViewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  id<NSFetchedResultsSectionInfo> sectionInfo =
  self.fetchedResultsController.sections[section];
  
  PMPoemListSectionView *sectionHeaderView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PMPoemListSectionView class]) owner:self options:nil] firstObject];
  [sectionHeaderView fillWithLetter:[sectionInfo name]];
  
  return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 40.0f;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  // Disabling update Animation.
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  
  [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
  
  // Finish disabling update animation.
  [CATransaction commit];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
  
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
    default: { break; }
  }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
  switch (type) {
    case NSFetchedResultsChangeInsert: {
      [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ]
                            withRowAnimation:UITableViewRowAnimationNone];
      break;
    }
      
    case NSFetchedResultsChangeDelete: {
      [self.tableView deleteRowsAtIndexPaths:@[ indexPath ]
                            withRowAnimation:UITableViewRowAnimationNone];
      break;
    }
      
    case NSFetchedResultsChangeUpdate: {
      [self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
                            withRowAnimation:UITableViewRowAnimationNone];
      break;
    }
      
    case NSFetchedResultsChangeMove: {
      [self.tableView deleteRowsAtIndexPaths:@[ indexPath ]
                            withRowAnimation:UITableViewRowAnimationNone];
      [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ]
                            withRowAnimation:UITableViewRowAnimationNone];
      break;
    }
      
    default: { break; }
  }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  // Get refrence of vertical indicator
  UIImageView *verticalIndicator = ((UIImageView *)[scrollView.subviews
                                                    objectAtIndex:(scrollView.subviews.count - 1)]);
  // Set color to vertical indicator
  
  [verticalIndicator setBackgroundColor:[UIColor redColor]];
  verticalIndicator.layer.cornerRadius = 2.0f;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [self.view endEditing:YES];
}

#pragma mark - UISearchBarDelegate

// First use the Searchbar delegate methods
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  [self filterContentForSearchText:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [self filterContentForSearchText:searchBar.text];
  [searchBar resignFirstResponder];
}

// The method to change the predicate of the FRC
- (void)filterContentForSearchText:(NSString*)searchText
{
  
  self.dataSource.filterString = searchText.length;
  NSString *query = searchText;
  NSPredicate *predicate;
  if (query && query.length) {
    if (self.favorite) {
      predicate = [NSPredicate predicateWithFormat:@"(name contains[cd] %@ or text contains[cd] %@) and favorite = YES", query, query];
    } else {
      predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@ or text contains[cd] %@", query, query];
    }
  } else {
    if (self.favorite) {
      predicate = [NSPredicate predicateWithFormat:@"favorite = YES"];
    }
  }
  [self.fetchedResultsController.fetchRequest setPredicate:predicate];
  [self.fetchedResultsController.fetchRequest setFetchLimit:100]; // Optional, but with large datasets - this helps speed lots
  
  NSError *error = nil;
  if (![_fetchedResultsController performFetch:&error]) {
    NSLog(@"Failed to initialize FetchedResultsController: %@\n%@",
          [error localizedDescription], [error userInfo]);
    abort();
  }
  
  [self.tableView reloadData];
}

#pragma mark - PMViewControllerFromStoryboardProtocol

+ (instancetype)viewControllerFromStoryboard {
  return [[UIStoryboard storyboardWithName:kPMMainStoryboardName bundle:nil]
          instantiateViewControllerWithIdentifier:
         NSStringFromClass([PMListViewController class])];
}

@end
