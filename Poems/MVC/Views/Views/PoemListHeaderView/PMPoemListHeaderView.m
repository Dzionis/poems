//
//  PMPoemListHeaderView.m
//  Poems
//
//  Created by Dzionis Brek on 2/28/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMPoemListHeaderView.h"

@interface PMPoemListHeaderView ()
@property(weak, nonatomic) IBOutlet UILabel *titleSectionLable;
@end

@implementation PMPoemListHeaderView

- (void)fillWithTitle:(NSString *)title {
  self.titleSectionLable.text = title;
}

@end
