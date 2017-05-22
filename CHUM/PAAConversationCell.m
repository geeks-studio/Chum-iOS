//
//  PAAConversationCell.m
//  PartyApp
//
//  Created by Andrey Mikhaylov on 20/11/15.
//  Copyright © 2015 Alfred Zien. All rights reserved.
//

//#import <DateTools.h>
#import <JSBadgeView/JSBadgeView.h>
#import "CHMAvatarProvider.h"
#import "CHMAvatarView.h"
#import "PAAConversation.h"
#import "PAAConversationCell.h"
#import "PAAMessage.h"
#import "UIColor+CHMProjectsColor.h"

@import DateTools;

@interface PAAConversationCell ()

@property (strong, nonatomic) JSBadgeView *badgeView;

@end

@implementation PAAConversationCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    self.badgeView =
        [[JSBadgeView alloc] initWithParentView:self.avatar alignment:JSBadgeViewAlignmentTopRight];
    self.badgeView.badgeBackgroundColor = [UIColor mainColor];
    self.badgeView.badgePositionAdjustment = CGPointMake(-10, 10);
}

- (void)configureWithConversation:(PAAConversation *)conversation {
    PAAMessage *m = conversation.lastMessage;

    NSString *messageText = m.text;
    if (m.isOwn) {
        messageText = [@"You: " stringByAppendingString:messageText];
    }
    self.firstMessageLabel.text = messageText;
    self.timeLabel.text = [[m date] shortTimeAgoSinceNow];

    if(conversation.isBlocked) {
        self.badgeView.badgeText =
        [NSString stringWithFormat:@"%@", @"X"];
        self.badgeView.badgeBackgroundColor = [UIColor redColor];
    } else if ([conversation unreadedCount] > 0) {
        self.badgeView.badgeText =
            [NSString stringWithFormat:@"%@", @([conversation unreadedCount])];
        self.badgeView.badgeBackgroundColor = [UIColor mainColor];
    } else {
        self.badgeView.badgeText = nil;
    }

    [self.avatar configureWithAvatarProvider:conversation.avatar];

    double hoursUntilDeath = [conversation.deathDate hoursLaterThan:[NSDate new]];
    CGFloat alpha = hoursUntilDeath / 24.;

    self.contentView.alpha = 0.3 + 0.7 * (alpha);
}

@end
