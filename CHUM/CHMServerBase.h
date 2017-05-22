//
//  CHMServerBase.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 22/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CHMBaseUrl;
extern NSString *const CHMAPIKEY;
extern NSString *const CHMWebSocket;
extern NSString *const CHMVoxLogin;

@class AFHTTPSessionManager;

extern NSString *const CHMParametrLostErrorDomain;

@interface CHMServerBase : NSObject
@property (strong, nonatomic, readonly) AFHTTPSessionManager *manager;

+ (instancetype)shared;

@end
