//
//  ZPPRegistrationBaseVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 18/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "PAARegistrationBaseVC.h"
#import "CHMServerBase+PostLoader.h"
#import "CHMPost.h"
#import "CHMPostHelper.h"

@interface PAARegistrationBaseVC ()
@property (assign, nonatomic) CGFloat maxHeight;
@end
@implementation PAARegistrationBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)keyboardWillChange:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];  // this is it!
    [self animateTo:keyboardRect.size.height];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self animateTo:kbSize.height];
}

- (void)animateTo:(CGFloat )height {
        
    if(height > self.maxHeight) {
        self.maxHeight = height;
    }
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.bottomConstraint.constant = self.maxHeight;
                         [self.mainTF.superview layoutIfNeeded];
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    self.maxHeight = 0;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.bottomConstraint.constant = 0;
                         [self.view layoutIfNeeded];
                     }];
}

- (void)dismissKeyboard {
    [self.mainTF.superview resignFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
