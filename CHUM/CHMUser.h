//
//  CHMUser.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CHMUserTypeNameSuperUser;
extern NSString *const CHMUserTypeNameModerator;

@class VoxUser;
@class Karma;

@interface CHMUser : NSObject

//@property (strong, nonatomic) NSNumber *likeCount;
@property (strong, nonatomic, nullable) NSNumber *maxMeterCount;
//@property (strong, nonatomic) NSNumber *level;
//@property (strong, nonatomic) NSNumber *progress;
//@property (strong, nonatomic) NSNumber *likeToNextLevel;
@property (strong, nonatomic) NSNumber *countOfSuperPosts;
@property (assign, nonatomic) BOOL isBanned;
@property (strong, nonatomic) NSString *superUserTypeName;
@property (strong, nonatomic) VoxUser *voxUser;

@property (strong, nonatomic) Karma *karma;


@end
