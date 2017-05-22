//
//  CHMDescrCell.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 29/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMBaseCell.h"
@class CHMDescriptionView;

@interface CHMDescrCell : CHMBaseCell

@property (weak, nonatomic) IBOutlet CHMDescriptionView *descrView;

@end
