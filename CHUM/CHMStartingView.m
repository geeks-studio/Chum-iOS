//
//  CHMStartingView.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 11/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMStartingView.h"
#import "UIColor+CHMProjectsColor.h"
@import DGActivityIndicatorView;
@import PureLayout;
@implementation CHMStartingView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                        owner:self
                                                      options:nil] objectAtIndex:0]];
        
        self.view.frame = self.bounds;
        
        [self configureLoader];
        
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                        owner:self
                                                      options:nil] objectAtIndex:0]];
        
        self.view.frame = self.bounds;
    }
    return self;
}

- (void)configureLoader {
    self.activityIndicatorView = [[DGActivityIndicatorView alloc]
                                  initWithType:DGActivityIndicatorAnimationTypeBallScaleRipple
                                  tintColor:[UIColor whiteColor]
                                  size:35.0f];
    self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.activityIndicatorView.frame = CGRectMake(0.0f, 0.0f, 60.0f, 60.0f);
    //    self.acti
    
    [self.view addSubview:self.activityIndicatorView];
    
    //    [self.activityIndicatorView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
    [self.activityIndicatorView autoSetDimension:ALDimensionHeight toSize:50];
    [self.activityIndicatorView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:16];
    [self.activityIndicatorView autoMatchDimension:ALDimensionHeight
                                       toDimension:ALDimensionWidth
                                            ofView:self.activityIndicatorView];
    [self.activityIndicatorView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [self.activityIndicatorView startAnimating];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.view.frame = self.bounds;
    
    self.reloadButton.layer.cornerRadius = self.reloadButton.frame.size.height/2.;
    self.reloadButton.layer.masksToBounds = YES;
    self.reloadButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.reloadButton.layer.borderWidth = 2.;
    
}


- (void)setLoading:(BOOL)loading {
    self.reloadButton.hidden = loading;
    self.activityIndicatorView.hidden = !loading;
    
    if(loading) {
        [self.activityIndicatorView startAnimating];
    } else {
        [self.activityIndicatorView stopAnimating];
    }
}




@end
