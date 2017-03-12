//
//  PMPoemPageViewController.m
//  Poems
//
//  Created by Dzionis Brek on 2/28/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMPoemPageViewController.h"

// Constants
#import "PMConstants.h"

// Models
#import "PMPoemEntity+CoreDataClass.h"
#import "PMPoem.h"

// Managers
#import "PMDataManager.h"

// Controllers
#import "PMPoemViewController.h"

// Theme
#import "PMTheme.h"

@interface PMPoemPageViewController ()<UIPageViewControllerDataSource,
                                       UIPageViewControllerDelegate,
                                       UIGestureRecognizerDelegate>

/*!
 *  @brief Page view controller is contrainer for racing details screens.
 */
@property(strong, nonatomic) UIPageViewController *pageViewController;

@property(strong, nonatomic) NSArray<PMPoem *> *poemsArray;
@property(assign, nonatomic) NSUInteger currentIndex;

@property(assign, nonatomic) BOOL pageAnimationFinished;

@end

@implementation PMPoemPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupPageData];
  self.pageAnimationFinished = YES;

  [self customizeNavigationBar];
  [self updateFavoriteStatus];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  if (!self.pageViewController) {
    [self setupPageViewController];
  }
}

#pragma mark - Custom Accessors

- (void)setTitle:(NSString *)title {
  [super setTitle:title];
  id<PMTheme> theme = [PMThemeManager sharedTheme];
  UILabel *titleLabel = [theme labelForNavigationTitleWithText:title];
  self.navigationItem.titleView = titleLabel;
}

#pragma mark - Private

- (void)backAction:(UIBarButtonItem *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)customizeNavigationBar {
  id<PMTheme> theme = [PMThemeManager sharedTheme];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[theme imageFavoriteForNavigationBar]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(addToFavorite:)];
  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:[theme imageBackForNavigationBar]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(backAction:)];
}

- (void)addToFavorite:(UIBarButtonItem *)sender {
  PMPoem *poem = self.poemsArray[self.currentIndex];
  poem.favorite = @(!poem.favorite.boolValue);
  [PMPoemEntity insertPoemEntityWithPoem:poem];
  [[PMDataManager sharedManager] saveData];
  [self updateFavoriteStatus];
}

- (void)updateFavoriteStatus {
  id<PMTheme> theme = [PMThemeManager sharedTheme];
  PMPoem *poem = self.poemsArray[self.currentIndex];
  if (poem.favorite.boolValue) {
    [self.navigationItem.rightBarButtonItem
        setImage:[theme imageFavoriteActiveForNavigationBar]];
  } else {
    [self.navigationItem.rightBarButtonItem
        setImage:[theme imageFavoriteForNavigationBar]];
  }
}

- (void)setupPageData {
  NSPredicate *predicate;
  if (self.favorite) {
    predicate = [NSPredicate predicateWithFormat:@"favorite = YES"];
  }
  NSArray *arrayOfPoemsEntity =
      [PMPoemEntity MR_findAllWithPredicate:predicate];
  NSMutableArray *poemsArray = @[].mutableCopy;

  for (PMPoemEntity *poemEntity in arrayOfPoemsEntity) {
    [poemsArray addObject:[poemEntity mantleModel]];
  }

  NSSortDescriptor *sortDescriptor = [NSSortDescriptor
      sortDescriptorWithKey:@"name"
                  ascending:YES
                   selector:@selector(localizedCaseInsensitiveCompare:)];
  [poemsArray sortUsingDescriptors:@[ sortDescriptor ]];
  self.poemsArray = poemsArray;

  self.currentIndex = [poemsArray indexOfObject:self.poem];
}

- (void)setupPageViewController {
  // Create page view controller
  self.pageViewController = [[UIPageViewController alloc] init];
  self.pageViewController.dataSource = self;
  self.pageViewController.delegate = self;

  for (UIGestureRecognizer *gestureRecognizer in self.pageViewController
           .gestureRecognizers) {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
      gestureRecognizer.delegate = self;
    }
  }

  PMPoemViewController *poemViewController =
      [self viewControllerAtIndex:self.currentIndex];

  if (poemViewController) {
    // Setup Page View Controller.
    NSArray *viewControllers = @[ poemViewController ];

    [self.pageViewController
        setViewControllers:viewControllers
                 direction:UIPageViewControllerNavigationDirectionForward
                  animated:NO
                completion:nil];

    // Set the size of page view controller.
    CGFloat topViewHeigh =
        CGRectGetHeight(self.navigationController.navigationBar.frame) + 20;
    self.pageViewController.view.frame =
        CGRectMake(0, topViewHeigh, CGRectGetWidth(self.view.bounds),
                   CGRectGetHeight(self.view.bounds) - topViewHeigh);

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
  }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
  if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
    CGFloat avalibleZone = CGRectGetWidth(self.view.frame) * 0.25;
    CGPoint touchPoint = [touch locationInView:self.view];
    CGFloat xPosition = touchPoint.x;

    if (((xPosition < avalibleZone && self.currentIndex != 0) ||
         (xPosition > CGRectGetWidth(self.view.frame) - avalibleZone &&
          self.currentIndex != self.poemsArray.count - 1)) &&
        self.pageAnimationFinished) {
      return YES;
    } else {
      return NO;
    }
  }
  return YES;
}

#pragma mark - UIPageViewControllerDataSource

- (PMPoemViewController *)viewControllerAtIndex:(NSUInteger)index {
  if ((self.poemsArray.count == 0) || (index >= self.poemsArray.count)) {
    return nil;
  }

  PMPoem *poem = self.poemsArray[index];
  PMPoemViewController *poemViewController =
      [PMPoemViewController viewControllerFromStoryboard];
  poemViewController.poem = poem.text;
  poemViewController.title = poem.name;
  poemViewController.pageIndex = index;

  return poemViewController;
}

- (UIViewController *)pageViewController:
                          (UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
  NSUInteger index = ((PMPoemViewController *)viewController).pageIndex;

  if ((index == 0) || (index == NSNotFound) || !self.pageAnimationFinished) {
    return nil;
  }

  index--;

  return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:
                          (UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
  NSUInteger index = ((PMPoemViewController *)viewController).pageIndex;

  if (index == NSNotFound) {
    return nil;
  }

  index++;

  if (index == self.poemsArray.count || !self.pageAnimationFinished) {
    return nil;
  }
  return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
         didFinishAnimating:(BOOL)finished
    previousViewControllers:
        (NSArray<UIViewController *> *)previousViewControllers
        transitionCompleted:(BOOL)completed {
  // Turn is either finished or aborted
  if (completed && finished) {
    PMPoemViewController *currentDisplayedViewController =
        (PMPoemViewController *)self.pageViewController.viewControllers[0];
    PMPoem *poem = self.poemsArray[currentDisplayedViewController.pageIndex];
    self.title = poem.name;
    self.currentIndex = currentDisplayedViewController.pageIndex;
    [self updateFavoriteStatus];
  }
  self.pageAnimationFinished = YES;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
    willTransitionToViewControllers:
        (NSArray<UIViewController *> *)pendingViewControllers {
  self.pageAnimationFinished = NO;
}

#pragma mark - PMViewControllerFromStoryboardProtocol

+ (instancetype)viewControllerFromStoryboard {
  return [[UIStoryboard storyboardWithName:kPMMainStoryboardName bundle:nil]
      instantiateViewControllerWithIdentifier:
          NSStringFromClass([PMPoemPageViewController class])];
}

@end
