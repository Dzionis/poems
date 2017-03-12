//
//  PMPoemViewController.h
//  Poems
//
//  Created by Dzionis Brek on 2/19/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocols
#import "PMViewControllerFromStoryboardProtocol.h"

@interface PMPoemViewController
    : UIViewController<PMViewControllerFromStoryboardProtocol>

@property(strong, nonatomic) NSString *poem;
@property(assign, nonatomic) NSUInteger pageIndex;

@end
