//
//  UITableViewController+ZPPTVCCategory.h
//  ZP
//
//  Created by Andrey Mikhaylov on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewController (ZPPTVCCategory)

- (void)configureBackgroundWithImageWithName:(NSString *)imgName;

- (void)configureBackgroundWithImageWithName:(NSString *)imgName
                                    onBottom:(BOOL)onBottom
                                    withText:(NSString *)text;

- (void)registrateCellForClass:(Class)cls reuseIdentifier:(NSString *)reuseIdentifier;

- (void)registrateCellForClass:(Class)cls;

@end
