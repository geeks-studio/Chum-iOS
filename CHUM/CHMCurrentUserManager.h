//
//  CHMCurrentUserManager.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const CHMNeedUpdateLists;
@class CHMUser;
@class CHMSettings;
@interface CHMCurrentUserManager : NSObject

@property (strong, nonatomic) CHMUser *user;
@property (strong, nonatomic) CHMSettings *settings;
//@property (assign, nonatomic) BOOL messagePush;
//@property (assign, nonatomic) BOOL commentsPush;
//@property (assign, nonatomic) BOOL levelsPush;


+ (CHMCurrentUserManager *)shared;

- (NSString *)token;
- (NSString *)tokenJWTString;
- (void)setToken:(NSString *)token;

- (BOOL)isAskedPlace;

- (void)setAskedPlace:(BOOL)isNeedAsk;
//- (NSString *)currentUUID;

- (void)cloudIDAsync:(void (^)(NSString *_Nullable record, NSError *_Nullable err))completion;

- (void)setPushToken:(NSString *)pushToken;

- (NSString *)md5CloudID;

- (NSString *)md5:(NSString *)input;

- (BOOL)canDeletePostInPlaceWithID:(NSString *)placeID;

@end
