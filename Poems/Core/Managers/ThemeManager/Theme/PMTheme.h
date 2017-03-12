//
//  PMTheme.h
//  Poems
//
//  Created by Dzionis Brek on 2/27/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PMTheme<NSObject>

// Colors
- (UIColor *)mainColor;
- (UIColor *)navigationBarTitleColor;
- (UIColor *)grayColor;

// Labels
- (UILabel*)labelForMainNavigationTitle;
- (UILabel*)labelForNavigationTitleWithText:(NSString*)text;

// Images
- (UIImage*)imageFavoriteForNavigationBar;
- (UIImage*)imageFavoriteActiveForNavigationBar;
- (UIImage*)imageBackForNavigationBar;
- (UIImage*)imageSearch;

// Fonts
- (UIFont *)emptyStateFont;
- (UIFont *)fontOfSize:(CGFloat)fontSize;
- (UIFont *)boldFontOfSize:(CGFloat)fontSize;
- (UIFont *)navigationBarTitleFont;

// Dictionaries
- (NSDictionary*)navigationTitleTextAttributes;

@end

@interface PMThemeManager : NSObject

+ (id<PMTheme>)sharedTheme;
+ (void)customizeAppAppearance;

@end
