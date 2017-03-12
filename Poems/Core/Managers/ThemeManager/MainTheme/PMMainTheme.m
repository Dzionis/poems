//
//  PMMainTheme.m
//  Poems
//
//  Created by Dzionis Brek on 2/27/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMMainTheme.h"

@implementation PMMainTheme

// Colors

- (UIColor *)mainColor {
  return [UIColor colorWithRed:173.f / 255.f
                         green:64.f / 255.f
                          blue:72.f / 255.f
                         alpha:1.0f];
}

- (UIColor *)grayColor {
  return [UIColor colorWithRed:223.f / 255.f
                         green:223.f / 255.f
                          blue:223.f / 255.f
                         alpha:1.0f];
}

- (UIColor *)navigationBarTitleColor {
  return [UIColor colorWithRed:43.f / 255.f
                         green:11.f / 255.f
                          blue:11.f / 255.f
                         alpha:1.0f];
}

// Labels

- (UILabel*)labelForMainNavigationTitle {
  UILabel *titleLabel = [[UILabel alloc] init];
  NSMutableAttributedString *attributedTitle =
      [[NSMutableAttributedString alloc]
          initWithString:@"Якуб Колас"
              attributes:[self navigationTitleTextAttributes]];
  [attributedTitle addAttribute:NSForegroundColorAttributeName
                          value:[self mainColor]
                          range:NSMakeRange(0, 4)];
  titleLabel.attributedText = attributedTitle;
  [titleLabel sizeToFit];
  CGRect frame = titleLabel.frame;
  
  // Fix issue with font.
  frame.size.height += 10;
  titleLabel.frame = frame;
  return titleLabel;
}

- (UILabel*)labelForNavigationTitleWithText:(NSString*)text {
  UILabel *titleLabel = [[UILabel alloc] init];
  NSMutableAttributedString *attributedTitle =
  [[NSMutableAttributedString alloc]
   initWithString:text
   attributes:[self navigationTitleTextAttributes]];
  titleLabel.attributedText = attributedTitle;
  [titleLabel sizeToFit];
  CGRect frame = titleLabel.frame;
  
  // Fix issue with font.
  frame.size.height += 10;
  titleLabel.frame = frame;
  return titleLabel;
}

// Images

- (UIImage*)imageFavoriteForNavigationBar {
  return [UIImage imageNamed:@"ic_favorite"];
}

- (UIImage*)imageFavoriteActiveForNavigationBar {
  return [UIImage imageNamed:@"ic_favorite_active"];
}

- (UIImage*)imageBackForNavigationBar {
  return [UIImage imageNamed:@"ic_back"];
}

- (UIImage*)imageSearch {
  return [UIImage imageNamed:@"ic_search"];
}

// Fonts

- (UIFont *)fontOfSize:(CGFloat)fontSize {
  return [UIFont systemFontOfSize:fontSize];
}

- (UIFont *)boldFontOfSize:(CGFloat)fontSize {
  return [UIFont boldSystemFontOfSize:fontSize];
}

- (UIFont *)emptyStateFont {
  return [UIFont fontWithName:@"Neucha" size:22.0f];
}

- (UIFont *)navigationBarTitleFont {
  return [UIFont fontWithName:@"Neucha" size:24.0f];
}

// Dictionaries

- (NSDictionary*)navigationTitleTextAttributes {
  return @{
    NSForegroundColorAttributeName : [self navigationBarTitleColor],
    NSFontAttributeName : [self navigationBarTitleFont]
    };
}

@end
