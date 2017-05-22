//
//  CHMLikeStatus.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CHMLikeType) {
    CHMLikeTypeNone,
    CHMLikeTypePositive,
    CHMLikeTypeNegative
};

@interface CHMLikeStatus : NSObject

@property (assign, nonatomic) NSInteger likeCount;
@property (assign ,nonatomic) CHMLikeType likeType;

@end
