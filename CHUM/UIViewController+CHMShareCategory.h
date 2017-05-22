//
//  UIViewController+CHMShareCategory.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHMPost;
@interface UIViewController (CHMShareCategory)

- (void)sharePost:(CHMPost *)post withImage:(UIImage *)img;

- (void)shareApplication;

@end
