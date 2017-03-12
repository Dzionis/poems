//
//  PMPoemTableViewCell.m
//  Poems
//
//  Created by Dzionis Brek on 2/19/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMPoemTableViewCell.h"

@interface PMPoemTableViewCell ()
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UIView *separatorView;
@end

@implementation PMPoemTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

#pragma mark - Public

- (void)fillCellWithTitle:(NSString *)title {
  self.titleLabel.text = title;
}

- (void)showSeparator:(BOOL)show {
  self.separatorView.hidden = !show;
}

@end
