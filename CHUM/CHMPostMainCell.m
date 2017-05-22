//
//  CHMPostMainCell.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMLikeView.h"
#import "CHMLocationManager.h"
#import "CHMPlace.h"
#import "CHMPost.h"
#import "CHMPostMainCell.h"
#import "DateTools.h"
#import "UIColor+CHMProjectsColor.h"

@import SDWebImage;
@import LGPlusButtonsView;
@import PureLayout;

@implementation CHMPostMainCell

- (void)awakeFromNib {
    [super awakeFromNib];

    UIView *v = [[UIView alloc] initForAutoLayout];

    v.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0];

    [self.contentView addSubview:v];
    [self.contentView sendSubviewToBack:v];
}

- (void)configureFloatButton {
    if (_plusButtonsViewExample) {
        [_plusButtonsViewExample removeFromSuperview];
        _plusButtonsViewExample = nil;
    }
    NSInteger count = 3;
    if (self.canShowMessageButton) {
        count++;
    }
    if (_plusButtonsViewExample) {
        [_plusButtonsViewExample removeFromSuperview];
    }

    _plusButtonsViewExample = [LGPlusButtonsView
        plusButtonsViewWithNumberOfButtons:count
                   firstButtonIsPlusButton:YES
                             showAfterInit:YES
                             actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title,
                                             NSString *description, NSUInteger index) {

                                 if (index != 0) {
                                     [plusButtonView hideButtonsAnimated:YES
                                                       completionHandler:^{
                                                       }];
                                 }

                             }];

    _plusButtonsViewExample.coverColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    _plusButtonsViewExample.position = LGPlusButtonsViewPositionBottomRight;
    _plusButtonsViewExample.plusButtonAnimationType = LGPlusButtonAnimationTypeCrossDissolve;
    _plusButtonsViewExample.buttonsAppearingAnimationType =
        LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideHorizontal;

    for (NSUInteger i = 1; i <= count - 1; i++) {
        [_plusButtonsViewExample setButtonAtIndex:i
                                           offset:CGPointMake(-10.f, 0.f)
                                   forOrientation:LGPlusButtonsViewOrientationAll];
    }

    NSMutableArray *texts = @[
        @"",
        @"Пожаловаться",
        @"Поделиться"
    ].mutableCopy;

    if (self.canShowMessageButton) {
        [texts addObject:@"Написать автору"];
    }

    [_plusButtonsViewExample setDescriptionsTexts:texts];
    [_plusButtonsViewExample setDescriptionsFont:[UIFont systemFontOfSize:5.f]
                                  forOrientation:LGPlusButtonsViewOrientationAll];

    NSMutableArray *icons = @[
        [UIImage imageNamed:@"pawIcon"],
        [UIImage imageNamed:@"reportIconSmall"],
        [UIImage imageNamed:@"shareIcon"]
    ].mutableCopy;

    if (self.canShowMessageButton) {
        [icons addObject:[UIImage imageNamed:@"messageSmall"]];
    }
    [_plusButtonsViewExample setButtonsImages:icons
                                     forState:UIControlStateNormal
                               forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewExample setButtonsBackgroundColor:[UIColor mainColor]
                                              forState:UIControlStateNormal];
    [_plusButtonsViewExample setButtonsSize:CGSizeMake(36.f, 35.f)
                             forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewExample setButtonsLayerCornerRadius:36.f / 2.f
                                          forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewExample
        setButtonAtIndex:0
                    size:CGSizeMake(56.f, 56.f)
          forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
                              ? LGPlusButtonsViewOrientationPortrait
                              : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewExample
         setButtonAtIndex:0
        layerCornerRadius:56.f / 2.f
           forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
                               ? LGPlusButtonsViewOrientationPortrait
                               : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewExample setButtonsLayerBorderColor:[UIColor colorWithWhite:0.9 alpha:1.f]];
    [_plusButtonsViewExample setButtonsTitleFont:[UIFont systemFontOfSize:24.f]
                                  forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewExample setButtonAtIndex:0
                                  titleOffset:CGPointMake(0.f, -2.f)
                               forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewExample setDescriptionsTextColor:[UIColor whiteColor]];
    [_plusButtonsViewExample setDescriptionsFont:[UIFont boldSystemFontOfSize:18.f]
                                  forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewExample setDescriptionsInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 4.f)
                                    forOrientation:LGPlusButtonsViewOrientationAll];

    [self.contentView addSubview:_plusButtonsViewExample];
}

- (void)configureWithPost:(CHMPost *)post {
    self.postLabel.text = post.text;
    [self.likeView configureWithPost:post];
    self.timeLabel.text = [post.date shortTimeAgoSinceNow];

    if (post.place.placeName) {
        UIColor *color = self.placeButton.currentTitleColor;
        NSDictionary *params = @{
            NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSForegroundColorAttributeName : color
        };

        NSAttributedString *str =
            [[NSAttributedString alloc] initWithString:post.place.placeName attributes:params];
        [self.placeButton setAttributedTitle:str forState:UIControlStateNormal];

    } else if (post.location.lat && post.location.lon) {
        CLLocation *curentLocation = [CHMLocationManager shared].lastCoordinate;
        CLLocation *l = [[CLLocation alloc] initWithLatitude:post.location.lat.doubleValue
                                                   longitude:post.location.lon.doubleValue];
        CLLocationDistance d = [curentLocation distanceFromLocation:l];

        NSString *placeText = @"";

        placeText = [NSString stringWithFormat:@"%.02fкм", d / 1000];

        [self.placeButton setTitle:placeText forState:UIControlStateNormal];
    }

    self.canShowMessageButton = !post.isOwn;
//    [self configureFloatButton];

    __weak typeof(self) weakSelf = self;
    if (!post.imgUrl) {
        UIImage *backImg = [UIImage imageNamed:@"shards_pattern"];
        weakSelf.mainImageView.image = backImg;
    } else {
        [[SDWebImageManager sharedManager]
            downloadImageWithURL:post.imgUrl
                         options:0
                        progress:nil
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                                   BOOL finished, NSURL *imageURL) {
                           if (image && finished && weakSelf) {
                               weakSelf.mainImageView.image = image;
                           }
                       }];
    }
}

- (void)loadMapImgWithPost:(CHMPost *)post {
    if (!post.imgUrl && [post locationPlace]) {
        CHMPlace *place = [post locationPlace];
        NSString *staticMapUrl = [NSString
            stringWithFormat:@"http://maps.google.com/maps/api/"
                             @"staticmap?markers=color:blue|%@,%@&%@&sensor=true",
                             place.lat, place.lon,
                             [NSString stringWithFormat:@"zoom=14&size=%dx%d", 2 * 255, 2 * 255]];
        NSURL *mapUrl = [NSURL
            URLWithString:[staticMapUrl
                              stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        [[SDWebImageManager sharedManager]
            downloadImageWithURL:mapUrl
                         options:0
                        progress:nil
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                                   BOOL finished, NSURL *imageURL) {
                           if (image && finished) {
                               self.mainImageView.image = image;
                           }
                       }];
    }
}

- (void)showButtons {
}

- (void)hideButtons {
}

@end
