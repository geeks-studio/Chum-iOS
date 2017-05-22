//
//  CHMEmptyCommentCell.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "CHMBaseCell.h"

@interface CHMEmptyCommentCell : CHMBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *emptyCommentsImage;
@property (weak, nonatomic) IBOutlet UILabel *descrLabel;
@property (assign, nonatomic) BOOL commentsAllowed;




@end
