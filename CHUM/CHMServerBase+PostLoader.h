//
//  CHMServerBase+PostLoader.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 22/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMServerBase.h"
@class CHMComment;
@class CHMPost;
@interface CHMServerBase (PostLoader)

//- (void)postComment:(CHMComment *)comment
//         completion:(void (^)(CHMComment *comment, NSError *error, NSInteger
//         statusCode))completion;
//
//- (void)getCommentsForEventWithID:(NSNumber *)eventID
//                       completion:(void (^)(NSMutableArray *comments,
//                                            NSError *error,
//                                            NSInteger statusCode))completion;

#pragma mark - comment

- (void)pubComment:(CHMComment *)comment
      inPostWithID:(NSString *)postID
        completion:(void (^)(CHMComment *comment, NSError *error, NSInteger statusCode))completion;

- (void)reportCommentWithID:(NSString *)commentID
                 completion:(void (^)(NSError *error, NSInteger statusCode))completion;

- (void)deleteCommentWithID:(NSString *)commentID
                 completion:(void (^)(NSError *error, NSInteger statusCode))completion;

#pragma mark - comment like
- (void)unlikeCommnetWithID:(NSNumber *)commentID
                 completion:(void (^)(NSNumber *, NSError *, NSInteger))completion;
- (void)likeCommnetWithID:(NSNumber *)commentID
               completion:(void (^)(NSNumber *, NSError *, NSInteger))completion;

#pragma mark - post

- (void)getPostWithID:(NSString *)postID
           completion:(void (^)(CHMPost *post, NSError *error, NSInteger statusCode))completion;

- (void)getCommentsForPostWithID:(NSString *)postID
                           count:(NSInteger)count
                          offset:(NSInteger)offset
                      completion:(void (^)(NSMutableArray *, NSError *, NSInteger))completion;

- (void)reportPostWithID:(NSString *)postID
              completion:(void (^)(NSError *error, NSInteger statusCode))completion;

- (void)uploadPost:(CHMPost *)post
        completion:(void (^)(CHMPost *_Nullable post, NSError *_Nullable error, NSInteger statusCode))completion;

- (void)deletePostWithID:(NSString *)postID
              completion:(void (^)(NSError *error, NSInteger statusCode))completion;
#pragma mark - post like
- (void)likePostWithID:(NSString *)postID
            completion:
                (void (^)(NSNumber *likeCount, NSError *error, NSInteger statusCode))completion;
- (void)unlikePostWithID:(NSString *)postID
              completion:
                  (void (^)(NSNumber *likeCount, NSError *error, NSInteger statusCode))completion;

@end
