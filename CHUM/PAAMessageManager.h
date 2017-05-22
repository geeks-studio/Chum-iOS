//
//  PAAMessageManager.h
//  PartyApp
//
//  Created by Andrey Mikhaylov on 20/11/15.
//  Copyright © 2015 Alfred Zien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PAAConversation;
@class PAAMessage;


extern NSString *const CHMShoulUpdateUnreadCount;

@interface PAAMessageManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy) void (^messageRecieved)(PAAMessage *message);

- (void)connect;
- (void)disconnectWebSocket;
- (void)setIdentifier:(NSString *)identifier;

- (void)loadAllConversationsWithCompletion:
    (void (^)(NSArray *conversations, NSError *err, NSInteger statusCode))completion;
- (void)conversationForPostID:(NSString *)postID
                    commentID:(NSString *)commentID
                   completion:(void (^)(PAAConversation *conversation,
                                        NSError *err,
                                        NSInteger statusCode))completion;

- (void)loadConversationWithID:(NSString *)conversationID
                    completion:(void (^)(PAAConversation *_Nullable conversation,
                                         NSError *_Nullable err,
                                         NSInteger statusCode))completion;

- (void)loadAllMessagesInConversation:(NSString *)conversationID
                           untillDate:(NSDate *)date
                                count:(NSInteger)count
                           completion:(void (^)(NSArray *messages,
                                                NSError *err,
                                                NSInteger statusCode))completion;

- (void)readAllMessagesInConversation:(NSString *)converstionID
                           completion:(void (^)(NSError *err, NSInteger statusCode))completion;
- (void)unBlockConversationWithID:(NSString *)conversationID
                       completion:(void (^)(NSError *err, NSInteger statusCode))completion;
- (void)blockConversationWithID:(NSString *)conversationID
                     completion:(void (^)(NSError *err, NSInteger statusCode))completion;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)sendMessageWithText:(NSString *)text
       toConversationWithID:(NSString *)converstionID
                 completion:
                     (void (^)(PAAMessage *msg, NSError *err, NSInteger statusCode))completion;
- (void)getTotalUnreadCount:(void (^)(NSNumber *_Nonnull unreadCount))completion;

- (void)updateUnreadCountEverywhere;

@end
