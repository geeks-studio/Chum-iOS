//
//  PAAMessage.h
//  PartyApp
//
//  Created by Andrey Mikhaylov on 20/11/15.
//  Copyright © 2015 Alfred Zien. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Realm.h>

@class PAAUserLite;
@interface PAAMessage : NSObject


//@property (strong, nonatomic) PAAUserLite *sender;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSString *userID;
@property (assign, nonatomic) BOOL isRead;
@property (assign, nonatomic) BOOL isSended;
@property (assign, nonatomic) BOOL isSending;
@property (strong, nonatomic) NSString *conversationID;
@property (strong, nonatomic) NSString *messageID;

@property (assign, nonatomic) BOOL isOwn;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (void)makeReaded;

+ (NSString *)senderNameforIsSelf:(BOOL)isSelf;

@end

//RLM_ARRAY_TYPE(PAAMessage)
