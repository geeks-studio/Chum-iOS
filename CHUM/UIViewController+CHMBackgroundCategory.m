//
//  UIViewController+CHMBackgroundCategory.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 01/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "UIViewController+CHMBackgroundCategory.h"
#import "UIColor+CHMProjectsColor.h"
@import PureLayout;

@implementation UIViewController (CHMBackgroundCategory)

- (void)configureBackgroundWithImageWithName:(NSString *)imgName onBottom:(BOOL)onBottom withText:(NSString *)text {
    
    if (![self respondsToSelector:@selector(tableView)]) {
        return;
    }
    
    UITableView *tableView = [self performSelector:@selector(tableView)];
    
    CGRect r = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds),
                          16 * CGRectGetWidth([UIScreen mainScreen].bounds) / 9);
    
    UIView *v = [[UIView alloc] initWithFrame:r];
    v.backgroundColor = [UIColor lightBackgroundColor];
    v.transform = tableView.transform;
    
    if (!imgName) {
        tableView.backgroundView = v;
        tableView.backgroundView.layer.zPosition -= 1;
        return;
    }
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    [v addSubview:iv];
    
    if (!onBottom) {
        [iv autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
        
        [iv autoAlignAxis:ALAxisHorizontal toSameAxisOfView:v withOffset:-100];
    } else {
        [iv autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:60];
    }
    [iv autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [iv autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:v withMultiplier:0.5];
    [iv autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [iv autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    
    
    UILabel *l = [[UILabel alloc] initForAutoLayout];
    l.textColor = [UIColor lightGrayColor];
    l.text = text;
    l.textAlignment = NSTextAlignmentCenter;
    l.numberOfLines = 7;
    [v addSubview:l];
    [l autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [l autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:iv withOffset:5];
    [l autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:v withMultiplier:0.5];
    
    tableView.backgroundView = v;
    
    tableView.backgroundView.layer.zPosition -= 1;
}

- (void)configureBackgroundWithImageWithName:(NSString *)imgName {
    [self configureBackgroundWithImageWithName:imgName onBottom:NO withText:nil];
}



@end
