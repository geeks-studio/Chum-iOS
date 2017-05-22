//
//  CHMServerBase+CallLoader.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 30/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMPostHelper.h"
#import "CHMServerBase+CallLoader.h"

#import "CHUM-Swift.h"

@import AFNetworking;

@implementation CHMServerBase (CallLoader)

- (void)loadVoxUserWithCompletion:(void (^)(VoxUser *_Nullable voxUser,
                                            NSError *_Nullable error,
                                            NSInteger statusCode))completion {
    [self.manager GET:@"vox/session/new/"
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            NSDictionary *voxUserDict = responseObject[@"response"];
            VoxUser *user = [CHMPostHelper parseVoxUser:voxUserDict];

            if (completion) {
                completion(user, nil, 200);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

- (void)extendVoxSession:(void (^)(NSError *_Nullable err, NSInteger statusCode))completion {
    [self.manager POST:@"vox/session/extend/"
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            if (completion) {
                completion(nil, 200);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            if (completion) {
                 NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
                completion(error, r.statusCode);
            }
        }];
}

- (void)closeVoxSession:(void (^)(NSError *_Nullable err, NSInteger statusCode))completion {
    [self.manager POST:@"vox/session/close/"
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            if (completion) {
                completion(nil, 200);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(error, r.statusCode);
            }
        }];
}

- (void)getInterlocutorNameForConversationWithID:(NSString *)conversationID
                                      completion:(void (^)(NSString *_Nullable opponenName,
                                                           NSError *_Nullable error,
                                                           NSInteger statusCode))completion {
    NSDictionary *params = @{ @"conversation_id" : conversationID };

    [self.manager GET:@"user/conversation/interlocutor_name/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            NSDictionary *resp = responseObject[@"response"];
            NSString *username = resp[@"interlocutor_name"];
            if ([username isEqual:[NSNull null]]) {
                username = nil;
            }
            
            if (completion) {
                completion(username, nil, 200);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(nil, nil, r.statusCode);
            }
        }];
}



@end
