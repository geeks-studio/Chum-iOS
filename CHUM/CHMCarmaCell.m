//
//  CHMCarmaCell.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMCarmaCell.h"
#import "CHMUser.h"
#import "UIColor+CHMProjectsColor.h"
#import "CHUM-Swift.h"

@import CircleProgressBar;
@import PureLayout;
//@import EFCircularSlider;

@implementation CHMCarmaCell

- (void)awakeFromNib {
    self.slider.progressBarWidth = 7.;
    self.slider.progressBarProgressColor = [UIColor r:236 g:102 b:140];
    self.slider.progressBarTrackColor = [UIColor r:182 g:74 b:105];
    self.slider.startAngle = -90;
    self.slider.hintHidden = YES;
    self.slider.backgroundColor = [UIColor clearColor];

    self.contentView.layer.cornerRadius = 10.;
    self.contentView.layer.masksToBounds = YES;

    self.levelBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.levelBackView.backgroundColor = [UIColor projectPinkColor];
    self.levelBackView.layer.cornerRadius = self.levelBackView.frame.size.width / 2.;
    self.levelBackView.layer.masksToBounds = YES;

    [self.contentView addSubview:self.levelBackView];
    [self.contentView bringSubviewToFront:self.levelBackView];

    self.levelLabel = [[UILabel alloc] initForAutoLayout];
    self.levelLabel.textColor = [UIColor whiteColor];
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    [self.levelBackView addSubview:self.levelLabel];
    [self.levelLabel autoPinEdgesToSuperviewEdges];
}

- (void)configureWithKarma:(Karma *)karma {
    if (!karma) {
        self.carmaImageView.image = nil;
        self.levelLabel.text = @"";
        self.carmaLabel.text = @"";
        self.radiusLabel.text = @"";

        return;
    }

    float progress = (float)karma.progress / 100.;

    [self.slider setProgress:progress animated:NO];

    self.carmaLabel.text =
        [NSString stringWithFormat:@"%d", karma.likeCount];
    self.nextLevelCarmaLabel.text = [NSString stringWithFormat:@"%d",karma.likeToNextLevel];
//    float radius = user.maxMeterCount.floatValue / 1000;
//    self.radiusLabel.text = [NSString stringWithFormat:@"%.1f", radius];
    self.levelLabel.text = [NSString stringWithFormat:@"%d", karma.level];
    NSInteger lvl = karma.level % 20;

    if (lvl == 0) {
        lvl = 20;
    }

    NSString *imgName = [NSString stringWithFormat:@"l%@", @(lvl)];
    self.carmaImageView.image = [UIImage imageNamed:imgName];

}

- (void)configureWithRadius:(NSNumber *)distance {
        float radius = distance.floatValue / 1000;
        self.radiusLabel.text = [NSString stringWithFormat:@"%.1f", radius];
}

- (void)drawRect:(CGRect)rect {
    UIView *v = self.carmaImageView.superview;

    v.layer.cornerRadius = v.frame.size.height / 2.0;
    v.layer.masksToBounds = YES;

    [self levelViewPositionUpdate];
}


- (void)layoutSubviews {
    [self levelViewPositionUpdate];
}

- (void)levelViewPositionUpdate {
    CGRect r = self.slider.bounds;

    float radius = (r.size.height - self.slider.progressBarWidth) / 2.;

    float angle = self.slider.progress * M_PI * 2;

    float sin = sinf(angle) * radius;
    float cos = cosf(angle) * radius;

    self.levelBackView.center = CGPointMake(self.slider.center.x + sin, self.slider.center.y - cos);
}

@end
