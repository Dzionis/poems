//
//  ViewController.h
//  Poems
//
//  Created by Dzionis Brek on 2/19/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocols
#import "PMViewControllerFromStoryboardProtocol.h"

@interface PMListViewController
    : UIViewController<PMViewControllerFromStoryboardProtocol>

@property(assign, nonatomic) BOOL favorite;

@end
