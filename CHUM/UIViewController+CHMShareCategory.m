//
//  UIViewController+CHMShareCategory.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMPost.h"
#import "CHMShareView.h"
#import "CHMTextHeightHelper.h"
#import "UIView+UIViewCategory.h"
#import "UIViewController+CHMShareCategory.h"

@import Crashlytics;
//#import "Answers.h"

@import Fabric;

@implementation UIViewController (CHMShareCategory)

- (void)sharePost:(CHMPost *)post withImage:(UIImage *)img {
    NSMutableArray *sharingItems = [NSMutableArray new];
    post.img = img;
    UIImage *shareImage = [self postImgWithPost:post];

    NSString *text = @"#CHUM chumapp.ru";
    [sharingItems addObject:text];

    if (shareImage) {
        [sharingItems addObject:shareImage];
    }

    [self shareImage:shareImage text:text];
    [Answers logCustomEventWithName:@"post share started" customAttributes:nil];

    //    UIActivityViewController *activityController =
    //        [[UIActivityViewController alloc] initWithActivityItems:sharingItems
    //                                          applicationActivities:nil];
    //    [self presentViewController:activityController animated:YES completion:nil];
    //
    //    activityController.completionWithItemsHandler =
    //        ^(NSString *__nullable activityType, BOOL completed, NSArray *__nullable
    //        returnedItems,
    //            NSError *__nullable activityError){
    //
    ////            [Answers logShareWithMethod:activityType
    ////                            contentName:@"Answers named #2 in Mobile Analytics"
    ////                            contentType:@"post"
    ////                              contentId:post.postId
    ////                       customAttributes:@{}];
    //
    //
    //        };
}

- (void)shareImage:(UIImage *)img text:(NSString *)text {
    NSMutableArray *sharingItems = [NSMutableArray new];
    if (text) {
        [sharingItems addObject:text];
    }
    if (img) {
        [sharingItems addObject:img];
    }

    UIActivityViewController *activityController =
        [[UIActivityViewController alloc] initWithActivityItems:sharingItems
                                          applicationActivities:nil];

    //    activityController.completionWithItemsHandler = ^(){
    //        [Answers logShareWithMethod:@"Twitter"
    //                        contentName:"text"
    //                        contentType:@"tweet"
    //                          contentId:@"601072000245858305"
    //                   customAttributes:@{}];
    //    }

    [self presentViewController:activityController
                       animated:YES
                     completion:^{

                     }];
}

- (UIImage *)postImgWithPost:(CHMPost *)post {
    CGSize s = [UIScreen mainScreen].bounds.size;

    CHMTextHeightHelper *heightHelper =
        [[CHMTextHeightHelper alloc] initWithTextWidth:s.width - 50];
    CGFloat height = [heightHelper heightOfText:post.text] + 150;

    if (post.img) {
        height += [CHMShareView imageHeight];
    }

    if (height < 180) {
        height = 180;
    }

    CGRect r = CGRectMake(0, 0, s.width, height);

    CHMShareView *v = [[CHMShareView alloc] initWithFrame:r];

    [v configureWithPost:post];
    //
    //    [self.view addSubview:v];
    //    [v setNeedsLayout];
    //    [v layoutIfNeeded];
    //
    UIImage *img = [v imageWithView];

    //    [v removeFromSuperview];
    return img;
}

- (void)shareApplication {
    UIImage *img = [UIImage imageNamed:@"appShare.jpg"];
    NSString *text = @"Присоединяйся к нам! chumapp.ru #CHUM";

    [Answers logCustomEventWithName:@"app share started" customAttributes:nil];

    [self shareImage:img text:text];
}

@end
