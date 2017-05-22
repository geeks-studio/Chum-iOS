//
//  CHMShareView.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHMPostProtocol.h"
@class CHMLikeView;
@interface CHMShareView : UIView <CHMPostProtocol>

@property (nonatomic, weak) IBOutlet UIView *view;


@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet CHMLikeView *likeView;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentPicture;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@property (nonatomic, weak) IBOutlet UIView *backView;

+ (CGFloat)imageHeight;

@end
