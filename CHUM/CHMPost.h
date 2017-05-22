//
//  CHMPost.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import MapKit;
@class CHMLikeStatus;
@class CHMPlace;


//typedef NS_ENUM(NSInteger, CHMLikeType) {
//    CHMLikeTypeNone,
//    CHMLikeTypePositive,
//    CHMLikeTypeNegative
//};


@interface CHMPost : NSObject

@property (strong, nonatomic, nonnull) NSString *postID;
@property (strong, nonatomic, nonnull) NSString *text;
@property (strong, nonatomic, nullable) NSURL *imgUrl;
@property (strong, nonatomic) UIImage *img;
@property (strong, nonatomic) CHMLikeStatus *likeStatus;

@property (assign, nonatomic) BOOL isSuper;

@property (strong, nonatomic) NSNumber *radius;

@property (strong, nonatomic) NSNumber *commentCount;
@property (strong, nonatomic) NSMutableArray *comments;//CHMComment
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL commentsIsOn;

@property (strong, nonatomic) NSNumber *distance;

@property (assign, nonatomic) float postRadius;

@property (assign, nonatomic) BOOL isOwn;

@property (strong, nonatomic) CHMPlace *place;
@property (strong, nonatomic) CHMPlace *location;


- (CHMPlace *)locationPlace;


+ (CHMPost *)emptyPost;

- (NSInteger)countOfComments;


- (NSString *)locationText;
//@property (assign, nonatomic) CHMLikeType likeType;

@end
