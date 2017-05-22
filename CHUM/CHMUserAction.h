//
//  CHMUserAction.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CHMUserActionType) {
    CHMUserActionTypeShowMyPosts,
    CHMUserActionTypeShowDialogs,
    CHMUserActionTypeShowMyPlaces,
    CHMUserActionTypeShowMySettings,
    CHMUserActionTypeGetChumPlus,
    CHMUserActionTypeShareApplication,
    CHMUserActionTypeFeedBack,
    CHMUserActionTypeSuperUser,
    CHMUserActionTypeActivity
};

@interface CHMUserAction : NSObject
@property (strong, nonatomic) UIImage *img;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) CHMUserActionType type;

+ (CHMUserAction *)actionForType:(CHMUserActionType)type;

+ (NSArray *)allActions;


@end
