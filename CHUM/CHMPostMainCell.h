//
//  CHMPostMainCell.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMBaseCell.h"
#import "CHMPostProtocol.h"
@class CHMLikeView;
@class LGPlusButtonsView;
@interface CHMPostMainCell : CHMBaseCell <CHMPostProtocol>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *placeButton;
@property (weak, nonatomic) IBOutlet CHMLikeView *likeView;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;


//@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewExample;

@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *showMapButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (assign, nonatomic) BOOL canShowMessageButton;


- (void)showButtons;
- (void)hideButtons;

@end
