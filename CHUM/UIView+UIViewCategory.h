//
//  UIView+UIViewCategory.h
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewCategory)

- (void)shakeView;

- (void)makeBordered;

- (void)makeBorderedWithColor:(UIColor *)color;

- (UIImage *)imageWithView;

@end
