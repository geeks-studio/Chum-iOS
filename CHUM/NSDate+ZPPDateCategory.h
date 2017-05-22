//
//  NSDate+ZPPDateCategory.h
//  ZP
//
//  Created by Andrey Mikhaylov on 16/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZPPDateCategory)

- (NSString *)timeStringfromDate;
- (NSString *)dateStringFromDate;
+ (NSDate *)customDateFromString:(NSString *)dateAsString;

- (NSString *)serverFormattedString;

@end
