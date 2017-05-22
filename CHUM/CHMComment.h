//
//  CHMComment.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CHMLikeStatus;
@class CHMAvatarProvider;

@interface CHMComment : NSObject

@property (strong, nonatomic) NSString *commentText;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *replyCommentID;
@property (strong, nonatomic) CHMLikeStatus *likeStatus;

@property (strong, nonatomic) CHMAvatarProvider *avatarProvider;
@property (strong, nonatomic) CHMAvatarProvider *replyAvatarProvider;

@property (strong, nonatomic) NSString *commentID;

@property (assign, nonatomic) BOOL isSended;
@property (assign, nonatomic) BOOL isSending;


@property (assign, nonatomic) BOOL isOwn;

@end
