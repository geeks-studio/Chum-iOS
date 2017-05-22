//
//  CHMSettingsController.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 13/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const CHMSettingsControllerID;
@interface CHMSettingsController : UITableViewController


@property (weak, nonatomic) IBOutlet UISwitch *messageSwith;
@property (weak, nonatomic) IBOutlet UISwitch *commentsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *levelSwitch;

@end
