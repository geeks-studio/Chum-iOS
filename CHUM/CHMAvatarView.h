//
//  CHMAvatarView.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 02/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHMAvatarProvider;

@interface CHMAvatarView : UIView
@property (nonatomic, weak) IBOutlet UIView *view;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *crown;

- (void)configureWithAvatarProvider:(CHMAvatarProvider *)provider;



@end
