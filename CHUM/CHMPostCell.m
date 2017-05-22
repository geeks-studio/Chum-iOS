//
//  CHMPostCell.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMLikeView.h"
#import "CHMPost.h"
#import "CHMPostCell.h"
#import "DateTools.h"
#import "UIColor+CHMProjectsColor.h"

@import SDWebImage;
//#import <>

@implementation CHMPostCell

- (void)awakeFromNib {
    [self.shareButton setTintColor:[UIColor mainColor]];
    [self.shareButton setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *color = [UIColor veryLightGrayColor];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, 0.0f, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureWithPost:(CHMPost *)post placeVisible:(BOOL)isPLaceVisible {
    
    [self configureWithPost:post];
    
    self.placeLabel.hidden = !isPLaceVisible;
    self.placeImageView.hidden = !isPLaceVisible;
}

- (void)configureWithPost:(CHMPost *)post {
    self.postLabel.text = post.text;
    [self.likeView configureWithPost:post];
    self.timeAgoLabel.text = [post.date shortTimeAgoSinceNow];
    [self congigureCommentsDescriptionWithPost:post];
    self.placeLabel.text = [post locationText];
    [self configureForSuperPost:post.isSuper];

    if (post.imgUrl) {
        self.imgHeightConstraint.constant = [[self class] imageHeight];
        self.imageBottomConstraint.constant = 8;
        self.mainImage.hidden = NO;
        [self.mainImage sd_setImageWithURL:post.imgUrl];
    } else {
        self.imgHeightConstraint.constant = 0;
        self.imageBottomConstraint.constant = 0;
        self.mainImage.hidden = YES;
        self.mainImage.image = nil;
    }
}

- (void)congigureCommentsDescriptionWithPost:(CHMPost *)post {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        UIImage *commentImage;
        NSString *commentText;
        UIColor *textColor;
        if (post.commentsIsOn) {
            commentText = @([post countOfComments]).stringValue;
            if ([post countOfComments] > 0) {
                commentImage = [UIImage imageNamed:@"commentCyan"];
                textColor = [UIColor mainColor];
            } else {
                textColor = self.timeAgoLabel.textColor;
                commentImage = [UIImage imageNamed:@"comment"];
            }
        } else {
            commentText = @"";
            commentImage = [UIImage imageNamed:@"commentsDisabled"];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (!self) {
                return;
            }
            self.commentPicture.image = commentImage;
            self.commentCountLabel.text = commentText;
            self.commentCountLabel.textColor = textColor;
        });
    });

    if (post.commentsIsOn) {
        self.commentCountLabel.text = @([post countOfComments]).stringValue;
        UIImage *commentPicture;
        if ([post countOfComments] > 0) {
            commentPicture = [UIImage imageNamed:@"commentCyan"];
        } else {
            commentPicture = [UIImage imageNamed:@"comment"];
        }
        self.commentPicture.image = commentPicture;
    } else {
        self.commentCountLabel.text = @"";
        self.commentPicture.image = [UIImage imageNamed:@"commentsDisabled"];
    }
}

- (void)configureForSuperPost:(BOOL)isSuper {
    self.isSuper = isSuper;
    UIView *backView = self.postLabel.superview;
    UIColor *backgroundColor = [UIColor whiteColor];
    if (isSuper) {
        backgroundColor = [UIColor superPostColor];
    }
    backView.backgroundColor = backgroundColor;
}

+ (CGFloat)imageHeight {
    return ([UIScreen mainScreen].bounds.size.width - 32) * 9 / 16;
}

@end
