//
//  CHMTagView.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 18/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMTagView.h"
#import "UIColor+CHMProjectsColor.h"

@import TLTagsControl;
@import PureLayout;

@implementation CHMTagView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor veryLightGrayColor];
        [self addTags];
    }
    return self;
}

- (void)addTags {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.tagControl = [[TLTagsControl alloc] initWithFrame:CGRectMake(10, 0, width, 24)
                                                   andTags:@[ @"places" ]
                                       withTagsControlMode:TLTagsControlModeList];
    self.tagControl.showsHorizontalScrollIndicator = NO;
    
    self.tagControl.tagsBackgroundColor = [UIColor mainColor];
    self.tagControl.tagsDeleteButtonColor = [UIColor whiteColor];
    self.tagControl.tagsTextColor = [UIColor whiteColor];

    self.tagControl.mode = TLTagsControlModeList;

    [self.tagControl reloadTagSubviews];

    [self addSubview:self.tagControl];
    [self bringSubviewToFront:self.tagControl];
    [self.tagControl reloadTagSubviews];

    [self.tagControl autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
    [self.tagControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:13];
    [self.tagControl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:8];
    [self.tagControl autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8];
//    [self.tagControl autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeTop];
}

@end
