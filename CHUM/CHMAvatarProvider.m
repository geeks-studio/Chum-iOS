//
//  CHMAvatarProvider.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMAvatarProvider.h"
#import "UIColor+CHMProjectsColor.h"


@implementation CHMAvatarProvider

+ (NSArray *)avatarsColors {
    static NSArray *colors;
    colors = @[
        [UIColor r:110 g:186 b:238],
        [UIColor r:154 g:92 b:180],
        [UIColor r:41 g:187 b:156],
        [UIColor r:228 g:126 b:48],
        [UIColor r:228 g:77 b:66],
        [UIColor r:127 g:140 b:141],
        [UIColor r:53 g:73 b:93],
        [UIColor r:48 g:173 b:99],
        [UIColor r:70 g:110 b:177],
        [UIColor r:233 g:148 b:62],
        [UIColor r:208 g:84 b:127],
        [UIColor r:141 g:72 b:171],
        [UIColor r:46 g:168 b:237],
        [UIColor r:208 g:78 b:89],
        [UIColor r:57 g:202 b:116]
    ];

    return colors;
}

+ (NSArray *)avatarImage {
    
    return @[];
}


- (UIImage *)image {
    
    if(!self.imageID) {
        return nil;
    }
    NSUInteger imgID = self.imageID.integerValue;
    NSString *imgName = [NSString stringWithFormat:@"%ld", imgID];
    
    
    return [UIImage imageNamed:imgName];
}

@end
