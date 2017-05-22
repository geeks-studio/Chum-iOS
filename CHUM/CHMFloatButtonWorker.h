//
//  CHMFloatButtonWorker.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGPlusButtonsView;  ///

@interface CHMFloatButtonWorker : NSObject

@property (assign, nonatomic) BOOL canShowMessageButton;
@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewExample;
@property (weak, nonatomic) UITableView *tableView;

- (instancetype)initWithTableView:(UITableView *)tableView;
- (void)configureFloatButton;

- (void)buttonAction;

@end
