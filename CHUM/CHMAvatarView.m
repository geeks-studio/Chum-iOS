//
//  CHMAvatarView.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 02/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMAvatarView.h"

#import "CHMAvatarProvider.h"

@implementation CHMAvatarView


- (void)configureWithAvatarProvider:(CHMAvatarProvider *)provider {
    
    if(!provider) {
        return;
    }
    
    self.avatarImageView.image = provider.image;
    self.avatarImageView.backgroundColor = provider.backColor;
    
    if (provider.hasCrown) {
        self.crown.image = [UIImage imageNamed:@"crown"];
    } else {
        self.crown.image = nil;
    }
    
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


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
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
    
    self.avatarImageView.layer.cornerRadius = self.bounds.size.width /2.;
    
    self.crown.layer.cornerRadius = self.crown.frame.size.width/2.;
    self.crown.layer.masksToBounds = YES;
}


@end
