//
//  UIViewController+ZPPViewControllerCategory.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "MBProgressHUD.h"

#import "CHMShareView.h"
#import "UIColor+CHMProjectsColor.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "VBFPopFlatButton.h"
@import JDStatusBarNotification;

@implementation UIViewController (ZPPViewControllerCategory)

- (void)setCustomBackButton {
    UIButton *backButton = [self buttonWithImageName:@"back"];
    [backButton addTarget:self
                   action:@selector(popBack)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)setCustomNavigationBackButtonWithTransition {
    UIBarButtonItem *backButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStylePlain
                                        target:nil
                                        action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];

    UIImage *back = [UIImage imageNamed:@"back"];
    [self.navigationController.navigationBar
        setBackIndicatorImage:back];
    [self.navigationController.navigationBar
        setBackIndicatorTransitionMaskImage:back];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)addPictureToNavItemWithNamePicture:(NSString *)name {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
}

- (void)setCustomTitleWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addCustomCloseButton {
    UIButton *closeButton = [self buttonWithImageName:@"cancelCross"];
    [closeButton addTarget:self
                    action:@selector(dismisVC)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = closeButtonItem;
}

- (UIButton *)addRightButtonWithName:(NSString *)name {
    UIButton *closeButton = [self buttonWithImageName:name];

    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem = closeButtonItem;

    return closeButton;
}

- (UIButton *)addLeftButtonWithName:(NSString *)name {
    UIButton *closeButton = [self buttonWithImageName:name];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = closeButtonItem;

    return closeButton;
}

//- (UIBarButtonItem *)barButtonWithName:(NSString *)imageName {
//    UIButton *button = [self buttonWithImageName:name];
//    
//}

- (void)dismisVC {
    [self dismissViewControllerAnimated:YES
                             completion:^{

                             }];
}



- (UIButton *)buttonWithImageName:(NSString *)imgName {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25.0f, 25.0f)];
    backButton.tintColor = [UIColor whiteColor];
    UIImage *backImage =
        [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];

    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    return backButton;
}

- (UITableViewCell *)parentCellForView:(id)theView {
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
        if ([viewSuperView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)viewSuperView;
        } else {
            viewSuperView = [viewSuperView superview];
        }
    }
    return nil;
}

- (NSIndexPath *)indexPathForSender:(id)sender {
    UITableViewCell *cell = [self parentCellForView:sender];

    if (cell) {
        if ([self respondsToSelector:@selector(tableView)]) {
            id anotherSelf = self;
            return [[anotherSelf tableView] indexPathForCell:cell];
        } else {
            return nil;
        }
    }
    return nil;
}

- (void)showWarningWithText:(NSString *)message {
    [JDStatusBarNotification showWithStatus:message
                               dismissAfter:2.0
                                  styleName:JDStatusBarStyleError];
}

- (void)showSuccessWithText:(NSString *)text {
    VBFPopFlatButton *button = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)
                                                            buttonType:buttonOkType
                                                           buttonStyle:buttonPlainStyle
                                                 animateToInitialState:YES];

    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.customView = button;
    hud.labelText = text;
    hud.mode = MBProgressHUDModeCustomView;
    [hud show:YES];
    [hud hide:YES afterDelay:2];
}

- (void)configureNavbar {
    [self.navigationController.navigationBar
        setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor mainColor];
    self.navigationController.navigationBar.translucent = NO;

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)showNoInternetVC {
    [self showWarningWithText:NSLocalizedString(@"Что-то пошло не так", @"general")];
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url {
    NSMutableArray *sharingItems = [NSMutableArray new];
    if (text) {
        [sharingItems addObject:text];
    }

    image = [self generateImageWithText:text image:image];
    if (image) {
        [sharingItems addObject:image];
    }

    UIActivityViewController *activityController =
        [[UIActivityViewController alloc] initWithActivityItems:sharingItems
                                          applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (UIImage *)generateImageWithText:(NSString *)text image:(UIImage *)img {
    CGSize s = [UIScreen mainScreen].bounds.size;
    CGRect r = CGRectMake(0, 0, s.width, 200.f);
    CHMShareView *v = [[CHMShareView alloc] initWithFrame:r];
    img = [[self class] imageWithView:v];
    return img;
}

+ (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

- (void)setTabbarVisible:(BOOL)visible {
    [self setTabBarVisible:visible animated:YES completion:nil];
}

- (void)setTabBarVisible:(BOOL)visible
                animated:(BOOL)animated
              completion:(void (^)(BOOL))completion {
    if ([self tabBarIsVisible] == visible) {
        return (completion) ? completion(YES) : nil;
    }

    // get a frame calculation ready
    CGFloat height = 49.0;  // self.tabBarController.tabBar.frame.size.height;
    CGFloat offsetY = (visible) ? -height : height;

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect r = CGRectMake(0, screenSize.height + offsetY, screenSize.width, height);
    // zero duration means no animation
    CGFloat duration = (animated) ? 0.3 : 0.0;

    [UIView animateWithDuration:duration
                     animations:^{
                         //        CGRect frame = self.tabBarController.tabBar.frame;
                         self.tabBarController.tabBar.frame = r;
                     }
                     completion:completion];
}

- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

@end
