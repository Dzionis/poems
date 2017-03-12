//
//  PMPoemTableViewCell.h
//  Poems
//
//  Created by Dzionis Brek on 2/19/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMPoemTableViewCell : UITableViewCell

- (void)fillCellWithTitle:(NSString*)title;
- (void)showSeparator:(BOOL)show;

@end
