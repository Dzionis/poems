//
//  PMPoemListSectionView.m
//  Poems
//
//  Created by Dzionis Brek on 2/27/17.
//  Copyright © 2017 Dzionis. All rights reserved.
//

#import "PMPoemListSectionView.h"

@interface PMPoemListSectionView ()

@property(weak, nonatomic) IBOutlet UILabel *letterLabel;

@end

@implementation PMPoemListSectionView

- (void)fillWithLetter:(NSString *)letter {
  self.letterLabel.text = letter;
}

@end
