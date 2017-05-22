//
//  UITableViewController+ZPPTVCCategory.m
//  ZP
//
//  Created by Andrey Mikhaylov on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "CHMBaseCell.h"
#import "UIColor+CHMProjectsColor.h"
#import "UITableViewController+ZPPTVCCategory.h"
@import PureLayout;

@implementation UITableViewController (ZPPTVCCategory)

- (void)registrateCellForClass:(Class)cls reuseIdentifier:(NSString *)reuseIdentifier {
    NSString *className = NSStringFromClass(cls);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:reuseIdentifier];
}

// dangerous!
- (void)registrateCellForClass:(Class)cls {
    [[self tableView] registerNib:[cls nib] forCellReuseIdentifier:[cls identifier]];
}

- (void)configureBackgroundWithImageWithName:(NSString *)imgName onBottom:(BOOL)onBottom withText:(NSString *)text {
    
    CGRect r = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds),
                          16 * CGRectGetWidth([UIScreen mainScreen].bounds) / 9);

    UIView *v = [[UIView alloc] initWithFrame:r];
    v.backgroundColor = [UIColor lightBackgroundColor];
    v.transform = self.tableView.transform;

    if (!imgName) {
        self.tableView.backgroundView = v;
        self.tableView.backgroundView.layer.zPosition -= 1;
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

    self.tableView.backgroundView = v;
    
     self.tableView.backgroundView.layer.zPosition -= 1;
}

- (void)configureBackgroundWithImageWithName:(NSString *)imgName {
    [self configureBackgroundWithImageWithName:imgName onBottom:NO withText:nil];
}

@end
