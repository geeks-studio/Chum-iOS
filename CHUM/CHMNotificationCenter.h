//
//  CHMNotificationCenter.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 15/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CHMNotificationCenter : NSObject

//@property (assign, nonatomic) BOOL canShowMessages;
//@property ()
@property (assign, nonatomic) BOOL canShow;
@property (assign, nonatomic) BOOL inMessanger;
@property (strong, nonatomic) NSString *currentPostID;


- (void)incomingCall:(NSString *)callID conversationID:(NSString *)conversationId;

+ (instancetype)shared;
- (void)showNotificationWithPayload:(NSDictionary *)payload;

- (void)openScreenWithOptions:(NSDictionary *)options isInside:(BOOL)isInside;

- (void)storeAction:(NSDictionary *)payload;
- (void)performStoredAction;
@end
