//
//  PAAConversation.h
//  PartyApp
//
//  Created by Andrey Mikhaylov on 20/11/15.
//  Copyright © 2015 Alfred Zien. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Realm.h>

@class PAAUserLite;

@class PAAMessage;
@class CHMAvatarProvider;
@interface PAAConversation : NSObject

//@property (strong, nonatomic) PAAUserLite *opponent;
//@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSString *conversationID;
@property (strong, nonatomic) NSString *postID;
@property (strong, nonatomic) NSString *commentID;
@property (strong, nonatomic) NSDate *deathDate;

@property (strong, nonatomic, nullable) NSString *opponentID;

@property (strong, nonatomic) CHMAvatarProvider *avatar;
@property (strong, nonatomic, readonly) PAAMessage *lastMessage;

@property (assign, nonatomic) BOOL isBlocked;
@property (strong, nonatomic) NSNumber *canUnblock;
@property (assign, nonatomic) BOOL canMakeCall;

- (instancetype)initWithDict:(NSDictionary *)dict;

- (NSInteger)unreadedCount;

@end
