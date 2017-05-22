//
//  CHMEmptyCommentCell.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMEmptyCommentCell.h"

@implementation CHMEmptyCommentCell

- (void)setCommentsAllowed:(BOOL)commentsAllowed {
    if (commentsAllowed) {
        self.emptyCommentsImage.image = [UIImage imageNamed:@"nocom"];
        self.descrLabel.text = @"Комментарии\nотсутствуют";
    } else {
        self.emptyCommentsImage.image = [UIImage imageNamed:@"commentsDisabledPlaceholder"];
        self.descrLabel.text = @"Чаму запрещено\nздесь общаться"; //Чаму запрещено\nздесь общаться
    }
}

@end
