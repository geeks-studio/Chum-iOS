//
//  UINavigationController+ZPPNavigationControllerCategory.h
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ZPPNavigationControllerCategory)

- (void)presentTransparentNavigationBar;
- (void)hideTransparentNavigationBar;
- (void)setCustomNavigationBackButton;

- (void)configureNavigationBarWithColor:(UIColor *)color;



@end
