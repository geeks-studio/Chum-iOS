//
//  PAAXLPageBase.m
//  PartyApp
//
//  Created by Andrey Mikhaylov on 24/10/15.
//  Copyright © 2015 Alfred Zien. All rights reserved.
//

#import "PAAXLPageBase.h"
#import "UIColor+CHMProjectsColor.h"

//#import "PAStyleKit.h"
//#import "UIColor+PAAProjectsColor.h"

@interface PAAXLPageBase ()

@end

@implementation PAAXLPageBase

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isProgressiveIndicator = YES;
    self.isElasticIndicatorLimit = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:nil
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    self.buttonBarView.selectedBarHeight = 3.0;
    [self.buttonBarView setBackgroundColor:[UIColor clearColor]];
    [self.buttonBarView.selectedBar setBackgroundColor:[UIColor mainColor]];
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonBarView];
    [self.view bringSubviewToFront:self.buttonBarView];

    [self.buttonBarView registerNib:[UINib nibWithNibName:@"ButtonCell"
                                                   bundle:[NSBundle bundleForClass:[self class]]]
         forCellWithReuseIdentifier:@"Cell"];

    self.buttonBarView.leftRightMargin = 70;
    self.buttonBarView.scrollEnabled = NO;

    CGRect r = self.buttonBarView.selectedBar.frame;
    CGSize s = [UIScreen mainScreen].bounds.size;
    self.buttonBarView.selectedBar.frame =
        CGRectMake(r.origin.x, r.origin.y, s.width / 2.0, r.size.height);

    self.changeCurrentIndexProgressiveBlock =
        ^void(XLButtonBarViewCell *oldCell, XLButtonBarViewCell *newCell,
              CGFloat progressPercentage, BOOL changeCurrentIndex, BOOL animated) {
            if (changeCurrentIndex) {
                [oldCell.label setTextColor:[UIColor projectGray]];
                [newCell.label setTextColor:[UIColor mainColor]];
            }
        };
}

@end
