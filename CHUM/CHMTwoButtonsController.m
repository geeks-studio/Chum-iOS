//
//  CHMTwoButtonsController.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 13/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMTwoButtonsController.h"
#import "UIColor+CHMProjectsColor.h"

NSString *const CHMTwoButtonsControllerID = @"CHMTwoButtonsControllerID";

@interface CHMTwoButtonsController ()

@property (strong, nonatomic) UIImage *backImg;
@property (strong, nonatomic) UIImage *centralImage;
@property (strong, nonatomic) NSString *centralTitle;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSString *leftTitle;
@property (strong, nonatomic) NSString *rightTitle;
@property (assign, nonatomic) BOOL buttonsVisible;
@property (strong, nonatomic) NSString *centralButtonTitle;

@end

@implementation CHMTwoButtonsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.rightButton setBackgroundColor:[UIColor mainColor]];
    [self.centralButton setBackgroundColor:[UIColor mainColor]];

    self.leftButton.layer.borderWidth = 2.;
    self.leftButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.rightButton.layer.borderWidth = 2.;
    self.rightButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.centralButton.layer.borderWidth = 2.;
    self.centralButton.layer.borderColor = [UIColor whiteColor].CGColor;

    [self.leftButton addTarget:self
                        action:@selector(leftPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self
                         action:@selector(rightPressed:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.centralButton addTarget:self
                           action:@selector(centralButtonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];

    self.view.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self configureState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureWithCentralImage:(UIImage *)centralImg
                        backImage:(UIImage *)backImage
                            title:(NSString *)title
                         subtitle:(NSString *)subtitle
                   buttonsVisible:(BOOL)isButtonsVisible
                  leftButtonTitle:(NSString *)leftTitle
                 rightButtonTitle:(NSString *)rightTitle {
    self.centralTitle = title;
    self.subtitle = subtitle;
    self.buttonsVisible = isButtonsVisible;
    self.centralImage = centralImg;
    self.backImg = backImage;
    self.buttonsVisible = isButtonsVisible;

    self.leftTitle = leftTitle;
    self.rightTitle = rightTitle;
}

- (void)configureWithCentralImage:(UIImage *)centralImg
                        backImage:(UIImage *)backImage
                            title:(NSString *)title
                         subtitle:(NSString *)subtitle
                   buttonsVisible:(BOOL)isButtonsVisible
                  leftButtonTitle:(NSString *)leftTitle
                 rightButtonTitle:(NSString *)rightTitle
                centralButtonText:(NSString *)centralButtonText {
    self.centralButtonTitle = centralButtonText;

    [self configureWithCentralImage:centralImg
                          backImage:backImage
                              title:title
                           subtitle:subtitle
                     buttonsVisible:NO
                    leftButtonTitle:leftTitle
                   rightButtonTitle:rightTitle];
}

- (void)configureState {
    if (self.buttonsVisible) {
        [self.leftButton setTitle:self.leftTitle forState:UIControlStateNormal];
        [self.rightButton setTitle:self.rightTitle forState:UIControlStateNormal];
        self.centralButton.hidden = YES;
    } else {
        self.leftButton.hidden = YES;
        self.rightButton.hidden = YES;
        self.centralButton.hidden = NO;
        [self.centralButton setTitle:self.centralButtonTitle forState:UIControlStateNormal];
    }

    self.backImageView.image = self.backImg;
    self.centralImageView.image = self.centralImage;
    self.titleLabel.text = self.centralTitle;
    self.subtitleLabel.text = self.subtitle;
}

- (void)rightPressed:(UIButton *)button {
    if (self.buttonDelegate) {
        [self.buttonDelegate didPressRightButton:button owner:self];
    }
}

- (void)leftPressed:(UIButton *)button {
    if (self.buttonDelegate) {
        [self.buttonDelegate didPressLeftButton:button owner:self];
    }
}

- (void)centralButtonPressed:(UIButton *)central {
    if (self.buttonDelegate) {
        [self.buttonDelegate didPressCentralButton:central owner:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
