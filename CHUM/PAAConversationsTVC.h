//
//  PAAConversationsTVC.h
//  PartyApp
//
//  Created by Andrey Mikhaylov on 20/11/15.
//  Copyright © 2015 Alfred Zien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHMCanBeReloaded.h"

extern NSString *const PAAConversationsTVCID;
extern NSString *const PAANeedReloadConversations;

@interface PAAConversationsTVC : UITableViewController <CHMCanBeReloaded>

@end
