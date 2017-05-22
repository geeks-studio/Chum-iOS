//
//  CHMServerBase.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 22/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMCurrentUserManager.h"
#import "CHMServerBase.h"
#import "Obfuscator.h"
#import "AppDelegate.h"
@import AFNetworking;
@import RNCryptor;

#define CHMProduction 0

#if CHMProduction
NSString *const CHMBaseUrl = @"https://production.chum.space";
NSString *const CHMWebSocket = @"wss://production.chum.space/chat/websocket";
NSString *const CHMAPIKEY = @"AwGSVGJXH7qpylntuJQhW+ySzSVaf49OmmHIGQ7PAHFYKM4UUvZOY288xwPEzdrLf/iMoHtz13njqM0XGm0iEyovaUlpe5HiYv9EZhTx7uGuxYvvPFT7VjASN+c0K/AACJRibigYG1hzZeIXKsydUqjTQeilmLxmZQEh8yATukoQQnyZMSrh/wXyyUZt8JkCajajxIEpxf/X7PHZGHAfSEvgZnQgoiKAMQ6Rg4On7ZWhwLqDV8U3BJuPNogvZvsKkgbwyz+8+osqxvdNWqQ0fDRedJ9NcaoGG5t/bbIUXl1iXWVq+jpB3M0xX9YLlvRW+wt3xcRXIh9s1LKb4IO0Fuo0NnOhwnhFuXvJA8ixv1cLew==";
NSString *const CHMVoxLogin = @"prod.chumapp.voximplant.com";
#else
NSString *const CHMBaseUrl = @"https://dev.chum.space";
NSString *const CHMWebSocket = @"wss://dev.chum.space/chat/websocket";
NSString *const CHMAPIKEY = @"AwGy4aFAtl6qy/uDxVvtL42yIjv+ARwcjz+YBDIw8AqyhK75s7Vt+1mNrNzfgnfgP9PFjNXa2wL6zXboqxl9Aikd8LMc+rJlOIwuGqAA/oUvNmqILWLPFFa9vssnMeMCiKfjT0c3gJNbDTIIgNNEn0wmjQNNTiOXgcKqCaTilV0lYaK4UVlDO4Rzd3dApQljscyc7ZfenzQ5xbHTDm2k7PwVjCinV3jswLT0i+TtVOh0sQPlGS6xZFoJbpYXT7D8opJJ3HXkj4On8Q6JqP1Uf3Z0GSlIfwx48tKMgDwJAwGQGAd1kKMJ8uGIndMRk61Y0XIBsS8bHbQyss5DveOtJNJfwhuxLv9HdYZUJUL5RDzWMA==";
NSString *const CHMVoxLogin = @"dev.chumapp.voximplant.com";
#endif

NSString *const CHMParametrLostErrorDomain = @"CHMParametrLostErrorDomain";

@interface CHMServerBase ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation CHMServerBase

+ (instancetype)shared {
    static CHMServerBase *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CHMServerBase alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.manager.requestSerializer setValue:@"application/json"
                              forHTTPHeaderField:@"Content-Type"];
        
    }
    return self;
}

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        NSString *apiPath = [NSString stringWithFormat:@"%@/%@/%@", CHMBaseUrl, @"api", @"v2"];

        NSURL *url = [NSURL URLWithString:apiPath];
        //        NSLog(@"%@", url.absoluteString);
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }

    if ([CHMCurrentUserManager shared].token) {
        NSString *tkn = [NSString stringWithFormat:@"JWT %@", [CHMCurrentUserManager shared].token];

        [_manager.requestSerializer setValue:tkn forHTTPHeaderField:@"Authorization"];

    }
    return _manager;
}

@end
