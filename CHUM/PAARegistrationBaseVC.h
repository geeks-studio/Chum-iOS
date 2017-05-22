//
//  ZPPRegistrationBaseVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 18/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

//Base class for screen with keyboard
//TODO:should be rewrite with library

@interface PAARegistrationBaseVC : UIViewController

@property (weak, nonatomic) UIView *mainTF;
@property (weak, nonatomic) NSLayoutConstraint *bottomConstraint;

@end
