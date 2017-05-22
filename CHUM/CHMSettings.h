//
//  CHMSettings.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 13/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHMSettings : NSObject

@property (assign, nonatomic) BOOL messagePush;
@property (assign, nonatomic) BOOL commentsPush;
@property (assign, nonatomic) BOOL levelsPush;

- (NSDictionary *)asDict;

@end
