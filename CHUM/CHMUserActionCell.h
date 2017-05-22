//
//  CHMUserActionCell.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMBaseCell.h"

@class CHMUserAction;

@interface CHMUserActionCell : CHMBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)configureWithAction:(CHMUserAction *)action;
- (void)configureWithText:(NSString *)text;

@end
