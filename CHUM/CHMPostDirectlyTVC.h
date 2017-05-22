//
//  CHMPostDirectlyTVC.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

//#import "CHMBaseTVC.h"
@import SlackTextViewController;
#import "CHMPostProtocol.h"

extern NSString *const CHMPostDirectlyTVCID;

@interface CHMPostDirectlyTVC : SLKTextViewController <CHMPostProtocol>

@end
