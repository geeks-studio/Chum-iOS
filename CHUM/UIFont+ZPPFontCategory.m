//
//  UIFont+ZPPFontCategory.m
//  ZP
//
//  Created by Andrey Mikhaylov on 04/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "UIFont+ZPPFontCategory.h"

@implementation UIFont (ZPPFontCategory)

+ (UIFont *)fontOfSize:(CGFloat)fontSize {
    return [[self class] systemFontOfSize:fontSize];
}

+ (UIFont *)boldFontOfSize:(CGFloat)fontSize {
    return [[self class] boldSystemFontOfSize:fontSize];
}

@end
