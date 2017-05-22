//
//  CHMEmailHelper.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 01/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CHMEmailHelper : NSObject
- (instancetype)initWithVc:(UIViewController *)vc;
@property (weak, nonatomic) UIViewController *vc;

- (void)showEmail;

@end
