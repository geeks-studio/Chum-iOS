//
//  CHMFloatButtonWorker.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMFloatButtonWorker.h"
#import "UIColor+CHMProjectsColor.h"

@import LGPlusButtonsView;

@implementation CHMFloatButtonWorker

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
    }
    return self;
}

- (void)configureFloatButton {
    if (_plusButtonsViewExample) {
        [_plusButtonsViewExample removeFromSuperview];
        _plusButtonsViewExample = nil;
    }
    NSInteger count = 2;
    if (self.canShowMessageButton) {
        count++;
    }
    if (_plusButtonsViewExample) {
        [_plusButtonsViewExample removeFromSuperview];
    }
    _plusButtonsViewExample = [LGPlusButtonsView
        plusButtonsViewWithNumberOfButtons:count
                   firstButtonIsPlusButton:NO
                             showAfterInit:NO
                             actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title,
                                             NSString *description, NSUInteger index) {
                                     [plusButtonView hideAnimated:YES completionHandler:^{
                                         
                                     }];
                             }];

    _plusButtonsViewExample.showHideOnScroll = NO;
    _plusButtonsViewExample.coverColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    _plusButtonsViewExample.position = LGPlusButtonsViewPositionTopRight;
    _plusButtonsViewExample.plusButtonAnimationType = LGPlusButtonAnimationTypeCrossDissolve;
    _plusButtonsViewExample.buttonsAppearingAnimationType =
        LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideHorizontal;

    NSMutableArray *texts = @[ @"Пожаловаться", @"Поделиться" ].mutableCopy;

    if (self.canShowMessageButton) {
        [texts addObject:@"Написать автору"];
    }
    [_plusButtonsViewExample setDescriptionsTexts:texts];
    [_plusButtonsViewExample setDescriptionsFont:[UIFont systemFontOfSize:5.f]
                                  forOrientation:LGPlusButtonsViewOrientationAll];
    NSMutableArray *icons =
        @[ [UIImage imageNamed:@"reportIconSmall"], [UIImage imageNamed:@"shareIcon"] ].mutableCopy;

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
    [_plusButtonsViewExample setButtonsOffset:CGPointMake(-5.f, 0.f)
                               forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewExample setButtonsLayerCornerRadius:36.f / 2.f
                                          forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewExample setButtonsLayerBorderColor:[UIColor colorWithWhite:0.9 alpha:1.f]];
    [_plusButtonsViewExample setButtonsTitleFont:[UIFont systemFontOfSize:24.f]
                                  forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewExample setDescriptionsTextColor:[UIColor whiteColor]];
    [_plusButtonsViewExample setDescriptionsFont:[UIFont boldSystemFontOfSize:18.f]
                                  forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewExample setDescriptionsInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 4.f)
                                    forOrientation:LGPlusButtonsViewOrientationAll];

    [self.tableView addSubview:_plusButtonsViewExample];
}

- (void)buttonAction {
    if (!_plusButtonsViewExample.isShowing) {
        [_plusButtonsViewExample showAnimated:YES completionHandler:^{}];
    } else {
        [_plusButtonsViewExample hideAnimated:YES completionHandler:^{}];
    }
}

@end
