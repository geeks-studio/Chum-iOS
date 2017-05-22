//
//  CHMServerBase+PostLoader.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 22/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMComment.h"
#import "CHMComment.h"
#import "CHMCurrentUserManager.h"
#import "CHMPost.h"
#import "CHMPostHelper.h"
#import "CHMServerBase+PostLoader.h"
@import AFNetworking;

@implementation CHMServerBase (PostLoader)

- (void)getPostWithID:(NSString *)postID
           completion:(void (^)(CHMPost *post, NSError *error, NSInteger statusCode))completion {
    NSDictionary *params = @{ @"post_id" : postID };

    [self.manager GET:@"post/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            CHMPost *post = [CHMPostHelper parsePost:responseObject[@"response"]];

            if (completion) {
                completion(post, nil, 200);
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

- (void)uploadPost:(CHMPost *)post
        completion:(void (^)(CHMPost *post, NSError *error, NSInteger statusCode))completion {
    NSMutableDictionary *params = [CHMPostHelper dictionaryFromPost:post];

    if (!params) {
        if (completion) {
            completion(nil, nil, -1);
        }
        return;
    }

    [self.manager POST:@"post/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            NSString *postID = responseObject[@"post_id"];
            post.postID = postID;

            if (completion) {
                completion(post, nil, 200);
            }

        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;

            NSString *ErrorResponse = [[NSString alloc]
                initWithData:(NSData *)
                                 error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                    encoding:NSUTF8StringEncoding];
            NSLog(@"%@", ErrorResponse);

            if (completion) {
                completion(nil, error, r.statusCode);
            }

        }];
}

- (void)likePostWithID:(NSString *)postID
            completion:
                (void (^)(NSNumber *likeCount, NSError *error, NSInteger statusCode))completion {
    NSDictionary *params = @{ @"post_id" : postID };

    [self.manager PUT:@"post/like/"
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            id rsp = responseObject[@"response"];
            NSNumber *likeCount = rsp[@"likes"];

            if (completion) {
                completion(likeCount, nil, 200);
            }

        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;

            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

- (void)unlikePostWithID:(NSString *)postID
              completion:
                  (void (^)(NSNumber *likeCount, NSError *error, NSInteger statusCode))completion {
    NSDictionary *params = @{ @"post_id" : postID };

    [self.manager PUT:@"post/unlike/"
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            id rsp = responseObject[@"response"];
            NSNumber *likeCount = rsp[@"likes"];

            if (completion) {
                completion(likeCount, nil, 200);
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

- (void)reportPostWithID:(NSString *)postID
              completion:(void (^)(NSError *error, NSInteger statusCode))completion {
    NSDictionary *params = @{ @"post_id" : postID };
    [self.manager POST:@"post/report/"
        parameters:params
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

- (void)deletePostWithID:(NSString *)postID
              completion:(void (^)(NSError *error, NSInteger statusCode))completion {
    NSDictionary *params = @{ @"post_id" : postID };

    [self.manager DELETE:@"post/"
        parameters:params
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

#pragma mark - comments

- (void)pubComment:(CHMComment *)comment
      inPostWithID:(NSString *)postID
        completion:(void (^)(CHMComment *comment, NSError *error, NSInteger statusCode))completion {
    NSString *pid = [NSString stringWithFormat:@"%@", postID];
    NSMutableDictionary *params = @{ @"post_id" : pid, @"text" : comment.commentText }.mutableCopy;

    if (comment.replyCommentID) {
        params[@"replay_to"] = comment.replyCommentID;
    }

    [self.manager POST:@"post/comment/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            CHMComment *c = [CHMPostHelper parseComment:responseObject[@"response"]];

            if (completion) {
                completion(c, nil, 200);
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

- (void)getCommentsForPostWithID:(NSString *)postID
                           count:(NSInteger)count
                          offset:(NSInteger)offset
                      completion:(void (^)(NSMutableArray *, NSError *, NSInteger))completion {
    NSDictionary *params = @{ @"post_id" : postID, @"count" : @(count), @"offset" : @(offset) };

    [self.manager GET:@"post/comments/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            NSLog(@"comment response %@", responseObject);

            NSMutableArray *result = [CHMPostHelper parseComments:responseObject[@"response"]];

            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(result, nil, r.statusCode);
            }

        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

//- (void)reportPostWithID:(NSNumber *)postID compl

#pragma mark - comments like

- (void)likeCommnetWithID:(NSNumber *)commentID
               completion:(void (^)(NSNumber *, NSError *, NSInteger))completion {
    if (!commentID) {
        if (completion) {
            completion(nil, nil, -1);
        }
        return;
    }

    NSDictionary *params = @{ @"comment_id" : commentID };

    [self.manager PUT:@"post/comment/like/"
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            //           NSNumber
            //        NSLog(@"%@ ",)

            id rsp = responseObject[@"response"];
            NSNumber *likeCount = rsp[@"likes"];

            if (completion) {
                completion(likeCount, nil, 200);
            }

        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

- (void)unlikeCommnetWithID:(NSNumber *)commentID
                 completion:(void (^)(NSNumber *, NSError *, NSInteger))completion {
    NSDictionary *params = @{ @"comment_id" : commentID };

    [self.manager PUT:@"post/comment/unlike/"
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            id rsp = responseObject[@"response"];
            NSNumber *likeCount = rsp[@"likes"];

            if (completion) {
                completion(likeCount, nil, 200);
            }

            //            NSLog(@"like rsp %@", responseObject);
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

#pragma mark - comment report

- (void)reportCommentWithID:(NSString *)commentID
                 completion:(void (^)(NSError *error, NSInteger statusCode))completion {
    NSDictionary *params = @{ @"comment_id" : commentID };

    [self.manager POST:@"post/comment/report/"
        parameters:params
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

- (void)deleteCommentWithID:(NSString *)commentID
                 completion:(void (^)(NSError *error, NSInteger statusCode))completion {
    NSDictionary *params = @{ @"comment_id" : commentID };

    [self.manager DELETE:@"post/comment/"
        parameters:params
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

//- (void)deletePostWithID:(NSString *)postID

@end
