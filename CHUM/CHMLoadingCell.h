//
//  CHMLoadingCell.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 10/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMBaseCell.h"
@class DGActivityIndicatorView;
@interface CHMLoadingCell : CHMBaseCell

@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (strong, nonatomic) DGActivityIndicatorView *activityIndicatorView;


- (void)setLoading:(BOOL)loading;

@end
