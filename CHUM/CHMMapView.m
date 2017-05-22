//
//  CHMMapView.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 18/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMDescriptionView.h"
#import "CHMMapView.h"
#import "UIColor+CHMProjectsColor.h"
#import "CHUM-Swift.h"

@import GoogleMaps;
@import PureLayout;
static CGFloat kCHMMapCornerRadius = 10.;
static CGFloat kCHMMapOffset = 10.;
static CGFloat kCHMDescrHeight = 50;
static CGFloat kCHMSliderHeight = 60;

@interface CHMMapView () <GMSMapViewDelegate>
@property (strong, nonatomic) UILabel *rl;
@property (strong, nonatomic) UIView *onboardingView;

@end

@implementation CHMMapView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSliderView];
        [self addMapView];
        [self addRadius];
        [self bringSubviewToFront:self.slider.superview];
        //        [self addTutorialView];
    }
    return self;
}

- (void)addSliderView {
    UIView *v = [[UIView alloc] initForAutoLayout];

    v.backgroundColor = [UIColor whiteColor];
//    v.layer.cornerRadius = kCHMMapCornerRadius;
//    v.layer.masksToBounds = YES;

    UISlider *slider = [[UISlider alloc] initForAutoLayout];

    [slider setThumbImage:[UIImage imageNamed:@"sliderIcon"] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage imageNamed:@"sliderBackView"]
                        forState:UIControlStateNormal];
    slider.tintColor = [UIColor mainColor];

    slider.maximumValue = 3000;
    slider.minimumValue = 300;
    slider.value = 2000;
    self.slider = slider;
    [slider addTarget:self
                  action:@selector(sliderValueChanged:)
        forControlEvents:UIControlEventValueChanged];

    UILabel *rl = [[UILabel alloc] initForAutoLayout];
    rl.textAlignment = NSTextAlignmentCenter;
    rl.textColor = [UIColor darkMainColor];
    rl.font = [UIFont boldSystemFontOfSize:20];
    self.rl = rl;

    [self sliderValueChanged:slider];

    //    UIButton *b = self.doneButton;
    //    [b setTitle:NSLocalizedString(@"Готово", @"") forState:UIControlStateNormal];
    //
    //    CHMDescriptionView *descrView = self.descrView;
    //    CHMDescriptionView *bottom = self.bottomDescription;
    //
    //    [self addSubview:descrView];
    //    [self bringSubviewToFront:descrView];
    //
    //    [self addSubview:bottom];
    //    [self bringSubviewToFront:bottom];
    //
    //    [descrView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    //    [descrView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    //    [descrView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    //    [descrView autoSetDimension:ALDimensionHeight toSize:50];
    //
    //    [bottom autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    //    [bottom autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    //    [bottom autoPinEdgeToSuperviewEdge:ALEdgeRight];
    //    [bottom autoSetDimension:ALDimensionHeight toSize:50];

    //    [self addSubview:b];
    //    [self bringSubviewToFront:b];
    //
    //    [b autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kCHMMapOffset];
    ////    [b autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    //    [b autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:descrView withOffset:kCHMMapOffset];
    //    [b autoSetDimension:ALDimensionHeight toSize:kCHMSliderHeight];
    //    [b autoSetDimension:ALDimensionWidth toSize:kCHMSliderHeight * 2];

    [self addSubview:v];
    [self bringSubviewToFront:v];

    //    [v autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:descrView withOffset:kCHMMapOffset];

    [v autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [v autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [v autoPinEdgeToSuperviewEdge:ALEdgeBottom];

    //    [v autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:b withOffset:-kCHMMapOffset];
    [v autoSetDimension:ALDimensionHeight toSize:kCHMSliderHeight];
//    v.layer.cornerRadius = kCHMMapCornerRadius;
//    v.layer.masksToBounds = YES;

    [v addSubview:rl];

    [rl autoSetDimension:ALDimensionWidth toSize:100];
    [rl autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [rl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [rl autoPinEdgeToSuperviewEdge:ALEdgeBottom];

    [v addSubview:slider];

    [slider autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [slider autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8];
    [slider autoPinEdgeToSuperviewEdge:ALEdgeBottom];

    [slider autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:rl];
}

//- (UIButton *)doneButton {
//    if (!_doneButton) {
//        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
//        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        b.backgroundColor = [UIColor mainColor];
//        b.translatesAutoresizingMaskIntoConstraints = NO;
//        b.layer.cornerRadius = kCHMMapCornerRadius;
//        b.layer.masksToBounds = YES;
//        _doneButton = b;
//    }
//    return _doneButton;
//}

//- (CHMDescriptionView *)descrView {
//    if (!_descrView) {
//        _descrView = [[CHMDescriptionView alloc] initWithFrame:CGRectZero];
//        _descrView.translatesAutoresizingMaskIntoConstraints = NO;
//        _descrView.descrLabel.text = NSLocalizedString(@"ТЕКУЩАЯ ПОЗИЦИЯ", @"Creatio"
//                                                                                         @"n");
//    }
//    return _descrView;
//}
//
//- (CHMDescriptionView *)bottomDescription {
//    if (!_bottomDescription) {
//        _bottomDescription = [[CHMDescriptionView alloc] initWithFrame:CGRectZero];
//        _bottomDescription.translatesAutoresizingMaskIntoConstraints = NO;
//        _bottomDescription.descrLabel.text = NSLocalizedString(@"МОИ МЕСТА", @"Creation");
//    }
//    return _bottomDescription;
//}

- (void)addMapView {
    GMSCameraPosition *camera =
        [GMSCameraPosition cameraWithLatitude:55.75674918 longitude:37.60394961 zoom:10];  // redo

    self.mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView_.myLocationEnabled = YES;

    [self addSubview:self.mapView_];
    [self sendSubviewToBack:self.mapView_];

    //    [self.mapView_ autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.descrView];
    //    [self.mapView_ autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomDescription];
    //
    //    [self.mapView_ autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    //    //    [self.mapView_ autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    //    [self.mapView_ autoPinEdgeToSuperviewEdge:ALEdgeRight];

    [self.mapView_ autoPinEdgesToSuperviewEdges];

    self.mapView_.settings.tiltGestures = NO;
    self.mapView_.settings.rotateGestures = NO;
    self.mapView_.settings.scrollGestures = NO;
    self.mapView_.settings.zoomGestures = NO;
}

- (void)addRadius {
    UIImage *radiusImg = [UIImage imageNamed:@"radiusPicture"];
    UIImageView *v = [[UIImageView alloc] initWithImage:radiusImg];

    [self addSubview:v];
    [self bringSubviewToFront:v];

    [v autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self];

    [v autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [v autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];

    [v autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:v];
}

//- (void)addTutorialView {
//    static NSString *isShowedKey = @"kCHMMapTuturialShpwed";
//    BOOL showed = [[NSUserDefaults standardUserDefaults] boolForKey:isShowedKey];
//
//    if(showed) {
//        return;
//    }
//
//    [[NSUserDefaults standardUserDefaults ]setBool:YES forKey:isShowedKey];
//    UIView *v = [[UIView alloc] initForAutoLayout];
//    v.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
//    self.onboardingView = v;
//    UILabel *descrLabel = [[UILabel alloc] initForAutoLayout];
//    descrLabel.textAlignment = NSTextAlignmentCenter;
//    descrLabel.numberOfLines = 0;
//    descrLabel.textColor = [UIColor whiteColor];
//    descrLabel.font = [UIFont systemFontOfSize:22.];
//    descrLabel.adjustsFontSizeToFitWidth = YES;
//    descrLabel.minimumScaleFactor = 0.5;
//
//    //    РАЗМЕСТИ ПОСТ ДЛЯ ЛЮДЕЙ ВОКРУГ, ЗАДАВ РА
//    //    ДИУС ИЛИ ДЛЯ ПОДПИСЧИКОВ ОДНОГО ИЗ ТВОИХ МЕС
//    //    Т
//
//    descrLabel
//        .text = @"Размести пост для людей вокруг, задав радиус\u2B06, или для подписчиков одного
//        из "
//                @"твоих мест\u2B07";
//
//    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
//    [b setTitle:@"Понятно" forState:UIControlStateNormal];
//    [b addTarget:self
//                  action:@selector(removeonboardingAction:)
//        forControlEvents:UIControlEventTouchUpInside];
//    b.backgroundColor = [UIColor mainColor];
//    b.layer.cornerRadius = kCHMMapCornerRadius;
//    b.layer.masksToBounds = YES;
//
//    [self addSubview:v];
//    [v addSubview:descrLabel];
//    [v addSubview:b];
//
//    [v autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.slider withOffset:8];
//    [v autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomDescription];
//    [v autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//    [v autoPinEdgeToSuperviewEdge:ALEdgeRight];
//
//    [b autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCHMMapOffset];
//    [b autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kCHMSliderHeight * 2];
//    [b autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kCHMSliderHeight * 2];
//    [b autoSetDimension:ALDimensionHeight toSize:kCHMSliderHeight];
//
//    [descrLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
//    [descrLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kCHMSliderHeight];
//    [descrLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kCHMSliderHeight];
//    [descrLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:b withOffset:-8];
//}

- (void)removeonboardingAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5
        animations:^{
            self.onboardingView.alpha = 0.0;
        }
        completion:^(BOOL finished) {
            [self.onboardingView removeFromSuperview];
            self.onboardingView = nil;
        }];
}

- (void)sliderValueChanged:(UISlider *)sender {
    NSString *text = [NSString stringWithFormat:@"%@%@", @((NSInteger)sender.value), @"м"];
    self.rl.text = text;
}

- (CGFloat)topViewHeights {
    return kCHMDescrHeight + kCHMMapOffset + kCHMSliderHeight;
}

@end
