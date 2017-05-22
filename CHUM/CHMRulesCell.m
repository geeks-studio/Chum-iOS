//
//  CHMRulesCell.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 15/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMRulesCell.h"
#import "UIColor+CHMProjectsColor.h"

@implementation CHMRulesCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    self.numberLabel.layer.cornerRadius = 20.;
    self.numberLabel.layer.masksToBounds = YES;
    self.numberLabel.layer.borderColor = [UIColor mainColor].CGColor;
    self.numberLabel.layer.borderWidth = 1.;
    self.numberLabel.textColor = [UIColor mainColor];
    
    
    
}


- (void)configureWithText:(NSString *)text number:(NSInteger)index {
    self.descrLabel.text = text;
    self.numberLabel.text = [@(index) stringValue];
}

@end
