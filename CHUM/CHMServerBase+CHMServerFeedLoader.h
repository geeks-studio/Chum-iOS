//
//  CHMServerBase+CHMServerFeedLoader.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMServerBase.h"

@import MapKit;
@interface CHMServerBase (CHMServerFeedLoader)

- (void)getNearFeedForCoordinate:(CLLocationCoordinate2D)coordinate
                           count:(NSInteger)count
                          offset:(NSInteger)offset
                      completion:(void (^)(NSArray *posts, NSError *error, NSInteger statusCode))
                                     completion;

//- (void)getPlaceFeedWithCount:(NSInteger)count
//                       offset:(NSInteger)offset
//                   completion:
//                       (void (^)(NSArray *posts, NSError *error, NSInteger statusCode))completion;

#pragma mark - user

- (void)loadUserPostsWithCount:(NSInteger)count
                        offset:(NSInteger)offset
                    completion:
                        (void (^)(NSArray *posts, NSError *error, NSInteger statusCode))completion;

- (void)loadFavePostsWithCount:(NSInteger)count
                        offset:(NSInteger)offset
                    completion:
                        (void (^)(NSArray *posts, NSError *error, NSInteger statusCode))completion;

- (void)onePlaceFeed:(NSString *)placeID
               count:(NSInteger)count
              offset:(NSInteger)offset
          completion:(void (^)(NSArray *posts, NSError *error, NSInteger statusCode))completion;

@end
