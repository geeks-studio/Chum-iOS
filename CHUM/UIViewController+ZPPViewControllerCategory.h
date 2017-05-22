//
//  UIViewController+ZPPViewControllerCategory.h
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZPPViewControllerCategory)

- (void)setCustomBackButton;
- (void)setCustomNavigationBackButtonWithTransition;
- (void)addCustomCloseButton;
- (void)setCustomTitleWithText:(NSString *)text;
- (void)dismisVC;

- (UITableViewCell *)parentCellForView:(id)theView;
- (NSIndexPath *)indexPathForSender:(id)sender;


- (void)showSuccessWithText:(NSString *)text;
- (void)showWarningWithText:(NSString *)message;

- (void)addPictureToNavItemWithNamePicture:(NSString *)name;

- (UIButton *)addRightButtonWithName:(NSString *)name;
- (UIButton *)addLeftButtonWithName:(NSString *)name;

- (UIButton *)buttonWithImageName:(NSString *)imgName;

- (void)showNoInternetVC;

- (void)configureNavbar;

//- (void)setTabbarVisible:(BOOL)visible;

@end
