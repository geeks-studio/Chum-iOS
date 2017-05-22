//
//  CHMLikeView.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMLikeStatus.h"
#import "CHMLikeView.h"
#import "CHMPost.h"
#import "UIColor+CHMProjectsColor.h"

@implementation CHMLikeView
//
- (void)awakeFromNib {
    [super awakeFromNib];

    UIImage *up =
        [[UIImage imageNamed:@"arrowUp"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *down = [[UIImage imageNamed:@"arrowDown"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [self.upButton setImage:up forState:UIControlStateNormal];
    [self.upButton setImage:up forState:UIControlStateDisabled];
    [self.downButton setImage:down forState:UIControlStateNormal];
    [self.downButton setImage:down forState:UIControlStateDisabled];

    self.upButton.tintColor = [UIColor projectGray];
    self.downButton.tintColor = [UIColor projectGray];
}

- (void)configureWithPost:(CHMPost *)post {
    [self configureWithLikeStatus:post.likeStatus];
}

- (void)configureWithLikeStatus:(CHMLikeStatus *)likeStatus {
    self.likeCount.text = [NSString stringWithFormat:@"%ld", (long)likeStatus.likeCount];
    UIColor *gray = [UIColor r:220 g:220 b:220];
    switch (likeStatus.likeType) {
        case CHMLikeTypeNegative:
            self.downButton.imageView.tintColor = [UIColor mainColor];
            self.upButton.imageView.tintColor = gray;
            self.downButton.enabled = NO;
            self.upButton.enabled = YES;

            break;
        case CHMLikeTypePositive:
            self.upButton.imageView.tintColor = [UIColor mainColor];
            self.downButton.imageView.tintColor = gray;
            self.upButton.enabled = NO;
            self.downButton.enabled = YES;
            break;
        case CHMLikeTypeNone:
            self.upButton.imageView.tintColor = gray;
            self.downButton.imageView.tintColor = gray;
            self.upButton.enabled = YES;
            self.downButton.enabled = YES;
            break;
        default:
            //            self.upButton.tintColor = [UIColor projectGray];
            //            self.downButton.tintColor = [UIColor projectGray];
            //            self.upButton.enabled = YES;
            //            self.downButton.enabled = YES;

            break;
    }

    if (likeStatus.likeCount > 0) {
        self.likeImageView.image = [UIImage imageNamed:@"likeCyan"];
    } else if (likeStatus.likeCount < 0) {
        self.likeImageView.image = [UIImage imageNamed:@"likeRed"];
    } else {
        self.likeImageView.image = [UIImage imageNamed:@"likeGray"];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                        owner:self
                                                      options:nil] objectAtIndex:0]];
        self.view.frame = self.bounds;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.view.frame = self.bounds;

    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat heartHeight = self.likeImageView.frame.size.height;
    CGFloat offset = (width - heartHeight) / 2.5;
    self.upButton.imageEdgeInsets = UIEdgeInsetsMake(0, offset, height * 0.3, offset);
    self.downButton.imageEdgeInsets = UIEdgeInsetsMake(height * 0.3, offset, 0, offset);
}

@end
