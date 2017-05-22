//
//  CHMShareView.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMShareView.h"
#import "UIColor+CHMProjectsColor.h"
#import "CHMPost.h"
#import "CHMPostCell.h"
#import "CHMLikeView.h"

@import DateTools;

@implementation CHMShareView

- (void)awakeFromNib {
//    self.backgroundColor = [UIColor mainColor];
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                        owner:self
                                                      options:nil] objectAtIndex:0]];
        
        self.view.frame = frame;
        
        
        self.backView.backgroundColor = [UIColor mainColor];
        
        self.backView.layer.cornerRadius = 5.0;
        self.backView.layer.masksToBounds = NO;
        self.postLabel.superview.layer.cornerRadius = 5.0;
        self.postLabel.superview.layer.masksToBounds = YES;
//        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
        
        self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.backView.layer.shadowRadius = 2.0;
        self.backView.layer.shadowOpacity = 0.5;
        

//        self.backView.layer.shadowPath = shadowPath.CGPath;
        
//        view.layer.masksToBounds = NO;
//        view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.backView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
//        view.layer.shadowOpacity = 0.5f;
//        view.layer.shadowPath = shadowPath.CGPath;
        
    }
    return self;
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




- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.view.frame = self.bounds;
}

- (void)configureWithPost:(CHMPost *)post {
    self.postLabel.text = post.text;
    [self.likeView configureWithPost:post];
    self.likeView.upButton.hidden = YES;
    self.likeView.downButton.hidden = YES;
    self.timeAgoLabel.text = [post.date shortTimeAgoSinceNow];
    
    if (post.commentsIsOn) {
        self.commentCountLabel.text = @([post countOfComments]).stringValue;
        self.commentPicture.image = [UIImage imageNamed:@"comment"];
    } else {
        self.commentCountLabel.text = @"";
        self.commentPicture.image = [UIImage imageNamed:@"commentsDisabled"];
    }
    
    self.placeLabel.text = [post locationText];
    
    if (post.img) {
        self.imgHeightConstraint.constant = [[self class] imageHeight];
        self.mainImage.hidden = NO;
        self.mainImage.layer.borderWidth = 1.0;
        self.mainImage.layer.borderColor = [UIColor veryLightGrayColor].CGColor;
        self.mainImage.image = post.img;
//        [self.mainImage sd_setImageWithURL:post.imgUrl];
    } else {
        self.imgHeightConstraint.constant = 0;
        self.mainImage.hidden = YES;
        self.mainImage.layer.borderWidth = .0;
        self.mainImage.layer.borderColor = [UIColor clearColor].CGColor;
    }

}


+ (CGFloat)imageHeight {
    return ([UIScreen mainScreen].bounds.size.width - 64) * 9 / 16;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
