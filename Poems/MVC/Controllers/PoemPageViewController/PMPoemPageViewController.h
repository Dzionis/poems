//
//  PMPoemPageViewController.h
//  Poems
//
//  Created by Dzionis Brek on 2/28/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocols
#import "PMViewControllerFromStoryboardProtocol.h"

@class PMPoem;

@interface PMPoemPageViewController
    : UIViewController<PMViewControllerFromStoryboardProtocol>

@property(strong, nonatomic) PMPoem *poem;
@property(assign, nonatomic) BOOL favorite;

@end
