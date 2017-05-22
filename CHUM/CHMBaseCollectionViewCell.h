//
//  CHMBaseCollectionViewCell.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHMBaseCollectionViewCell : UICollectionViewCell

+ (UINib *)nib;
+ (NSString *)identifier;

@end
