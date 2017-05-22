//
//  CHMLikeView.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHMPostProtocol.h"

@class CHMLikeStatus;

@interface CHMLikeView : UIView <CHMPostProtocol>

@property (nonatomic, weak) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;

- (void)configureWithLikeStatus:(CHMLikeStatus *)likeStatus;

@end
