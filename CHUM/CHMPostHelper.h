//
//  CHMPostHelper.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHMPost;
@class CHMComment;
@class CHMUser;
@class CHMAvatarProvider;
@class CHMSettings;
@class VoxUser;
@class Karma;
@interface CHMPostHelper : NSObject

+ (NSArray *)parsePostsDicts:(NSArray *)postsDicts;
+ (NSMutableArray *)parseComments:(NSArray *)dicts;
+ (NSArray *)parsePlaces:(NSArray *)placesDicts;
+ (NSArray *)parseTypes:(NSArray *)typesDicts;
+ (CHMPost *)parsePost:(NSDictionary *)postDict;
+ (NSMutableDictionary *)dictionaryFromPost:(CHMPost *)post;
+ (CHMComment *)parseComment:(NSDictionary *)commentDict;
+ (CHMAvatarProvider *)avatarFromDict:(NSDictionary *)dict;
+ (CHMPost *)emptyPost;
+ (CHMUser *)parseUser:(NSDictionary *)userDict;
+ (VoxUser *)parseVoxUser:(NSDictionary *)voxDict;
+ (CHMSettings *)parseSettings:(NSDictionary *)dict;

+ (Karma *)parseKarma:(NSDictionary *)karmaDict;

@end
