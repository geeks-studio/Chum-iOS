//
//  CHMBaseCell.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "MGSwipeTableCell.h"

@interface CHMBaseCell : MGSwipeTableCell

+ (UINib *)nib;
+ (NSString *)identifier;

@end
