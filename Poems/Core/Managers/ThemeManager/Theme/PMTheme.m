//
//  PMTheme.m
//  Poems
//
//  Created by Dzionis Brek on 2/27/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMTheme.h"

// Themes
#import "PMMainTheme.h"

// Categories
#import "UIImage+FromColor.h"

@implementation PMThemeManager

+ (id<PMTheme>)sharedTheme {
  static id<PMTheme> sharedTheme = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedTheme = [[PMMainTheme alloc] init];
  });

  return sharedTheme;
}

+ (void)customizeAppAppearance {
  id<PMTheme> theme = [self sharedTheme];

  // UINavigationBar
  UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
  [navigationBarAppearance
      setTitleTextAttributes:[theme navigationTitleTextAttributes]];
  [navigationBarAppearance setTintColor:[theme mainColor]];
  [navigationBarAppearance
      setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor]]
           forBarMetrics:UIBarMetricsDefault];
  [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
      setTextColor:[theme mainColor]];
}

@end
