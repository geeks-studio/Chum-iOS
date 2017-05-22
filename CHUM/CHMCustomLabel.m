//
//  CHMCustomLabel.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 15/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMCustomLabel.h"

@implementation CHMCustomLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    if (self.numberOfLines == 0) {
        CGFloat boundsWidth = CGRectGetWidth(bounds);
        if (self.preferredMaxLayoutWidth != boundsWidth) {
            self.preferredMaxLayoutWidth = boundsWidth;
            [self setNeedsUpdateConstraints];
        }
    }
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    
    if (self.numberOfLines == 0) {
        // There's a bug where intrinsic content size may be 1 point too short
        size.height += 1;
    }
    
    return size;
}


@end
