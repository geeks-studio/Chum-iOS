//
//  UIColor+CHMProjectsColor.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CHMProjectsColor)

+ (UIColor *)mainColor;
+ (UIColor *)darkMainColor;
+ (UIColor *)projectGray;
+ (UIColor *)projectPinkColor;
+ (UIColor *)veryLightGrayColor;
+ (UIColor *)projectRed;
+ (UIColor *)lightBackgroundColor;
+ (UIColor *)superPostColor;
+ (UIColor *)checkboxColor;
+ (UIColor *)lightLinkColor;

+ (UIColor *)r:(NSInteger)r g:(NSInteger)g b:(NSInteger)b;

+ (UIColor *)colorForText:(NSString *)text;

@end
