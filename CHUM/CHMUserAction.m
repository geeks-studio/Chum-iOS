//
//  CHMUserAction.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMUserAction.h"

@implementation CHMUserAction

+ (CHMUserAction *)actionForType:(CHMUserActionType)type {
    CHMUserAction *action = [[CHMUserAction alloc] init];
    action.type = type;

    UIImage *img;
    NSString *text;

    switch (type) {
        case CHMUserActionTypeGetChumPlus:
            img = [UIImage imageNamed:@"myGetChumPlus"];
            text = @"Получить Chum+";
            break;
        case CHMUserActionTypeShowDialogs:
            img = [UIImage imageNamed:@"myChats"];
            text = @"Мои диалоги";
            break;
        case CHMUserActionTypeShowMyPlaces:
            img = [UIImage imageNamed:@"myPlaces"];
            text = @"Мои места";
            break;
        case CHMUserActionTypeShowMyPosts:
            img = [UIImage imageNamed:@"myPosts"];
            text = @"Активные посты";
            break;
        case CHMUserActionTypeShowMySettings:
            img = [UIImage imageNamed:@"mySettings"];
            text = @"Настройки";
            break;
        case CHMUserActionTypeFeedBack:
            img = [UIImage imageNamed:@"myRate"];
            text = @"Оставить отзыв";
            break;
        case CHMUserActionTypeShareApplication:
            img = [UIImage imageNamed:@"myShare"];
            text = @"Поделиться приложением";
            break;
        case CHMUserActionTypeSuperUser:
            img = nil;
            text = @"Админ";
            break;
        case CHMUserActionTypeActivity:
            img = [UIImage imageNamed:@"activityIcon"];
            text = @"Что нового?";
            break;
        default:
            break;
    }

    action.img = img;
    action.title = text;

    return action;
}

+ (NSArray *)allActions {
    return @[
        [CHMUserAction actionForType:CHMUserActionTypeShowMyPosts],
//        [CHMUserAction actionForType:CHMUserActionTypeActivity],
        [CHMUserAction actionForType:CHMUserActionTypeShareApplication],
        [CHMUserAction actionForType:CHMUserActionTypeShowMySettings]
//        [CHMUserAction actionForType:CHMUserActionTypeSuperUser]
    ];
}

@end
