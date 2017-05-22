//
//  CHMPlusCollectionViewCell.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMPlusCollectionViewCell.h"
#import "UIColor+CHMProjectsColor.h"

@implementation CHMPlusCollectionViewCell

- (void)drawRect:(CGRect)rect {
    
    self.plusIV.superview.layer.cornerRadius = self.plusIV.superview.bounds.size.width/2.;
    self.plusIV.superview.layer.masksToBounds = YES;
    
}

- (void)awakeFromNib {
    self.plusIV.superview.backgroundColor = [UIColor mainColor];
}

@end
