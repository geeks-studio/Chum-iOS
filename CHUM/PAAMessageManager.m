//
//  PAAMessageManager.m
//  CHUM
//
//

#import "CHMCurrentUserManager.h"
#import "CHMServerBase.h"
#import "NSDate+ZPPDateCategory.h"
#import "PAAConversation.h"
#import "PAAMessage.h"
#import "PAAMessageManager.h"

@import AFNetworking;
@import DateTools;
@import SocketRocket;

NSString *const CHMShoulUpdateUnreadCount = @"CHMShoulUpdateUnreadCount";

NSString *const CHMSocketCloseReason = @"CHMSocketCloseReason";

@interface PAAMessageManager () <SRWebSocketDelegate>
@property (strong, nonatomic) NSString *baseURL;
@property (assign, nonatomic) BOOL registred;
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) NSString *pushToken;
@property (assign, nonatomic) BOOL registrationInProgress;
@property (strong, nonatomic) SRWebSocket *webSocket;
@end

@implementation PAAMessageManager

+ (instancetype)sharedInstance {
    static PAAMessageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PAAMessageManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)connectWebSocket {
    self.webSocket.delegate = nil;
    self.webSocket = nil;

    NSString *urlString = CHMWebSocket;
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;

    [newWebSocket open];
}

- (void)disconnectWebSocket {
    if (self.webSocket) {
        self.webSocket.delegate = nil;
        switch (self.webSocket.readyState) {
            case SR_OPEN:
            case SR_CONNECTING:
                [self.webSocket close];
                break;
            default:
                break;
        }
        self.webSocket = nil;
    }
}

- (void)connect {
    [self connectWebSocket];
}

- (void)setIdentifier:(NSString *)identifier {
}

#pragma mark - socket

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    self.webSocket = newWebSocket;
    NSString *jwtToken = [[CHMCurrentUserManager shared] tokenJWTString];
    NSDictionary *params = @{ @"token" : jwtToken };
    NSData *dataFromDict = [NSJSONSerialization dataWithJSONObject:params
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
    [newWebSocket send:dataFromDict];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket
 didCloseWithCode:(NSInteger)code
           reason:(NSString *)reason
         wasClean:(BOOL)wasClean {
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if (webSocket != self.webSocket) {
        [webSocket close];
        return;
    }
    if ([message isKindOfClass:[NSString class]]) {
        message = [self fixJSON:message];
        NSData *objectData = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *responseDict =
            [NSJSONSerialization JSONObjectWithData:objectData options:kNilOptions error:&error];
        NSDictionary *r = responseDict[@"response"];
        if (!r || [r isEqual:[NSNull null]]) {
            return;
        }
        NSString *actionType = responseDict[@"action"];
        if (!actionType || ![actionType isEqual:@"message"]) {
            return;
        }
        NSString *convID = r[@"conversation_id"];
        if (!convID || [convID isEqual:[NSNull null]]) {
            return;
        }

        PAAMessage *m = [[PAAMessage alloc] initWithDictionary:r];
        m.isRead = NO;
        if (self.messageRecieved) {
            self.messageRecieved(m);
        }
    }
}

- (NSString *)fixJSON:(NSString *)s {
    NSRegularExpression *regexp =
        [NSRegularExpression regularExpressionWithPattern:@"[{,]\\s*(\\w+)\\s*:"
                                                  options:0
                                                    error:NULL];
    NSMutableString *b = [NSMutableString stringWithCapacity:([s length] * 1.1)];
    __block NSUInteger offset = 0;
    [regexp
        enumerateMatchesInString:s
                         options:0
                           range:NSMakeRange(0, [s length])
                      usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags,
                                   BOOL *stop) {
                          NSRange r = [result rangeAtIndex:1];
                          [b appendString:[s substringWithRange:NSMakeRange(offset,
                                                                            r.location - offset)]];
                          [b appendString:@"\""];
                          [b appendString:[s substringWithRange:r]];
                          [b appendString:@"\""];
                          offset = r.location + r.length;
                      }];
    [b appendString:[s substringWithRange:NSMakeRange(offset, [s length] - offset)]];
    return b;
}
#pragma mark - rest

- (void)loadAllConversationsWithCompletion:
    (void (^)(NSArray *conversations, NSError *err, NSInteger statusCode))completion {
//    __weak typeof(self) weakSelf = self;
    [self.manager GET:@"user/conversations/"
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            //            NSLog(@"converstaions %@", responseObject);
            NSArray *convs = [[self class] parseConversationsDicts:responseObject[@"response"]];
            if (completion) {
                
                completion(convs, nil, 200);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

- (void)conversationForPostID:(NSString *)postID
                    commentID:(NSString *)commentID
                   completion:(void (^)(PAAConversation *conversation,
                                        NSError *err,
                                        NSInteger statusCode))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"post_id"] = postID;
    if (commentID) {
        params[@"comment_id"] = commentID;
    }
    [self.manager POST:@"user/conversation/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            //            NSLog(@"chat response %@", responseObject);
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            PAAConversation *conv =
                [[PAAConversation alloc] initWithDict:responseObject[@"response"]];
            if (completion) {
                completion(conv, nil, r.statusCode);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSString *ErrorResponse = [[NSString alloc]
                initWithData:(NSData *)
                                 error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                    encoding:NSUTF8StringEncoding];
            NSLog(@"%@", ErrorResponse);
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

- (void)loadConversationWithID:(NSString *)conversationID
                    completion:(void (^)(PAAConversation *conversation,
                                         NSError *err,
                                         NSInteger statusCode))completion {
    if (!conversationID) {
        if (completion) {
            completion(nil, nil, -1);
        }
        return;
    }
    NSDictionary *params = @{ @"conversation_id" : conversationID };
    [self.manager GET:@"user/conversation/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            PAAConversation *c = [[PAAConversation alloc] initWithDict:responseObject[@"response"]];
            if (completion) {
                completion(c, nil, 200);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

- (void)sendMessageWithText:(NSString *)text
       toConversationWithID:(NSString *)converstionID
                 completion:
                     (void (^)(PAAMessage *msg, NSError *err, NSInteger statusCode))completion {
    if (!converstionID) {
        if (completion) {
            completion(nil, nil, -1);
        }
        return;
    }
    NSDictionary *params = @{ @"conversation_id" : converstionID, @"text" : text };

    [self.manager POST:@"user/conversation/message/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            //            NSLog(@"converation %@", responseObject);
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            PAAMessage *m = [[PAAMessage alloc] initWithDictionary:responseObject];
            if (completion) {
                completion(m, nil, r.statusCode);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

- (void)readMessageWithID:(NSString *)messageID
               completion:(void (^)(NSError *err, NSInteger statusCode))completion {
    if (!messageID) {
        if (completion) {
            completion(nil, -1);
        }
        return;
    }
    NSDictionary *params = @{ @"message_id" : messageID };

    [self.manager PUT:@"user/conversation/message/read/"
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            if (completion) {
                completion(nil, 204);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSString *ErrorResponse = [[NSString alloc]
                initWithData:(NSData *)
                                 error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                    encoding:NSUTF8StringEncoding];
            NSLog(@"%@", ErrorResponse);

            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(error, r.statusCode);
            }
        }];
}

- (void)readAllMessagesInConversation:(NSString *)converstionID
                           completion:(void (^)(NSError *err, NSInteger statusCode))completion {
    if (!converstionID) {
        if (completion) {
            completion(nil, -1);
        }
        return;
    }

    NSDictionary *params = @{ @"conversation_id" : converstionID };

    [self.manager PUT:@"user/conversation/message/read/all/"
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            if (completion) {
                completion(nil, 204);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

            NSString *ErrorResponse = [[NSString alloc]
                initWithData:(NSData *)
                                 error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                    encoding:NSUTF8StringEncoding];
            NSLog(@"%@", ErrorResponse);

            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(error, r.statusCode);
            }
        }];
}

- (void)loadAllMessagesInConversation:(NSString *)conversationID
                           untillDate:(NSDate *)date
                                count:(NSInteger)count
                           completion:(void (^)(NSArray *messages,
                                                NSError *err,
                                                NSInteger statusCode))completion {
    NSMutableDictionary *params =
        @{ @"conversation_id" : conversationID,
           @"count" : @(count)
        }.mutableCopy;

    if (date) {
        NSString *stringDate = [date serverFormattedString];
        params[@"last_message_time"] = stringDate;
    }

    [self.manager GET:@"user/conversation/messages/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            //            NSLog(@"messages %@", responseObject);
            NSMutableArray *tmp = [NSMutableArray array];
            NSArray *messageDicts = responseObject[@"response"];

            for (NSDictionary *d in messageDicts) {
                PAAMessage *msg = [[PAAMessage alloc] initWithDictionary:d];
                [tmp insertObject:msg atIndex:0];
            }
            NSArray *res = [NSArray arrayWithArray:tmp];
            if (completion) {
                completion(res, nil, 200);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

- (void)unBlockConversationWithID:(NSString *)conversationID
                       completion:(void (^)(NSError *err, NSInteger statusCode))completion {
    [self blockUnblockActionWithConversationID:conversationID
                                      endpoint:@"user/conversation/unblock/"
                                    completion:completion];
}

- (void)blockConversationWithID:(NSString *)conversationID
                     completion:(void (^)(NSError *err, NSInteger statusCode))completion {
    [self blockUnblockActionWithConversationID:conversationID
                                      endpoint:@"user/conversation/block/"
                                    completion:completion];
}

- (void)blockUnblockActionWithConversationID:(NSString *)conversationID
                                    endpoint:(NSString *)endpoint
                                  completion:
                                      (void (^)(NSError *err, NSInteger statusCode))completion {
    NSDictionary *params = @{ @"conversation_id" : conversationID };
    [self.manager PUT:endpoint
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            if (completion) {
                completion(nil, 201);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(error, r.statusCode);
            }
        }];
}

#pragma mark - parsers

+ (NSArray *)parseConversationsDicts:(NSArray *)convDicts {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSDictionary *d in convDicts) {
        PAAConversation *c = [[PAAConversation alloc] initWithDict:d];
        [tmp addObject:c];
    }
    return [NSArray arrayWithArray:tmp];
}

#pragma mark - support

- (void)getTotalUnreadCount:(void (^)(NSNumber *unreadCount))completion {
    [self.manager GET:@"user/conversation/message/unread/"
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            NSDictionary *payload = responseObject[@"response"];
            NSNumber *count = payload[@"count_of_unread_messages"];
            if (![count isKindOfClass:[NSNumber class]]) {
                count = @(0);
            }
            if (completion) {
                completion(count);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            if (completion) {
                completion(@(0));
            }
        }];
}

- (void)updateUnreadCountEverywhere {
    [self getTotalUnreadCount:^(NSNumber *_Nonnull unreadCount) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CHMShoulUpdateUnreadCount
                                                            object:unreadCount];
    }];
}

#pragma mark - lazy

- (AFHTTPSessionManager *)manager {
    return [CHMServerBase shared].manager;
}

@end
