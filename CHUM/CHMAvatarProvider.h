//
//  CHMAvatarProvider.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CHMAvatarProvider : NSObject

@property (strong, nonatomic) UIColor *backColor;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSNumber *imageID;
@property (assign, nonatomic) BOOL hasCrown;

+ (NSArray *)avatarsColors;

@end
