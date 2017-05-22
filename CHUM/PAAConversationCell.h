//
//  PAAConversationCell.h
//  PartyApp
//
//  Created by Andrey Mikhaylov on 20/11/15.
//  Copyright © 2015 Alfred Zien. All rights reserved.
//

//#import "PATableViewCellFromXib.h"
#import "CHMBaseCell.h"

//@class PAAvatarView;
@class PAAConversation;
@class CHMAvatarView;
@interface PAAConversationCell : CHMBaseCell
@property (weak, nonatomic) IBOutlet CHMAvatarView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)configureWithConversation:(PAAConversation *)conversation;

@end
