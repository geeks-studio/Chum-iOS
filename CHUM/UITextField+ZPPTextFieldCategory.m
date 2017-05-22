//
//  UITextField+ZPPTextFieldCategory.m
//  ZP
//
//  Created by Andrey Mikhaylov on 05/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "UITextField+ZPPTextFieldCategory.h"

@implementation UITextField (ZPPTextFieldCategory)

- (void)addLeftInset {
    UITextField *textField = self;
    UIView *leftView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textField.frame.size.height)];
    leftView.backgroundColor = textField.backgroundColor;
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

@end
