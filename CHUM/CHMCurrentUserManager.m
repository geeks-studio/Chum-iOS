//
//  CHMCurrentUserManager.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import "CHMCurrentUserManager.h"
#import "CHMServerBase+CHMUserLoader.h"
#import "CHMSettings.h"
#import "CHMUser.h"
#include "TargetConditionals.h"
@import CloudKit;

NSString *const CHMTokenKey = @"CHMTokenKey";
NSString *const CHMNeedAskKey = @"CHMNeedAskKey";
NSString *const CHMNeedUpdateLists = @"CHMNeedUpdateLists";
NSString *const CHMUUID = @"CHMUUID";
NSString *const CHMICloudID = @"CHMICloudID";

NSString *const kCHMSettingsKey = @"kCHMSettingsKey";

@implementation CHMCurrentUserManager

+ (instancetype)shared {
    static CHMCurrentUserManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CHMCurrentUserManager alloc] init];
    });
    return sharedInstance;
}

- (NSString *)token {
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:CHMTokenKey];

    if (!token) {
        token = @"";
    }

    return token;
}

- (NSString *)tokenJWTString {
    return [NSString stringWithFormat:@"JWT %@", [self token]];
}

- (void)setToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:CHMTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isAskedPlace {
    return [[NSUserDefaults standardUserDefaults] boolForKey:CHMNeedAskKey];
}

- (void)setAskedPlace:(BOOL)isNeedAsk {
    [[NSUserDefaults standardUserDefaults] setBool:isNeedAsk forKey:CHMNeedAskKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)randomUUID {
    if (NSClassFromString(@"NSUUID")) {  // only available in iOS >= 6.0
        return [[NSUUID UUID] UUIDString];
    }
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfuuid = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [((__bridge NSString *)cfuuid)copy];
    CFRelease(cfuuid);
    return uuid;
}

- (void)cloudIDAsync:(void (^)(NSString *record, NSError *err))completion {
    NSString *tkn = [self currentCloudID];

    if (tkn) {
        [CrashlyticsKit setUserIdentifier:tkn];
        if (completion) {
            completion(tkn, nil);
        }
        return;
    }

    //    CKContainer
    CKContainer *container = [CKContainer defaultContainer];

    [container fetchUserRecordIDWithCompletionHandler:^(CKRecordID *_Nullable recordID,
                                                        NSError *_Nullable error) {

        NSString *rcrdName = nil;
        if (!error) {
//            rcrdName = recordID.recordName;

            rcrdName = recordID.recordName;

        } else {
            rcrdName = [[self class] randomUUID];
        }

//        rcrdName = [rcrdName stringByAppendingString:@"kekkk"];//REDO
        [[NSUserDefaults standardUserDefaults] setObject:rcrdName forKey:CHMICloudID];

        [CrashlyticsKit setUserIdentifier:rcrdName];

        completion(rcrdName, error);

    }];
}

- (NSString *)currentCloudID {
    NSString *tkn = [[NSUserDefaults standardUserDefaults] stringForKey:CHMICloudID];

//    tkn = @"test";
#if (TARGET_IPHONE_SIMULATOR)
    tkn = @"simulator_ios_key101";

#endif

    return tkn;
}

- (NSString *)md5CloudID {
    return [self md5:[self currentCloudID]];
}

#pragma mark - md5

- (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), digest);  // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}

#pragma mark - push

- (void)setPushToken:(NSString *)pushToken {
    pushToken = [pushToken
        stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    pushToken = [pushToken stringByReplacingOccurrencesOfString:@" " withString:@""];

    [[CHMServerBase shared] uploadUserPushToken:pushToken
                                     completion:^(NSError *error, NSInteger statusCode){
                                     }];
}

#pragma mark - settings

- (void)setSettings:(CHMSettings *)settings {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:settings];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:kCHMSettingsKey];
    [defaults synchronize];
}

- (CHMSettings *)settings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:kCHMSettingsKey];
    CHMSettings *object;  //= [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];

    if (encodedObject) {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    } else {
        object = [[CHMSettings alloc] init];
    }
    return object;
}

#pragma mark - super user

- (BOOL)canDeletePostInPlaceWithID:(NSString *)placeID {
    if (!self.user) {
        return NO;
    } else if ([self.user.superUserTypeName isEqualToString:CHMUserTypeNameSuperUser]) {
        return YES;
    } else {
        return NO;
    }
}

//-(BOOL)messagePush {
//    return [[NSUserDefaults standardUserDefaults] boolForKey:kCHMMessagePushKey];
//}
//
//- (void)setMessagePush:(BOOL)messagePush {
//    [[NSUserDefaults standardUserDefaults] setBool:messagePush forKey:kCHMMessagePushKey];
//}
//
//- (BOOL)commentsPush {
//    return [[NSUserDefaults standardUserDefaults] boolForKey:kCHMCommentsPushKey];
//}
//
//-(void)setCommentsPush:(BOOL)commentsPush {
//    [[NSUserDefaults standardUserDefaults] setBool:commentsPush forKey:kCHMCommentsPushKey];
//}
//
//- (BOOL)levelsPush {
//    return [[NSUserDefaults standardUserDefaults] boolForKey:kCHMLevelsPushKey];
//}
//
//- (void)setLevelsPush:(BOOL)levelsPush {
//    [[NSUserDefaults standardUserDefaults] setBool:levelsPush forKey:kCHMLevelsPushKey];
//}

@end
