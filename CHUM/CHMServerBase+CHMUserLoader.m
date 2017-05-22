//
//  CHMServerBase+CHMUserLoader.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 10/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "CHMCurrentUserManager.h"
#import "CHMPlace.h"
#import "CHMPostHelper.h"
#import "CHMServerBase+CHMUserLoader.h"
#import "CHMSettings.h"
#import "CHMUser.h"
#import "Obfuscator.h"

#import "CHUM-Swift.h"

@import AFNetworking;
@import RNCryptor;

const unsigned char _key[] = {0x9,  0x4D, 0x13, 0x56, 0x50, 0x9,  0x5C, 0xF,  0x50,
                              0x40, 0x7,  0x47, 0x43, 0x13, 0x57, 0x16, 0x50, 0x00};
const unsigned char *key = &_key[0];

@implementation CHMServerBase (CHMUserLoader)

- (void)registrateWithID:(NSString *)identifier
              completion:(void (^)(NSString *_Nullable token,
                                   NSError *_Nullable error,
                                   NSInteger statusCode))completion {
    NSURL *url = [NSURL URLWithString:CHMBaseUrl];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    identifier = [[CHMCurrentUserManager shared] md5:identifier];

    Obfuscator *o = [Obfuscator newWithSalt:[NSString class], nil];

    NSString *password = [o reveal:key];

    NSData *ciphertext = [[NSData alloc] initWithBase64EncodedString:CHMAPIKEY options:0];

    NSData *plaintext = [RNCryptor decryptData:ciphertext password:password error:nil];

    NSString *api_key = [[NSString alloc] initWithData:plaintext encoding:NSUTF8StringEncoding];

    NSDictionary *params = @{ @"user_id" : identifier, @"platform" : @"ios", @"api_key" : api_key };

    [manager POST:@"api/v2/auth/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            NSString *token = responseObject[@"access_token"];

            if (completion) {
                completion(token, nil, 200);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;

            //            NSLog(@"error %@", error);

            //            NSString *ErrorResponse = [[NSString alloc]
            //                initWithData:(NSData *)
            //                                 error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
            //                    encoding:NSUTF8StringEncoding];
            //            NSLog(@"reg err response %@", ErrorResponse);

            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

- (void)getCurrentUserWithCompletion:
    (void (^)(CHMUser *user, NSError *error, NSInteger statusCode))completion {
    [self.manager GET:@"user/"
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            //            NSLog(@"user response %@", responseObject);

            CHMUser *user = [CHMPostHelper parseUser:responseObject[@"response"]];
            [CHMCurrentUserManager shared].user = user;
            if (completion) {
                completion(user, nil, 200);
            }

        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            NSLog(@"error %@", error);
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

- (void)loadKarmaWithCompletion:
    (void (^)(Karma *karma, NSError *error, NSInteger statusCode))completion {
    [self.manager GET:@"user/karma/"
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            Karma *k = [CHMPostHelper parseKarma:responseObject[@"response"]];

            if (completion) {
                completion(k, nil, 200);
            }

        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            if (completion) {
                completion(nil, nil, 400);
            }
        }];
}

- (void)loadRadiusWithCompletion:
    (void (^)(NSNumber *radius, NSError *error, NSInteger statusCode))completion {
    [self.manager GET:@"user/radius/"
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            NSDictionary *d = responseObject[@"response"];
            NSNumber *radius = d[@"radius"];

            if ([radius isEqual:[NSNull null]]) {
                radius = nil;
            }

            if (completion) {
                completion(radius, nil, 200);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            if (completion) {
                completion(nil, nil, 400);
            }
        }];
}

- (void)loadAllPlacesType:(NSString *)type
                    count:(NSInteger)count
                   offset:(NSInteger)offset
           withCompletion:
               (void (^)(NSArray *places, NSError *error, NSInteger statusCode))completion {
    NSMutableDictionary *params = [@{ @"count" : @(count), @"offset" : @(offset) } mutableCopy];

    if (type) {
        params[@"type"] = type;
    }

    [self.manager GET:@"themes/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            NSArray *places = [CHMPostHelper parsePlaces:responseObject[@"response"]];

            if (completion) {
                completion(places, nil, 200);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            NSLog(@"error %@", error);
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

- (void)loadAllTypesCount:(NSInteger)count
                   offset:(NSInteger)offset
           withCompletion:
               (void (^)(NSArray *types, NSError *error, NSInteger statusCode))completion {
    NSDictionary *params = @{ @"count" : @(count), @"offset" : @(offset) };

    [self.manager GET:@"places/types/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            NSArray *typesDicts = responseObject[@"response"];
            NSArray *types = [CHMPostHelper parseTypes:typesDicts];
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(types, nil, r.statusCode);
            }

        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            NSLog(@"error %@", error);
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

- (NSURLSessionDataTask *)
searchPlaceWithText:(NSString *)text
               city:(NSString *)city
               type:(NSString *)type
        placesCount:(NSInteger)count
             offset:(NSInteger)offset
     withCompletion:(void (^)(NSArray *places, NSError *error, NSInteger statusCode))completion {
    NSMutableDictionary *params =
        [@{ @"count" : @(count),
            @"offset" : @(offset),
            @"find_text" : text } mutableCopy];

    if (type) {
        params[@"type"] = type;
    }

    NSURLSessionDataTask *tsk = [self.manager GET:@"themes/find/"
        parameters:params
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            NSArray *places = [CHMPostHelper parsePlaces:responseObject[@"response"]];

            if (completion) {
                completion(places, nil, 200);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            NSLog(@"error %@", error);
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
    return tsk;
}

//- (void)addPlace:(CHMPlace *)place
//      completion:(void (^)(NSError *error, NSInteger statusCode))completion {
//    if (!place.placeID) {
//        if (completion) {
//            NSError *err = [NSError errorWithDomain:@"err" code:-1 userInfo:nil];
//            completion(err, -1);
//        }
//        return;
//    }
//
//    NSDictionary *params = @{ @"place_id" : place.placeID };
//    [self.manager PUT:@"user/place/"
//        parameters:params
//        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//
//            if (completion) {
//                completion(nil, 204);
//            }
//        }
//        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
//            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
//            if (completion) {
//                completion(error, r.statusCode);
//            }
//        }];
//}

//- (void)removePlaceWithID:(NSString *)placeID
//               completion:(void (^)(NSError *error, NSInteger statusCode))completion {
//    if (!placeID) {
//        if (completion) {
//            NSError *err = [NSError errorWithDomain:@"err" code:-1 userInfo:nil];
//            completion(err, -1);
//        }
//        return;
//    }
//
//    NSDictionary *params = @{ @"place_id" : placeID };
//
//    [self.manager DELETE:@"user/place/"
//        parameters:params
//        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//            if (completion) {
//                completion(nil, 204);
//            }
//        }
//        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
//            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
//            if (completion) {
//                completion(error, r.statusCode);
//            }
//
//            NSLog(@"error %@", error);
//
//            NSString *ErrorResponse = [[NSString alloc]
//                initWithData:(NSData *)
//                                 error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
//                    encoding:NSUTF8StringEncoding];
//            NSLog(@"remover err response %@", ErrorResponse);
//
//        }];
//}

#pragma mark - settings

- (void)loadSettingsWithCompletion:
    (void (^)(CHMSettings *sets, NSError *error, NSInteger statusCode))completion {
    [self.manager GET:@"user/settings/"
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            NSDictionary *d = responseObject[@"response"];

            CHMSettings *settings = [CHMPostHelper parseSettings:d];
            if (completion) {
                completion(settings, nil, 200);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(nil, error, r.statusCode);
            }

        }];
}

- (void)updateSettings:(CHMSettings *)settings
            completion:
                (void (^)(CHMSettings *sets, NSError *error, NSInteger statusCode))completion {
    NSDictionary *params = [settings asDict];

    [self.manager PUT:@"user/settings/"
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            NSDictionary *d = responseObject[@"response"];

            CHMSettings *settings = [CHMPostHelper parseSettings:d];
            if (completion) {
                completion(settings, nil, 200);
            }

        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(nil, error, r.statusCode);
            }
        }];
}

#pragma mark - push

- (void)uploadUserPushToken:(NSString *)pushToken
                 completion:(void (^)(NSError *error, NSInteger statusCode))completion {
    if (!pushToken) {
        if (completion) {
            completion([NSNull null], -1);
        }
        return;
    }
    NSDictionary *params = @{ @"token" : pushToken };

    [self.manager PUT:@"user/token/"
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            if (completion) {
                completion(nil, 204);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(error, r.statusCode);
            }
        }];
}

- (void)pushMeBaby {
    [self.manager GET:@"push/me/baby/"
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){

        }];
}

#pragma mark - super user

- (void)activateSuperUserWithCode:(NSString *)code
                       completion:(void (^)(NSError *error, NSInteger statusCode))completion {
    NSDictionary *params = @{ @"code" : code };
    [self.manager PUT:@"user/activation/"
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            if (completion) {
                completion(nil, 204);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(error, r.statusCode);
            }
        }];
}

#pragma mark - super post

- (void)buySuperPostWithCompletion:(void (^)(NSError *error, NSInteger statusCode))completion {
    [self.manager PUT:@"user/increase_super_post_count/"
        parameters:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            if (completion) {
                completion(nil, 204);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            if (completion) {
                completion(error, r.statusCode);
            }
        }];
}

#pragma mark - vox

//- (void)loadVoxUserWithCompletion:
//    (void (^)(VoxUser *voxUser, NSError *error, NSInteger statusCode))completion {
//    [self.manager GET:@"user/vox_credentials/"
//        parameters:nil
//        progress:nil
//        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//
//            NSDictionary *voxUserDict = responseObject[@"response"];
//            VoxUser *user = [CHMPostHelper parseVoxUser:voxUserDict];
//
//            if (completion) {
//                completion(user, nil, 200);
//            }
//        }
//        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
//            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
//            if (completion) {
//                completion(nil, error, r.statusCode);
//            }
//        }];
//}

@end
