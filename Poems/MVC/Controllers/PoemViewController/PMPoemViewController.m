//
//  PMPoemViewController.m
//  Poems
//
//  Created by Dzionis Brek on 2/19/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMPoemViewController.h"

// Constants
#import "PMConstants.h"

// Theme
#import "PMTheme.h"

@interface PMPoemViewController ()
@property(weak, nonatomic) IBOutlet UILabel *textLabel;
@end

@implementation PMPoemViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self configureView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Custom Accessors

- (void)setTitle:(NSString *)title {
  [super setTitle:title];
  id<PMTheme> theme = [PMThemeManager sharedTheme];
  UILabel *titleLabel = [theme labelForNavigationTitleWithText:title];
  self.navigationItem.titleView = titleLabel;
}

#pragma mark - Private

- (void)configureView {
  self.textLabel.text = self.poem;
  UILongPressGestureRecognizer *tapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sharePoem)];
  [self.textLabel addGestureRecognizer:tapRecognizer];
}

- (void)sharePoem {
  NSMutableArray *sharingItems = [NSMutableArray new];
  NSString *text = [NSString stringWithFormat:@"%@\n\n%@", self.title, self.poem];
  [sharingItems addObject:text];
  UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
  [self presentViewController:activityController animated:YES completion:nil];
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

#pragma mark - PMViewControllerFromStoryboardProtocol

+ (instancetype)viewControllerFromStoryboard {
  return [[UIStoryboard storyboardWithName:kPMMainStoryboardName bundle:nil]
          instantiateViewControllerWithIdentifier:
          NSStringFromClass([PMPoemViewController class])];
}

@end
