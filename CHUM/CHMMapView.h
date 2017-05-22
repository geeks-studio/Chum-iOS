//
//  CHMMapView.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 18/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMSMapView;
@class CHMDescriptionView;
@interface CHMMapView : UIView

@property (strong, nonatomic) GMSMapView *mapView_;
@property (strong, nonatomic) UISlider *slider;

//@property (strong, nonatomic) UIButton *doneButton;

//@property (strong, nonatomic) CHMDescriptionView *descrView;
//@property (strong, nonatomic) CHMDescriptionView *bottomDescription;

- (CGFloat)topViewHeights;
@end
