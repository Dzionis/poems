//
//  UIImage+FromColor.m
//  Poems
//
//  Created by Dzionis Brek on 2/28/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "UIImage+FromColor.h"

@implementation UIImage (FromColor)

+ (UIImage *)imageFromColor:(UIColor *)color {
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

@end
