//
//  UIColor+CHMProjectsColor.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "UIColor+CHMProjectsColor.h"

@import Colours;

@implementation UIColor (CHMProjectsColor)

+ (UIColor *)mainColor {
    return [UIColor r:106 g:197 b:214];//[UIColor colorWithRed:79.0/200.0 green:200.0/255.0 blue:214.0/255.0 alpha:1.0];
}

+ (UIColor *)darkMainColor {
    return [UIColor r:77 g:149 b:162];
}

+ (UIColor *)projectGray {
    return [UIColor lightGrayColor];
}

+ (UIColor *)projectPinkColor {
    return [UIColor r:237 g:116 b:151];
}

+ (UIColor *)veryLightGrayColor {
    return [UIColor r:240 g:240 b:240];
}

+ (UIColor *)lightBackgroundColor {
    return [UIColor r:234 g:242 b:250];
}

+ (UIColor *)superPostColor {
    return [UIColor r:200 g:248 b:248];
}

+ (UIColor *)projectRed {
    return [UIColor colorWithRed:1.0 green:61.0/255.0 blue:70.0/255.0 alpha:1.0];
}

+ (UIColor *)checkboxColor {
    return [UIColor r:132 g:210 b:182];
}

+ (UIColor *)r:(NSInteger)r g:(NSInteger)g b:(NSInteger)b {
    return [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1.];
}

+ (UIColor *)lightLinkColor {
    return [UIColor colorWithRed:24.0 / 255.0 green:99.0 / 255.0 blue:142.0 / 255.0 alpha:1.0];
}


+ (NSArray *)colorsStrings {
    NSArray *colors = @[
                        @[ @"D32F2F", @"F44336", @"448AFF", @"1976D2" ],
                        // primary red - dark primary red - accent blue - dark primary blue
                        @[ @"C2185B", @"E91E63", @"448AFF", @"1976D2" ],
                        // primary pink - dark primary pink - accent blue - dark primary blue
                        @[ @"7B1FA2", @"9C27B0", @"F44336", @"D32F2F" ],
                        // primary purple - dark primary purple - primary red - dark primary red
                        @[ @"512DA8", @"673AB7", @"E91E63", @"C2185B" ],
                        // primary deep purple - dark primary deep purple - primary pink - dark primary pink
                        @[ @"303F9F", @"3F51B5", @"009688", @"00796B" ],
                        // primary indigo - dark primary indigo - accent teal - dark primary teal
                        @[ @"1976D2", @"448AFF", @"FFC107", @"FFA000" ],
                        // primary blue - dark primary blue - accent amber - dark primary amber
                        @[ @"0288D1", @"03A9F4", @"F44336", @"D32F2F" ],
                        // primary light blue - dark primary light blue - primary red - dark primary red
                        @[ @"0097A7", @"00BCD4", @"FF5722", @"E64A19" ],
                        // primary cyan - dark primary cyan - primary deep orange - dark primary deep orange
                        @[ @"00796B", @"009688", @"FFC107", @"FFA000" ],
                        // primary teal - dark primary teal - accent amber - dark primary amber
                        @[ @"388E3C", @"4CAF50", @"CDDC39", @"AFB42B" ],
                        // primary green - dark primary green - accent lime - dark primary lime
                        @[ @"AFB42B", @"CDDC39", @"FF9800", @"F57C00" ],
                        // primary light green - dark primary light green - accent lime
                        @[ @"689F38", @"8BC34A", @"FF9800", @"F57C00" ],
                        // primary lime - dark primary lime - accent red
                        @[ @"F57C00", @"FF9800", @"E91E63", @"C2185B" ],
                        // primary amber - dark primary amber - accent pink
                        @[ @"E64A19", @"FF5722", @"673AB7", @"512DA8" ],
                        // accent deep orange - dark primary deep orange - accent orange
                        @[ @"455A64", @"607D8B", @"E91E63", @"C2185B" ]
                        // primary blue grey - dark primary blue grey - primary pink
                        
                        ];
    
    return colors;
}


+ (NSArray *)colors {
    static NSArray *colors;
    colors = @[
               [UIColor r:110 g:186 b:238],
               [UIColor r:154 g:92 b:180],
               [UIColor r:41 g:187 b:156],
               [UIColor r:228 g:126 b:48],
               [UIColor r:228 g:77 b:66],
               [UIColor r:127 g:140 b:141],
               [UIColor r:53 g:73 b:93],
               [UIColor r:48 g:173 b:99],
               [UIColor r:70 g:110 b:177],
               [UIColor r:233 g:148 b:62],
               [UIColor r:208 g:84 b:127],
               [UIColor r:141 g:72 b:171],
               [UIColor r:46 g:168 b:237],
               [UIColor r:208 g:78 b:89],
               [UIColor r:57 g:202 b:116]
               ];
    
    
    return colors;
}

+ (UIColor *)colorForText:(NSString *)text {
    if(text.length == 0 ) {
        return [UIColor lightGrayColor];
    }
    unichar firstChar = [text characterAtIndex:0];
     NSArray *colors = [[self class] colors];
    
    int dest = (firstChar) % colors.count;
    
    UIColor *destColor = colors[dest];
    
    
    return destColor;//[UIColor colorFromHexString:[UIColor stringForText:text index:0]];
}

+ (NSString *)stringForText:(NSString *)text
                           index:(int)index {
    NSArray *colors = [[self class] colorsStrings];
    if(text.length == 0) {
        return @"696969";
    }
    
    unichar firstChar = [text characterAtIndex:0];

    
    int dest = (firstChar) % colors.count;
    
    NSArray *destColors = colors[dest];
    
    NSString *destinationColorString = destColors[index];
    
    return destinationColorString;
}





@end
