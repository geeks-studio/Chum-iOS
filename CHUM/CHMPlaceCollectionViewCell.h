//
//  CHMPlaceCollectionViewCell.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 04/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//
#import "CHMBaseCollectionViewCell.h"
@class CHMPlace;
@class PlaceType;
@interface CHMPlaceCollectionViewCell : CHMBaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *doneView;
@property (weak, nonatomic) IBOutlet UIImageView *doneImageView;


- (void)configureWithPlace:(CHMPlace *)place needShowCheckmark:(BOOL)needCheckMark;
- (void)configureWithPlaceType:(PlaceType *)placeType;

@end
