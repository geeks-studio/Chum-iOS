//
//  CHMStartingView.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 11/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DGActivityIndicatorView;
@interface CHMStartingView : UIView

@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UIButton *reloadButton;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;

- (void)setLoading:(BOOL)loading;

@end
