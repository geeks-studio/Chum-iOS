//
//  CHMCommentCell.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMBaseCell.h"

@class CHMLikeView;
@class CHMComment;

@class CHMAvatarView;
@interface CHMCommentCell : CHMBaseCell
//@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet CHMAvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet CHMLikeView *likeView;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;


- (void)configureWithComment:(CHMComment *)comment;

@end
