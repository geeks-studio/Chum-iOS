//
//  CHMTextHeightHelper.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMTextHeightHelper.h"

@implementation CHMTextHeightHelper


- (instancetype)initWithTextWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
        self.textWidth = width;
    }
    return self;
}

- (NSDictionary *)textParams {
    if(!_textParams) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{
                                     NSFontAttributeName : [UIFont systemFontOfSize:17],
                                     NSParagraphStyleAttributeName : paragraphStyle
                                     };
        
        
        _textParams = attributes;
    }
    
    return _textParams;
}


- (CGFloat)heightOfText:(NSString *)text {
    
    CGRect r = [text boundingRectWithSize:CGSizeMake(self.textWidth, CGFLOAT_MAX)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:self.textParams
                                  context:nil];
    
    
    return r.size.height;

}

@end
