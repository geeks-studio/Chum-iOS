//
//  CHMPostCreationVC.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMNavigationController.h"
#import "CHMNotificationCenter.h"
#import "CHMPost.h"
#import "CHMPostCreationVC.h"
#import "CHMPostHelper.h"
#import "CHMRulesVC.h"
#import "CHMServerBase+CHMUserLoader.h"
#import "CHUM-Swift.h"
#import "UIColor+CHMProjectsColor.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"

@import PureLayout;
@import TOCropViewController;
@import Crashlytics;

NSString *const CHMPostCreationVCID = @"CHMPostCreationVCID";

const NSInteger CHMTextLength = 200;

@interface CHMPostCreationVC () <UITextViewDelegate,
                                 UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate,
                                 TOCropViewControllerDelegate>

@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) CHMPost *post;
@property (strong, nonatomic) UISwipeGestureRecognizer *hideSGR;
@property (assign, nonatomic) PostCreationType creationType;
@property (strong, nonatomic, nullable) NSString *placeID;

@end

@implementation CHMPostCreationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomNavigationBackButtonWithTransition];
    self.mainTF = self.postTV;
    self.bottomConstraint = self.bottomCnstr;
    self.postTV.text = @"";
    self.postTV.delegate = self;
    self.hideSGR =
        [[UISwipeGestureRecognizer alloc] initWithTarget:self.postTV
                                                  action:@selector(resignFirstResponder)];
    [self.postTV addGestureRecognizer:self.hideSGR];
    self.navigationItem.titleView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"postCreationIcon"]];
    [self configureForSuperPost];
    [Answers logCustomEventWithName:@"creating_started" customAttributes:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController configureNavigationBarWithColor:[UIColor mainColor]];
    [self configureButtons];
    [self configureSettingsButtons];
    [self.postTV becomeFirstResponder];
    [CHMNotificationCenter shared].canShow = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showRules];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [CHMNotificationCenter shared].canShow = YES;
}

#pragma mark - configure

- (void)configureWithCreationType:(NSInteger)creationType placeID:(NSString *)placeID {
    self.creationType = creationType;
    self.placeID = placeID;
}

#pragma mark - actions

- (void)sendPost:(id)sender {
    if (![self checkAll]) {
        return;
    }
    switch (self.creationType) {
        case PostCreationTypePlaceDirectly:
            [self uploadPost];
            break;
        default: {
            [Answers logCustomEventWithName:@"first_stage_completed" customAttributes:nil];
            Router *router = [Router new];
            [router showSecondCreationStageWithType:self.creationType post:self.post];
            break;
        }
    }
}

- (void)uploadPost {
    self.post.place.placeID = self.placeID;
    PostUploader *pu = [[PostUploader alloc] initWithViewController:self post:self.post];
    [pu startUploading];
    [pu uploadPost];
}

- (void)showRules {
    BOOL isShowed = [[NSUserDefaults standardUserDefaults] boolForKey:CHMRulesShowedKey];

    if (!isShowed) {
        CHMRulesVC *vc = [[CHMRulesVC alloc] init];
        UIButton *b = [vc addRightButtonWithName:@"confirmIcon"];
        [b addTarget:vc action:@selector(dismisVC) forControlEvents:UIControlEventTouchUpInside];
        CHMNavigationController *nav =
            [[CHMNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)superPostAction:(UIButton *)sender {
    self.post.isSuper = !self.post.isSuper;
    if (self.post.isSuper) {
        self.superPostButton.imageView.tintColor = [UIColor projectPinkColor];
    } else {
        self.superPostButton.imageView.tintColor = [UIColor projectGray];
    }
}

- (void)photoButtonAction {
    [self.postTV resignFirstResponder];
    UIAlertController *as =
        [UIAlertController alertControllerWithTitle:@"Фото"
                                            message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Фото"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                            [self showCamera];
                                                        }];

    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Галерея"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             [self openLibrary];
                                                         }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action){
                                                         }];

    [as addAction:firstAction];
    [as addAction:secondAction];
    [as addAction:cancelAction];

    [self presentViewController:as animated:YES completion:nil];
}

- (void)showCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.barTintColor = [UIColor whiteColor];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)openLibrary {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.barTintColor = [UIColor whiteColor];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController
            didCropToImage:(UIImage *)image
                  withRect:(CGRect)cropRect
                     angle:(NSInteger)angle {
    [self configureWithImage:image];
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - photo delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 TOCropViewController *cropController =
                                     [[TOCropViewController alloc] initWithImage:chosenImage];
                                 cropController.delegate = self;

                                 cropController.defaultAspectRatio =
                                     TOCropViewControllerAspectRatio16x9;
                                 cropController.aspectRatioLocked = YES;
                                 cropController.rotateButtonsHidden = YES;
                                 [self presentViewController:cropController
                                                    animated:YES
                                                  completion:nil];
                             }];
}

- (void)configureWithImage:(UIImage *)chosenImage {
    self.post.img = chosenImage;
    self.postImageView.image = chosenImage;

    if (chosenImage) {
        self.postTV.textColor = [UIColor whiteColor];
        self.overlayView.layer.backgroundColor = [UIColor blackColor].CGColor;
    } else {
        self.overlayView.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.postTV.textColor = [UIColor blackColor];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }

    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (result.length > 200) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger count = CHMTextLength - textView.text.length;
    self.symbolCountLabel.text = [NSString stringWithFormat:@"%li", (long)count];
    self.post.text = textView.text;
    if (self.post.text.length == 0) {
        self.post.text = nil;
    }
}

#pragma mark - check

- (BOOL)checkAll {
    NSString *str = self.post.text;
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if (str.length <= 0 || [[str stringByTrimmingCharactersInSet:set] length] == 0) {
        [self showWarningWithText:NSLocalizedString(@"Ничего не написано", @"CREATION")];
        return NO;
    }
    if (str.length > CHMTextLength) {
        [self.symbolCountLabel shakeView];
        return NO;
    }
    return YES;
}

#pragma mark - ui

- (void)configureButtons {
    UIButton *right = [self addRightButtonWithName:@"confirmIcon"];
    [right addTarget:self action:@selector(sendPost:) forControlEvents:UIControlEventTouchUpInside];
    [self addCustomCloseButton];
}

- (void)configureSettingsButtons {
    self.cameraButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.superPostButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.cameraButton addTarget:self
                          action:@selector(photoButtonAction)
                forControlEvents:UIControlEventTouchUpInside];
    [self.superPostButton addTarget:self
                             action:@selector(superPostAction:)
                   forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - superpost

- (void)configureForSuperPost {  // for admins
    UIImage *superPostImage = [[UIImage imageNamed:@"superPostIcon"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.superPostButton setImage:superPostImage forState:UIControlStateNormal];
    self.superPostButton.imageView.tintColor = [UIColor projectGray];
    CHMUser *user = [CHMCurrentUserManager shared].user;
    if (user.countOfSuperPosts.integerValue > 0) {
        self.superPostButton.hidden = NO;
    } else if ([user.superUserTypeName isEqualToString:CHMUserTypeNameSuperUser]) {
        [[CHMServerBase shared] buySuperPostWithCompletion:^(NSError *error, NSInteger statusCode) {
            if (!error) {
                NSInteger count = user.countOfSuperPosts.integerValue;
                count++;
                user.countOfSuperPosts = @(count);
                self.superPostButton.hidden = NO;
            }
        }];
    }
}

#pragma mark - lazy

- (CHMPost *)post {
    if (!_post) {
        _post = [CHMPostHelper emptyPost];
        _post.commentsIsOn = YES;
        _post.isSuper = NO;
    }
    return _post;
}

- (UIView *)overlayView {
    if (!_overlayView) {
        UIView *blackOverlay = [[UIView alloc] initWithFrame:self.postImageView.frame];
        blackOverlay.layer.backgroundColor = [[UIColor clearColor] CGColor];
        blackOverlay.layer.opacity = 0.5f;
        [self.postImageView addSubview:blackOverlay];
        [blackOverlay autoPinEdgesToSuperviewEdges];
        _overlayView = blackOverlay;
    }
    return _overlayView;
}

@end
