//
//  CHMDescriptionView.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 29/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMDescriptionView.h"

@implementation CHMDescriptionView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                        owner:self
                                                      options:nil] objectAtIndex:0]];
        
        self.view.frame = self.bounds;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                        owner:self
                                                      options:nil] objectAtIndex:0]];
        
        self.view.frame = self.bounds;

    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.view.frame = self.bounds;
}


@end
