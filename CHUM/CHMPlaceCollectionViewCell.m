//
//  CHMPlaceCollectionViewCell.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 04/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMPlace.h"
#import "CHMPlaceCollectionViewCell.h"
#import "UIColor+CHMProjectsColor.h"
#import "CHUM-Swift.h"

@import Colours;
@import SDWebImage;

@interface CHMPlaceCollectionViewCell ()

@property (strong, nonatomic) CAGradientLayer *gradient;

@end

@implementation CHMPlaceCollectionViewCell

- (void)drawRect:(CGRect)rect {
    self.backImageView.layer.cornerRadius = rect.size.width / 2.0;
    self.backImageView.layer.masksToBounds = YES;
    self.doneView.layer.cornerRadius = self.backImageView.layer.cornerRadius;
    self.doneImageView.layer.cornerRadius = self.doneImageView.frame.size.width / 2.0;
    self.gradient.frame = self.backImageView.frame;
    self.doneView.layer.masksToBounds = YES;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self configureFontSizeWtihText];
}
- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.backImageView.frame;
    UIColor *c = [UIColor colorFromHexString:@"1c4b50"];
    c = [c colorWithAlphaComponent:0.6];
    UIColor *c2 = [c colorWithAlphaComponent:0.4];
    gradient.colors = [NSArray arrayWithObjects:(id)[c CGColor], (id)[c2 CGColor], nil];
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;

    [self.backImageView.layer insertSublayer:gradient atIndex:0];
    self.gradient = gradient;
}

- (void)configureWithPlace:(CHMPlace *)place needShowCheckmark:(BOOL)needCheckMark {
    self.nameLabel.text = place.placeName;
    self.backImageView.backgroundColor = [UIColor colorForText:place.placeID];
    if (place.placeURL) {
        [self.backImageView sd_setImageWithURL:place.placeURL];
    } else {
        self.backImageView.image = nil;
    }
    if (place.isChoosed && needCheckMark) {
        self.doneView.hidden = NO;
    } else {
        self.doneView.hidden = YES;
    }
}

- (void)configureWithPlaceType:(PlaceType *)placeType {
    self.nameLabel.text = placeType.placeType;
    self.backImageView.backgroundColor = [UIColor colorForText:placeType.placeType];
    
    self.doneView.hidden = YES;
}

- (void)configureFontSizeWtihText {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        NSString *placeName = self.nameLabel.text;
        NSArray *array =
        [placeName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
        
        NSString *maxLenStr = [array firstObject];
        for (NSString *word in array) {
            if (word.length > maxLenStr.length) {
                maxLenStr = word;
            }
        }
        int i = 17;
        UIFont *font;
        for (; i > 5; i--) {
            font = [UIFont systemFontOfSize:i];
            CGSize s = [maxLenStr sizeWithAttributes:@{NSFontAttributeName : font}];
            if (s.width < (([UIScreen mainScreen].bounds.size.width/3.0)-20)*0.85) {
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
             self.nameLabel.font = font;
        });
    });
}

@end
