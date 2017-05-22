//
//  CHMCarmaCell.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMBaseCell.h"

//@class 
@class CHMUser;
@class CircleProgressBar;
@class Karma;
@interface CHMCarmaCell : CHMBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *carmaImageView;
@property (weak, nonatomic) IBOutlet UILabel *carmaLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLevelCarmaLabel;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (strong, nonatomic) UILabel *levelLabel;
@property (strong, nonatomic) UIView *levelBackView;

@property (weak, nonatomic) IBOutlet CircleProgressBar *slider;

- (void)configureWithKarma:(Karma *)karma;
- (void)configureWithRadius:(NSNumber *)distance;



@end
