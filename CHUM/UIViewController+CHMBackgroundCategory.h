//
//  UIViewController+CHMBackgroundCategory.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 01/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CHMBackgroundCategory)

- (void)configureBackgroundWithImageWithName:(NSString *)imgName
                                    onBottom:(BOOL)onBottom
                                    withText:(NSString *)text;

- (void)configureBackgroundWithImageWithName:(NSString *)imgName;

@end
