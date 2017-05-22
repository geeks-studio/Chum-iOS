//
//  CHMNavigationController.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMNavigationController.h"
#import "UIColor+CHMProjectsColor.h"

@implementation CHMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configure];
}

- (void)configure {
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationBar setTintColor:[UIColor whiteColor]];

    self.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationItem.backBarButtonItem.title = @"";
    self.navigationItem.leftBarButtonItem.title = @"";


    self.navigationBar.barTintColor = [UIColor mainColor];

    self.navigationBar.translucent = NO;

    [self.navigationController.navigationBar
        setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

}

@end
