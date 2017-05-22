//
//  CHMServerBase+CHMServerFeedLoader.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMCurrentUserManager.h"
#import "CHMPostHelper.h"
#import "CHMServerBase+CHMServerFeedLoader.h"
#import "NSDictionary+JSONCategory.h"
@import AFNetworking;
//@import MapKit;

@implementation CHMServerBase (CHMServerFeedLoader)

- (void)getNearFeedForCoordinate:(CLLocationCoordinate2D)coordinate
                           count:(NSInteger)count
                          offset:(NSInteger)offset
                      completion:(void (^)(NSArray *posts, NSError *error, NSInteger statusCode))
                                     completion {
    //    NSString *token = [CHMCurrentUserManager shared].token;

    NSDictionary *params = @{
        @"lat" : @(coordinate.latitude),
        @"lon" : @(coordinate.longitude),
        @"count" : @(count),
        @"offset" : @(offset)
    };

    [self loadPostsWithEndpoint:@"near_feed/" params:params completion:completion];

    //    [self.manager GET:@"near_feed"
    //        parameters:params
    //        progress:nil
    //        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
    //
    //            NSLog(@"feed response %@", responseObject);
    //
    //            NSArray *result = [CHMPostHelper parsePostsDicts:responseObject];
    //
    //            if (completion) {
    //                NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
    //                completion(result, nil, r.statusCode);
    //            }
    //
    //        }
    //        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
    //            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
    //
    //            if (completion) {
    //                completion(nil, error, r.statusCode);
    //            }
    //        }];
}

- (void)onePlaceFeed:(NSString *)placeID
               count:(NSInteger)count
              offset:(NSInteger)offset
          completion:(void (^)(NSArray *posts, NSError *error, NSInteger statusCode))completion {
    if (!placeID) {
        completion(nil, [NSNull null], -1);
        return;
    }
    NSDictionary *params = @{ @"theme_id" : placeID, @"count" : @(count), @"offset" : @(offset) };

    [self loadPostsWithEndpoint:@"one_theme_feed/" params:params completion:completion];
}



- (void)loadUserPostsWithCount:(NSInteger)count
                        offset:(NSInteger)offset
                    completion:
                        (void (^)(NSArray *posts, NSError *error, NSInteger statusCode))completion {
    [self loadPostsWithEndpoint:@"user/posts/" count:count offset:offset completion:completion];
}
- (void)loadFavePostsWithCount:(NSInteger)count
                        offset:(NSInteger)offset
                    completion:
                        (void (^)(NSArray *posts, NSError *error, NSInteger statusCode))completion {
    [self loadPostsWithEndpoint:@"user/active/" count:count offset:offset completion:completion];
}

//- ()

- (void)loadPostsWithEndpoint:(NSString *)endpoint
                        count:(NSInteger)count
                       offset:(NSInteger)offset
                   completion:
                       (void (^)(NSArray *posts, NSError *error, NSInteger statusCode))completion {
    //    NSString *token = [CHMCurrentUserManager shared].token;
    NSDictionary *params = @{ @"count" : @(count), @"offset" : @(offset) };

    [self loadPostsWithEndpoint:endpoint params:params completion:completion];
}

- (void)loadPostsWithEndpoint:(NSString *)endpoint
                       params:(NSDictionary *)params
                   completion:
                       (void (^)(NSArray *posts, NSError *error, NSInteger statusCode))completion {
    [self.manager GET:endpoint
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

//            NSLog(@"feed response %@", responseObject);

            NSArray *result = [CHMPostHelper parsePostsDicts:responseObject[@"response"]];

            if (completion) {
                NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
                completion(result, nil, r.statusCode);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;

            NSString *ErrorResponse = [[NSString alloc]
                initWithData:(NSData *)
                                 error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                    encoding:NSUTF8StringEncoding];
            NSLog(@"%@", ErrorResponse);

            NSLog(@"error %@", error);

            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

@end
