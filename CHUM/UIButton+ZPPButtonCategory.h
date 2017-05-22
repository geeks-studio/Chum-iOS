//
//  UIButton+ZPPButtonCategory.h
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZPPButtonCategory)
- (void)stopIndication;

- (void)startIndicating;

- (void)startIndicatingWithType:(UIActivityIndicatorViewStyle)style;
@end
