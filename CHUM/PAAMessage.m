//
//  PAAMessage.m
//  PartyApp
//
//  Created by Andrey Mikhaylov on 20/11/15.
//  Copyright © 2015 Alfred Zien. All rights reserved.
//

#import "PAAMessage.h"
#import "NSDate+ZPPDateCategory.h"
//#import <DateTools.h>

@import DateTools;

@interface PAAMessage ()
//@property (strong, nonatomic) NSString *text;
//@property (strong, nonatomic) NSDate *date;
//@property (strong, nonatomic) NSNumber *userID;
//@property (assign, nonatomic) BOOL isUnread;

@end

@implementation PAAMessage

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.text = dict[@"text"];
//        self.userID = dict[@"from_id"];
        self.dateString = dict[@"time"];
        self.date = [NSDate customDateFromString:self.dateString];
        
        NSNumber *is_read = dict[@"is_read"];
        NSNumber *isOwn = dict[@"own_message"];
        
        if (is_read && ![is_read isEqual:[NSNull null]]) {
            self.isRead = is_read.boolValue;
        } else {
            self.isRead = YES;
        }
        
        if(isOwn && ![isOwn isEqual:[NSNull null]]) {
            self.isOwn = isOwn.boolValue;
        }
        
        self.conversationID = dict[@"conversation_id"];
        self.messageID = dict[@"message_id"];
        
        self.isSended = YES;
        self.isSending = NO;
    }
    return self;
}

- (void)makeReaded {
    self.isRead = YES;
}

+ (NSString *)senderNameforIsSelf:(BOOL)isSelf {
    if(isSelf) {
        return @"self";
    } else {
        return @"chum";
    }
}


- (NSString *)userID {
    return [[self class] senderNameforIsSelf:self.isOwn];
}

//- (BOOL)checkBool:(NSNumber *)num {
//    if (num && ![num isEqual:[NSNull null]]) {
//        self.isRead = is_read.boolValue;
//        
//        
//    } else {
//        self.isRead = YES;
//    }
//}

//- (NSDate *)customDateFromString:(NSString *)dateAsString {
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//
//    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
//    //    "2015-10-28T15:08:14.544Z";
//
//    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//    df.locale = [NSLocale systemLocale];
//
//    return [df dateFromString:dateAsString];
//}



@end
