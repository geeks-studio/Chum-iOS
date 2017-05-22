//
//  CHMSettings.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 13/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMSettings.h"

NSString *const kCHMMessagePushKey = @"kCHMMessagePushKey";
NSString *const kCHMCommentsPushKey = @"kCHMCommentsPushKey";
NSString *const kCHMLevelsPushKey = @"kCHMLevelsPushKey";

@implementation CHMSettings

- (instancetype)init {
    self = [super init];
    if (self) {
        self.messagePush = YES;
        self.commentsPush = YES;
        self.levelsPush = YES;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    // Encode the properties of the object
    [encoder encodeBool:self.messagePush forKey:kCHMMessagePushKey];
    [encoder encodeBool:self.commentsPush forKey:kCHMCommentsPushKey];
    [encoder encodeBool:self.levelsPush forKey:kCHMLevelsPushKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        // decode the properties
        self.messagePush = [decoder decodeBoolForKey:kCHMMessagePushKey];
        self.commentsPush = [decoder decodeBoolForKey:kCHMCommentsPushKey];
        self.levelsPush = [decoder decodeBoolForKey:kCHMLevelsPushKey];
    }
    return self;
}

- (NSDictionary *)asDict {
    NSDictionary *d = @{
        @"level" : @(self.levelsPush),
        @"message" : @(self.messagePush),
        @"comment" : @(self.commentsPush)
    };
    
    return d;
}

@end
