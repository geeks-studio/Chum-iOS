//
//  CHMCommentCell.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMAvatarProvider.h"
#import "CHMAvatarView.h"
#import "CHMComment.h"
#import "CHMCommentCell.h"
#import "CHMLikeView.h"
#import "DateTools.h"

#import "CHUM-Swift.h"

@implementation CHMCommentCell

- (void)configureWithComment:(CHMComment *)comment {
    [self configureTextWithComment:comment];

    [self.likeView configureWithLikeStatus:comment.likeStatus];
    self.timeAgoLabel.text = [comment.date timeAgoSinceNow];

    [self.avatarView configureWithAvatarProvider:comment.avatarProvider];

    if (comment.isSending) {
        self.commentLabel.textColor = [UIColor lightGrayColor];
        self.likeView.hidden = YES;
        self.resendButton.hidden = YES;

    } else {
        if (comment.isSended) {
            self.commentLabel.textColor = [UIColor blackColor];
            self.likeView.hidden = NO;
            self.resendButton.hidden = YES;
            [self.contentView bringSubviewToFront:self.likeView];
        } else {
            self.commentLabel.textColor = [UIColor redColor];
            self.likeView.hidden = YES;
            self.resendButton.hidden = NO;
            [self.contentView bringSubviewToFront:self.resendButton];
        }
    }
}

- (void)configureTextWithComment:(CHMComment *)comment {
    NSAttributedString *commentText =
        [[NSAttributedString alloc] initWithString:comment.commentText];
    NSMutableAttributedString *resString;
    if (comment.replyAvatarProvider) {
        CHMAvatarImageGenerator *imgGenerator =
            [[CHMAvatarImageGenerator alloc] initWithAvatarProvider:comment.replyAvatarProvider];
        NSMutableAttributedString *atrString = [imgGenerator textWithCommaAndImage:17];
        
        [atrString appendAttributedString:commentText];
        resString = atrString;
    } else {
        resString = commentText.mutableCopy;
    }
    if (self) {
        self.commentLabel.attributedText = resString;
    }

}


@end
