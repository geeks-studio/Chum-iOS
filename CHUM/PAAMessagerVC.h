//
//  PAAMessagerVC.h
//  PartyApp
//
//  Created by Andrey Mikhaylov on 21/11/15.
//  Copyright © 2015 Alfred Zien. All rights reserved.
//

//#import "JSQMessages.h"


@class PAAConversation;
@class PAUser;
@import JSQMessagesViewController;


@interface PAAMessagerVC : JSQMessagesViewController

@property (strong, nonatomic, readonly) NSString *conversationID;

- (void)configureWithConverstion:(PAAConversation *)conversation;

- (void)configureWithPostID:(nonnull NSString *)postID commentID:(nullable NSString *)commentID;


@end
