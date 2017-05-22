//
//  CHMAddPostButton.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMAddPostButton.h"
#import "UIColor+CHMProjectsColor.h"

@implementation CHMAddPostButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        BFPaperButton *circle2 = [[BFPaperButton alloc] initWithFrame:frame raised:YES];
        
        [circle2 setImage:[UIImage imageNamed:@"createPostIcon"] forState:UIControlStateNormal];
        
//        [circle2 addTarget:self
//                    action:@selector(addPost:)
//          forControlEvents:UIControlEventTouchUpInside];
        circle2.backgroundColor = [UIColor mainColor];
        
        circle2.cornerRadius = circle2.frame.size.width / 2;
        circle2.rippleFromTapLocation = NO;
        circle2.rippleBeyondBounds = YES;
        circle2.tapCircleDiameter = MAX(circle2.frame.size.width, circle2.frame.size.height) * 1.3;
        
        self = circle2;
    }
    return self;
}

@end
