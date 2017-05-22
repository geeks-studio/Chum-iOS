//
//  CHMPostHelper.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMAvatarProvider.h"
#import "CHMComment.h"
#import "CHMCurrentUserManager.h"
#import "CHMLikeStatus.h"
#import "CHMLocationManager.h"
#import "CHMPlace.h"
#import "CHMPost.h"
#import "CHMPostHelper.h"
#import "CHMSettings.h"
#import "CHMUser.h"
#import "LoremIpsum.h"
#import "NSDate+ZPPDateCategory.h"
#import "CHUM-Swift.h"

@import Colours;

@implementation CHMPostHelper

+ (NSArray *)parsePostsDicts:(NSArray *)postsDicts {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSDictionary *d in postsDicts) {
        CHMPost *p = [[self class] parsePost:d];

        [tmp addObject:p];
    }

    NSArray *arr = [NSArray arrayWithArray:tmp];

    return arr;
}

+ (CHMPost *)parsePost:(NSDictionary *)postDict {
    NSNumber *commentsCount = postDict[@"comments_count"];
    NSString *text = postDict[@"text"];
    NSString *postID = postDict[@"post_id"];

    NSNumber *commentsIsOn = postDict[@"comments_is_on"];

    CHMPost *p = [[CHMPost alloc] init];

    p.text = text;
    p.postID = postID;
    p.commentCount = commentsCount;
    p.date = [NSDate customDateFromString:postDict[@"time"]];

    p.likeStatus = [[self class] likeStatusWithDict:postDict];
    p.place = [[self class] parsePlace:postDict[@"theme"]];
    p.location = [[self class] parseLocation:postDict[@"location"]];

    p.distance =
        [[CHMLocationManager shared] calulateDistanceToLat:p.location.lat lon:p.location.lon];

    if (commentsIsOn && ![commentsIsOn isEqual:[NSNull null]]) {
        p.commentsIsOn = commentsIsOn.boolValue;
    }

    NSNumber *isOwn = postDict[@"own_post"];

    if (isOwn && [isOwn isKindOfClass:[NSNumber class]]) {
        p.isOwn = isOwn.boolValue;
    }

    //    NSArray *comments = postDict[@"comments"];
    //    p.comments = [[self class] parseComments:comments];

    NSString *imgUrlAsString = postDict[@"image"];
    //    NSURL *imgURL = nil;
    if (imgUrlAsString && ![imgUrlAsString isEqual:[NSNull null]]) {
        p.imgUrl = [NSURL URLWithString:imgUrlAsString];
    }
    NSNumber *isSuper = postDict[@"is_super"];
    if (isSuper && ![isSuper isEqual:[NSNull null]]) {
        p.isSuper = isSuper.boolValue;
    }
    return p;
}

+ (CHMLikeStatus *)likeStatusWithDict:(NSDictionary *)likeStatusDict {
    CHMLikeStatus *likeStatus = [[CHMLikeStatus alloc] init];

    NSNumber *likeCount = likeStatusDict[@"likes"];
    if (likeCount && ![likeCount isEqual:[NSNull null]] &&
        [likeCount isKindOfClass:[NSNumber class]]) {
        likeStatus.likeCount = likeCount.integerValue;
    }

    NSNumber *likeStatusNum = likeStatusDict[@"how_liked"];

    if ([likeStatusNum isEqual:@(1)]) {
        likeStatus.likeType = CHMLikeTypePositive;
    } else if ([likeStatusNum isEqual:@(-1)]) {
        likeStatus.likeType = CHMLikeTypeNegative;
    } else {
        likeStatus.likeType = CHMLikeTypeNone;
    }

    return likeStatus;
}

+ (NSMutableDictionary *)dictionaryFromPost:(CHMPost *)post {
    if (!post.text) {
        return nil;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"text"] = post.text;

    if (post.img) {
        dict[@"image"] = [[self class] encodeToBase64String:post.img];
    }

    //WTF?
    if (post.commentsIsOn) {
        dict[@"comments_is_on"] = @(YES);
    } else {
        dict[@"comments_is_on"] = @(NO);
    }

    dict[@"is_super"] = @(post.isSuper);

    if (post.radius) {
        dict[@"radius"] = post.radius;
    }
    if (post.place.placeID) {
        dict[@"theme_id"] = post.place.placeID;

    } else if (post.location.lat && post.location.lon) {
        NSDictionary *latLon = @{ @"lat" : post.location.lat, @"lon" : post.location.lon };
        dict[@"location"] = latLon;
    }

    return dict;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//+ (UIImage *)cropedImgOfImg:(UIImage *)original {
//    UIImage *ret = nil;
//
//    // This calculates the crop area.
//
//    float originalWidth = original.size.width;
//    float originalHeight = original.size.height;
//
//    float edge = fminf(originalWidth, originalHeight);
//
//    float posX = (originalWidth - edge) / 2.0f;
//    float posY = (originalHeight - edge) / 2.0f;
//
//    CGRect cropSquare = CGRectMake(posX, posY, edge, edge);
//
//    if (original.imageOrientation == UIImageOrientationLeft ||
//        original.imageOrientation == UIImageOrientationRight) {
//        cropSquare = CGRectMake(posY, posX, edge, edge);
//
//    } else {
//        cropSquare = CGRectMake(posX, posY, edge, edge);
//    }
//
//    // This performs the image cropping.
//
//    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], cropSquare);
//
//    ret = [UIImage imageWithCGImage:imageRef
//                              scale:original.scale
//                        orientation:original.imageOrientation];
//
//    CGImageRelease(imageRef);
//
//    return ret;
//}

+ (NSString *)encodeToBase64String:(UIImage *)image {
    UIImage *newImage =
        [[self class] imageWithImage:image scaledToSize:CGSizeMake(300 * 16. / 9., 300)];
    return [UIImageJPEGRepresentation(newImage, 0.9)
        base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

//+ (NSArray *)testPosts {
//    NSMutableArray *tmp = [NSMutableArray array];
//
//    for (int i = 0; i < 100; i++) {
//        CHMPost *p = [[self class] randomPost];
//        [tmp addObject:p];
//    }
//    return [NSArray arrayWithArray:tmp];
//}

//+ (CHMPost *)randomPost {
//    CHMPost *p = [[CHMPost alloc] init];
//    p.text = [LoremIpsum wordsWithNumber:1 + arc4random() % 100];
//    p.date = [LoremIpsum date];
//    for (int i = 0; i < arc4random() % 100; i++) {
//        CHMComment *c = [[self class] randomComment];
//
//        [p.comments addObject:c];
//    }
//
//    p.likeStatus = [[self class] randomLikeStatus];
//
//    return p;
//}

+ (CHMLikeStatus *)likeStatusWithType:(CHMLikeType)type likeCount:(NSInteger)likeCount {
    CHMLikeStatus *ls = [[CHMLikeStatus alloc] init];

    ls.likeType = type;
    ls.likeCount = likeCount;

    return ls;
}

//+ (CHMLikeStatus *)randomLikeStatus {
//    return
//        [[self class] likeStatusWithType:arc4random() % 3 likeCount:(int)arc4random() % 100 - 50];
//}

+ (NSMutableArray *)parseComments:(NSArray *)dicts {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSDictionary *d in dicts) {
        CHMComment *comment = [[self class] parseComment:d];

        [tmp addObject:comment];
    }
    return tmp;
}

#pragma mark - comments

+ (CHMComment *)parseComment:(NSDictionary *)commentDict {
    CHMLikeStatus *likeStatus = [[self class] likeStatusWithDict:commentDict];

    CHMComment *comment = [[CHMComment alloc] init];
    comment.likeStatus = likeStatus;
    comment.commentText = commentDict[@"text"];
    comment.commentID = commentDict[@"comment_id"];
    comment.date = [NSDate customDateFromString:commentDict[@"time"]];
    comment.avatarProvider = [[self class] avatarFromDict:commentDict[@"avatar"]];
    comment.isSended = YES;
    comment.isSending = NO;

    NSNumber *isOwn = commentDict[@"own_comment"];
    if (isOwn && [isOwn isKindOfClass:[NSNumber class]]) {
        comment.isOwn = isOwn.boolValue;
    }

    NSDictionary *replyTo = commentDict[@"replay_to"];
    if (replyTo && ![replyTo isEqual:[NSNull null]]) {
        NSDictionary *replyToAvatarDict = replyTo[@"avatar"];
        comment.replyAvatarProvider = [[self class] avatarFromDict:replyToAvatarDict];
    }

    return comment;
}

#pragma mark - places

+ (NSArray *)parseTypes:(NSArray *)typesDicts {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSString *name in typesDicts) {
        PlaceType *type = [[PlaceType alloc] initWithPlaceType:name];
        [tmp addObject:type];
    }
    return [NSArray arrayWithArray:tmp];
}


+ (NSArray *)parsePlaces:(NSArray *)placesDicts {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSDictionary *d in placesDicts) {
        CHMPlace *place = [[self class] parsePlace:d];
        [tmp addObject:place];
    }

    return [NSArray arrayWithArray:tmp];
}

+ (CHMPlace *)parseLocation:(NSDictionary *)dict {
    CHMPlace *place = [[CHMPlace alloc] init];

    place.lat = dict[@"lat"];
    place.lon = dict[@"lon"];

    return place;
}

+ (CHMPlace *)parsePlace:(NSDictionary *)dict {
    CHMPlace *place = [[CHMPlace alloc] init];

    place.placeID = dict[@"theme_id"];
    place.placeName = dict[@"name"];

    place.city = dict[@"city"];

    NSNumber *isAdded = dict[@"is_added"];

    if (isAdded && ![isAdded isEqual:[NSNull null]]) {
        place.isChoosed = isAdded.boolValue;
    }

    NSString *placeStringUrl = dict[@"image"];

    if (placeStringUrl && ![placeStringUrl isEqual:[NSNull null]]) {
        place.placeURL = [NSURL URLWithString:placeStringUrl];
    }
    
    NSArray *placeTags = dict[@"tags"];
    if (placeTags && ![placeTags isEqual:[NSNull null]]) {
        NSMutableArray *tmp = [NSMutableArray array];
        for (NSString *tag in placeTags) {
            [tmp addObject:tag];
        }
        place.tags = [NSArray arrayWithArray:tmp];
    }
    
    
    return place;
}

#pragma mark - avatar

+ (CHMAvatarProvider *)avatarFromDict:(NSDictionary *)dict {
    //    color = "#E9943E";
    //    "image_id" = 5;

    UIColor *color = [UIColor colorFromHexString:dict[@"color"]];
    NSNumber *imgID = dict[@"image_id"];
    NSNumber *hasCrown = dict[@"crown"];

    CHMAvatarProvider *ap = [[CHMAvatarProvider alloc] init];
    ap.backColor = color;
    ap.imageID = imgID;
    ap.hasCrown = hasCrown.boolValue;
    
//    dis
//    CHMAvatarImageGenerator *imgGenerator =
//    [[CHMAvatarImageGenerator alloc] initWithAvatarProvider:ap];
//    
//    UIImage *img = [imgGenerator imageWithHeight:17.];
//    ap.image = img;   

    return ap;
}

#pragma mark - empty post

+ (CHMPost *)emptyPost {
    CHMPost *post = [[CHMPost alloc] init];
    //    post.place = [[CHMPlace alloc] init];
    post.likeStatus = [[CHMLikeStatus alloc] init];

    return post;
}

#pragma mark - user

+ (CHMUser *)parseUser:(NSDictionary *)userDict {
    CHMUser *user = [[CHMUser alloc] init];

    user.maxMeterCount = userDict[@"radius"];
    user.karma = [[self class] parseKarma:userDict];

    user.superUserTypeName = userDict[@"user_type"];
    user.countOfSuperPosts = userDict[@"available_super_post_count"];

    NSNumber *isBanned = userDict[@"is_banned"];
    if (isBanned && ![isBanned isKindOfClass:[NSNumber class]]) {
        user.isBanned = isBanned.boolValue;
    }
    
    NSDictionary *voxDict = userDict[@"vox"];
    user.voxUser = [[self class] parseVoxUser:voxDict];

    return user;
}

+ (Karma *)parseKarma:(NSDictionary *)karmaDict {
    NSNumber *likeCount = karmaDict[@"karma"];
    NSNumber *progress = karmaDict[@"progress"];
    NSNumber *level = karmaDict[@"level"];
    NSNumber *likeToNextLevel = karmaDict[@"karma_for_next_levelup"];
    
    Karma *karma = [[Karma alloc] initWithLevel:level.integerValue likeCount:likeCount.integerValue progress:progress.integerValue likeToNextLevel:likeToNextLevel.integerValue];
    
    return karma;
}

+ (VoxUser *)parseVoxUser:(NSDictionary *)voxDict {
    NSString *login = voxDict[@"user_name"];
    NSString *password = voxDict[@"user_password"];
    
    if (login && password && ![login isEqual:[NSNull null]] && ![password isEqual:[NSNull null]]) {
        VoxUser *user = [[VoxUser alloc] initWithLogin:login password:password];
        return user;
    } else {
        return nil;
    }
}

#pragma mark - settings

+ (CHMSettings *)parseSettings:(NSDictionary *)dict {
    CHMSettings *settings = [[CHMSettings alloc] init];

    NSNumber *messages = dict[@"message"];
    NSNumber *comment = dict[@"comment"];
    NSNumber *levels = dict[@"level"];

    settings.messagePush = [CHMPostHelper parseBool:messages default:YES];
    settings.commentsPush = [CHMPostHelper parseBool:comment default:YES];
    settings.levelsPush = [CHMPostHelper parseBool:levels default:YES];

    return settings;
}
+ (BOOL)parseBool:(NSNumber *)num default:(BOOL)def {
    if (num && ![num isEqual:[NSNull null]] && [num isKindOfClass:[NSNumber class]]) {
        return num.boolValue;
    }
    return def;
}

@end
