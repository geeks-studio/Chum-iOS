//
//  CHMTextHeightHelper.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHMTextHeightHelper : NSObject

@property (strong, nonatomic) NSDictionary *textParams;
@property (assign, nonatomic) CGFloat textWidth;


- (instancetype)initWithTextWidth:(CGFloat)width;
- (CGFloat)heightOfText:(NSString *)text;


@end
