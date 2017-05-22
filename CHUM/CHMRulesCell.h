//
//  CHMRulesCell.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 15/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMBaseCell.h"

@interface CHMRulesCell : CHMBaseCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *descrLabel;

- (void)configureWithText:(NSString *)text number:(NSInteger)index;

@end
