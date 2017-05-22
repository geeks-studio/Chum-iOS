//
//  CHMLoadingCell.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 10/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMLoadingCell.h"
#import "UIColor+CHMProjectsColor.h"

@import DGActivityIndicatorView;
@import PureLayout;

@implementation CHMLoadingCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    self.activityIndicatorView = [[DGActivityIndicatorView alloc]
        initWithType:DGActivityIndicatorAnimationTypeBallScaleRipple
           tintColor:[UIColor mainColor]
                size:35.0f];
    self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.activityIndicatorView.frame = CGRectMake(0.0f, 0.0f, 60.0f, 60.0f);
    //    self.acti

    [self.contentView addSubview:self.activityIndicatorView];

    [self.activityIndicatorView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
    [self.activityIndicatorView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8];
    [self.activityIndicatorView autoMatchDimension:ALDimensionHeight
                                       toDimension:ALDimensionWidth
                                            ofView:self.activityIndicatorView];
    [self.activityIndicatorView autoAlignAxisToSuperviewAxis:ALAxisVertical];

    [self.activityIndicatorView startAnimating];

    [self.reloadButton setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    self.reloadButton.hidden = YES;
}

- (void)setLoading:(BOOL)loading {
    self.activityIndicatorView.hidden = !loading;
    self.reloadButton.hidden = loading;
    
    
    if (loading) {
        [self.activityIndicatorView startAnimating];
    } else {
        [self.activityIndicatorView stopAnimating];
    }
}

@end
