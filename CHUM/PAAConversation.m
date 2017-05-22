//
//  PAAConversation.m
//  PartyApp
//
//  Created by Andrey Mikhaylov on 20/11/15.
//  Copyright © 2015 Alfred Zien. All rights reserved.
//


#import "PAAConversation.h"
#import "CHMPostHelper.h"
#import "PAAMessage.h"
#import "PAAMessageManager.h"
#import "NSDate+ZPPDateCategory.h"


//#import "PAAUserLite.h"
@import DateTools;

@interface PAAConversation ()
@property (strong, nonatomic) NSNumber *countOfUnread;
@property (strong, nonatomic) PAAMessage *lastMSg;
@end

@implementation PAAConversation

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.conversationID = dict[@"conversation_id"];
        self.countOfUnread = dict[@"count_of_unread_messages"];

        NSArray *messagesDicts = dict[@"messages"];
        for (NSDictionary *messDict in messagesDicts) {
            PAAMessage *m = [[PAAMessage alloc] initWithDictionary:messDict];
            [self.messages insertObject:m atIndex:0];
        }
        self.lastMSg = [self.messages lastObject];
        self.messages = nil;
        self.avatar = [CHMPostHelper avatarFromDict:dict[@"avatar"]];
        self.postID = dict[@"post_id"];
        
        NSNumber *isBlocked = dict[@"is_blocked"];
        if(isBlocked && ![isBlocked isEqual:[NSNull null]]) {
            self.isBlocked = isBlocked.boolValue;
        }
        NSNumber *canUnblock = dict[@"can_unblock"];
        if (canUnblock && [canUnblock isKindOfClass:[NSNumber class]]) {
            self.canUnblock = canUnblock;
        }
        NSString *deathDateString = dict[@"death_time"];
        if (deathDateString && ![deathDateString isEqual:[NSNull null]]) {
            self.deathDate = [NSDate customDateFromString:deathDateString];
        }
        NSString *opponentID = dict[@"interlocutor_name"];
        if (opponentID && ![opponentID isEqual:[NSNull null]]) {
            self.opponentID = opponentID;
        }
        NSNumber *canMakeCall = dict[@"can_make_call"];
        if (canMakeCall && ![canMakeCall isEqual:[NSNull null]] && canMakeCall.boolValue) {
            self.canMakeCall = canMakeCall.boolValue;
        }
    }
    return self;
}

- (NSInteger)unreadedCount {
    NSInteger count = 0;
    if (self.countOfUnread && ![self.countOfUnread isEqual:[NSNull null]]) {
        count = self.countOfUnread.integerValue;
    }
    return count;
}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

- (PAAMessage *)lastMessage {
    if (self.lastMSg) {
        return self.lastMSg;
    }
    return nil;
}

@end
