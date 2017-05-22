//
//  CHMComment.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMComment.h"

#import "CHMLikeStatus.h"
#import "CHMAvatarProvider.h"
#import "UIColor+CHMProjectsColor.h"

@implementation CHMComment

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isSended = YES;
        self.isSending = NO;
    }
    return self;
}


- (CHMLikeStatus *)likeStatus {
    if(!_likeStatus) {
        _likeStatus = [[CHMLikeStatus alloc] init];
        
        _likeStatus.likeCount = 0;
        _likeStatus.likeType = CHMLikeTypeNone;
    }
    
    return _likeStatus;
}

- (CHMAvatarProvider *)avatarProvider {
    if(!_avatarProvider) {
        _avatarProvider = [[CHMAvatarProvider alloc] init];
        _avatarProvider.image = nil;
        _avatarProvider.backColor = [UIColor lightGrayColor];
    }
    
    return _avatarProvider;
}

@end
