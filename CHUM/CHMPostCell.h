//
//  CHMPostCell.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "CHMBaseCell.h"
#import "CHMPostProtocol.h"
@class CHMLikeView;
@class CHMPost;
@interface CHMPostCell : CHMBaseCell <CHMPostProtocol>
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet CHMLikeView *likeView;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentPicture;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottomConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (assign, nonatomic) BOOL isSuper;

+ (CGFloat)imageHeight;

- (void)configureWithPost:(CHMPost *)post placeVisible:(BOOL)isPLaceVisible;

@end
