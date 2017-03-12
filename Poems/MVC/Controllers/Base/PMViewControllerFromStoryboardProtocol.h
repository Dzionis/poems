//
//  PMViewControllerFromStoryboardProtocol.h
//  Poems
//
//  Created by Dzionis Brek on 2/28/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMViewControllerFromStoryboardProtocol <NSObject>

@required
+ (instancetype)viewControllerFromStoryboard;

@end
