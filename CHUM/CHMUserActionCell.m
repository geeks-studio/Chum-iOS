//
//  CHMUserActionCell.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMUserAction.h"
#import "CHMUserActionCell.h"
#import "UIColor+CHMProjectsColor.h"

@import JSBadgeView;

@interface CHMUserActionCell ()

@property (strong, nonatomic) JSBadgeView *badgeView ;

@end

@implementation CHMUserActionCell


- (void)awakeFromNib {
    self.badgeView =
    [[JSBadgeView alloc] initWithParentView:self.nameLabel alignment:JSBadgeViewAlignmentCenterRight];
    self.badgeView.badgeBackgroundColor = [UIColor mainColor];
    self.badgeView.badgeStrokeWidth = 4.f;
    self.badgeView.badgeStrokeColor = [UIColor mainColor];
    self.badgeView.badgePositionAdjustment = CGPointMake(-20, 0);
    self.badgeView.badgeTextFont = [UIFont systemFontOfSize:20];
}

- (void)configureWithAction:(CHMUserAction *)action {
    self.pictureImageView.image = action.img;
    self.nameLabel.text = action.title;
}

- (void)configureWithText:(NSString *)text {
    
    if(text) {
        self.badgeView.badgeText =
        [NSString stringWithFormat:@"%@", text];
    } else {
        self.badgeView.badgeText = nil;
    }
}

@end
