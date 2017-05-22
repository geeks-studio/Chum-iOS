//
//  CHMNotificationCenter.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 15/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMAvatarProvider.h"
#import "CHMNotificationCenter.h"
#import "CHMPost.h"
#import "CHMPostDirectlyTVC.h"
#import "HDNotificationView.h"
#import "PAAConversation.h"
#import "PAAConversationsTVC.h"
#import "PAAMessageManager.h"
#import "PAAMessagerVC.h"
#import "PAAMessagerVC.h"

#import "CHUM-Swift.h"

@import JSQSystemSoundPlayer;
@interface CHMNotificationCenter ()

@property (strong, nonatomic) StoredAction *storedAction;

@end

@implementation CHMNotificationCenter

+ (instancetype)shared {
    static CHMNotificationCenter *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CHMNotificationCenter alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.inMessanger = NO;
        self.canShow = YES;
    }
    return self;
}

- (void)showNotificationWithPayload:(NSDictionary *)payload {
    UIApplication *application = [UIApplication sharedApplication];
    if (application.applicationState == UIApplicationStateActive) {
        [self openScreenWithOptions:payload isInside:YES];
    } else {
        [self openScreenWithOptions:payload isInside:NO];
    }
}

- (void)showWithPayload:(NSDictionary *)payload {
    NSDictionary *d = payload[@"aps"];
    NSString *text = d[@"alert"];
    UIImage *img = [UIImage imageNamed:@"sharePic"];

    [UserActivityNotifier updateUnwatherCountEverythere];
    [self showWithImage:img
                   text:text
             completion:^{
                 [self openScreenWithOptions:payload isInside:NO];
             }];
}

- (void)showWithImage:(UIImage *)image text:(NSString *)text completion:(void (^)())completion {
    if (!self.canShow) {
        return;
    }
    [[JSQSystemSoundPlayer sharedPlayer] playVibrateSound];
    [HDNotificationView
        showNotificationViewWithImage:image
                                title:@"CHUM"
                              message:text
                           isAutoHide:YES
                              onTouch:^{
                                  [HDNotificationView hideNotificationViewOnComplete:completion];
                              }];
}

- (void)performStoredAction {
    if (self.storedAction) {
        NSDictionary *payload = self.storedAction.payload;
        self.storedAction = nil;
        [self openScreenWithOptions:payload isInside:NO];
    }
}

- (void)storeAction:(NSDictionary *)payload {
    if (payload) {
        self.storedAction = [[StoredAction alloc] initWithPayload:payload];
    }
}

- (void)openScreenWithOptions:(NSDictionary *)options isInside:(BOOL)isInside {
    if (!options) {
        return;
    }
    NSString *action = options[@"action"];
    if ([action isEqualToString:@"comment"]) {
        NSString *postID = options[@"post_id"];
        if (!postID || [postID isEqual:[NSNull null]]) {
            return;
        }
        if (isInside) {
            if (![postID isEqualToString:self.currentPostID] && self.canShow) {
                [self showWithPayload:options];
            }
        } else {
            [self openPostWithID:postID];
        }
    } else if ([action isEqualToString:@"message"]) {
        NSString *conversationID = options[@"conversation_id"];
        if (!conversationID || [conversationID isEqual:[NSNull null]]) {
            return;
        }
        if (isInside) {
            if (!self.inMessanger && self.canShow) {
                [[NSNotificationCenter defaultCenter]
                    postNotificationName:PAANeedReloadConversations
                                  object:nil];
                [[PAAMessageManager sharedInstance] updateUnreadCountEverywhere];
                [self showWithPayload:options];
            }
        } else {
            [self openConversationWithID:conversationID];
        }
    } else if ([action isEqualToString:@"level"]) {
        NSNumber *level = options[@"level"];
        NSInteger lvl = [level integerValue];

        if (isInside) {
            if (self.canShow) {
                [self showWithPayload:options];
            }
        } else {
            [self showAlertAboutLevel:lvl];
        }
    } else if ([action isEqualToString:@"incomingCall"]) {
    }
}

- (void)openPostWithID:(NSString *)postID {
    [[Router new] showPostWithID:postID];
}

- (void)openConversationWithID:(NSString *)conversationID {
    if (conversationID) {
        [[Router new] showMessangerWithConversationID:conversationID];
    }
}

- (void)showAlertAboutLevel:(NSInteger)level {
    CGFloat height = [UIScreen mainScreen].bounds.size.width * 0.7;
    AlertWorker *aw = [[AlertWorker alloc] initWithCircleHeight:height
                                         circleOffsetProportion:0.95
                                                   heightOffset:100
                                                imageProportion:1.1
                                                    windowWidth:height * 1.1];
    [aw showAlertAboutNewLevel:level
                          text:@""
             completionHandler:^{

             }];
}

- (void)incomingCall:(NSString *)callID conversationID:(NSString *)conversationId {
    if ([self checkTopScreenWithConversationID:conversationId]) {
        [self showCallDescisionAlertWithConversationID:conversationId callID:callID];
    } else {
        [self showCallNotificationWithCallID:callID conversationID:conversationId];
    }
}

- (BOOL)checkTopScreenWithConversationID:(NSString *)conversationID {
    Router *router = [Router new];
    UIViewController *vc = [router visibleViewController];
    if ([vc isKindOfClass:[PAAMessagerVC class]]) {
        PAAMessagerVC *mvc = (PAAMessagerVC *)vc;
        NSString *cID = mvc.conversationID;
        if ([cID isEqualToString:conversationID]) {
            return YES;
        }
    }
    return NO;
}

- (void)showDecisionScreenIncomingCallWithConversationID:(NSString *)conversationID
                                                  callID:(NSString *)callID {
    Router *router = [Router new];

    [router showMessangerWithConversationID:conversationID];

    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{

                       [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                       [self showCallDescisionAlertWithConversationID:conversationID callID:callID];
                   });
}

- (void)showCallDescisionAlertWithConversationID:(NSString *)conversationID
                                          callID:(NSString *)callID {
    AlertWorker *aw = [[AlertWorker alloc] initWithType:AlertTypeIncomingCall];
    [aw showAlertAboutIncomingCall:^(BOOL answered) {
        if (answered) {
            [[Router new] showIncomingCall:callID conversationID:conversationID];
        } else {
            [[CallWorker sharedInstance] declineCall:callID];
        }
    }];
}

- (void)showCallNotificationWithCallID:(NSString *)callID
                        conversationID:(NSString *)conversationID {
    UIImage *callImage = [UIImage imageNamed:@"cameraCall"];

    [self
        showWithImage:callImage
                 text:@"Входящий вызов"
           completion:^{
               [self showDecisionScreenIncomingCallWithConversationID:conversationID callID:callID];
           }];
}

- (void)pushVC:(UIViewController *)controller {  // redo
    UIViewController *topController = [[Router new] visibleViewController];
    if (topController && topController.navigationController) {
        UINavigationController *nav = topController.navigationController;
        UIApplication *application = [UIApplication sharedApplication];
        if (application.applicationState != UIApplicationStateActive) {
            [nav popToRootViewControllerAnimated:YES];
        }
        [nav pushViewController:controller animated:YES];
    }
}

@end
