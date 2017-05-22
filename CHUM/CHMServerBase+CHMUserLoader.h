//
//  CHMServerBase+CHMUserLoader.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 10/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMServerBase.h"

@class CHMPlace;
@class CHMUser;
@class CHMSettings;
@class VoxUser;
@class Karma;

@interface CHMServerBase (CHMUserLoader)

- (void)registrateWithID:(NSString *)identifier
              completion:(void (^)(NSString *_Nullable token,
                                   NSError *_Nullable error,
                                   NSInteger statusCode))completion;

//- (void)loadMyPlacesCount:(NSInteger)count
//                   offset:(NSInteger)offset
//           withCompletion:(void (^)(NSArray *_Nullable places,
//                                    NSError *_Nullable error,
//                                    NSInteger statusCode))completion;

//- (void)addPlace:(CHMPlace *)place
//      completion:(void (^)(NSError *_Nullable error, NSInteger statusCode))completion;
//
//- (void)removePlaceWithID:(NSString *)placeID
//               completion:(void (^)(NSError *error, NSInteger statusCode))completion;

- (void)loadAllPlacesType:(nullable NSString *)type
                    count:(NSInteger)count
                   offset:(NSInteger)offset
           withCompletion:(void (^)(NSArray<CHMPlace *> *_Nullable places,
                                    NSError *_Nullable error,
                                    NSInteger statusCode))completion;

//- (void)loadAllTypesCount:(NSInteger)count
//                   offset:(NSInteger)offset
//           withCompletion:(void (^)(NSArray *_Nullable types,
//                                    NSError *_Nullable error,
//                                    NSInteger statusCode))completion;

- (NSURLSessionDataTask *)searchPlaceWithText:(nonnull NSString *)text
                                         city:(nullable NSString *)city
                                         type:(nullable NSString *)type
                                  placesCount:(NSInteger)count
                                       offset:(NSInteger)offset
                               withCompletion:(nonnull void (^)(NSArray *_Nullable places,
                                                                NSError *_Nullable error,
                                                                NSInteger statusCode))completion;

- (void)getCurrentUserWithCompletion:
    (void (^)(CHMUser *user, NSError *error, NSInteger statusCode))completion;

- (void)loadKarmaWithCompletion:
    (void (^)(Karma *karma, NSError *error, NSInteger statusCode))completion;
- (void)loadRadiusWithCompletion:
    (void (^)(NSNumber *radius, NSError *error, NSInteger statusCode))completion;

- (void)uploadUserPushToken:(NSString *)pushToken
                 completion:(void (^)(NSError *error, NSInteger statusCode))completion;

- (void)pushMeBaby;

#pragma mark - settings

- (void)updateSettings:(CHMSettings *)settings
            completion:
                (void (^)(CHMSettings *sets, NSError *error, NSInteger statusCode))completion;

- (void)loadSettingsWithCompletion:
    (void (^)(CHMSettings *sets, NSError *error, NSInteger statusCode))completion;

#pragma mark - super user

- (void)activateSuperUserWithCode:(NSString *)code
                       completion:(void (^)(NSError *error, NSInteger statusCode))completion;

- (void)buySuperPostWithCompletion:(void (^)(NSError *error, NSInteger statusCode))completion;

@end
