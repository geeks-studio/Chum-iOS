//
//  CHMTwoButtonsController.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 13/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHMTwoButtonsController;

@protocol CHMTwoButtonProtocol <NSObject>

- (void)didPressLeftButton:(UIButton *)button owner:(CHMTwoButtonsController *)owner;
- (void)didPressRightButton:(UIButton *)button owner:(CHMTwoButtonsController *)owner;
- (void)didPressCentralButton:(UIButton *)button owner:(CHMTwoButtonsController *)owner;

@end

extern NSString *const CHMTwoButtonsControllerID;

@interface CHMTwoButtonsController : UIViewController

@property (weak, nonatomic) id<CHMTwoButtonProtocol>buttonDelegate;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *centralButton;

@property (weak, nonatomic) IBOutlet UIImageView *centralImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;


- (void)configureWithCentralImage:(UIImage *)centralImg
                        backImage:(UIImage *)backImage
                            title:(NSString *)title
                         subtitle:(NSString *)subtitle
                   buttonsVisible:(BOOL)isButtonsVisible
                  leftButtonTitle:(NSString *)leftTitle
                 rightButtonTitle:(NSString *)rightTitle;

- (void)configureWithCentralImage:(UIImage *)centralImg
                        backImage:(UIImage *)backImage
                            title:(NSString *)title
                         subtitle:(NSString *)subtitle
                   buttonsVisible:(BOOL)isButtonsVisible
                  leftButtonTitle:(NSString *)leftTitle
                 rightButtonTitle:(NSString *)rightTitle
                centralButtonText:(NSString *)centralButtonText;

@end
