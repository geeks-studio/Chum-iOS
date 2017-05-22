//
//  CHMEmailHelper.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 01/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMEmailHelper.h"
#import <MessageUI/MessageUI.h>
#import "UIViewController+ZPPViewControllerCategory.h"
//#import ""
//@import m
//@import mailComposeController;

@interface CHMEmailHelper() <MFMailComposeViewControllerDelegate>

@end

@implementation CHMEmailHelper

- (instancetype)initWithVc:(UIViewController *)vc
{
    self = [super init];
    if (self) {
        self.vc = vc;
        
    }
    return self;
}



- (void)showEmail{
    
    
    if(![MFMailComposeViewController canSendMail]) {
        [self.vc showWarningWithText:@"Ошибка отправки e-mail!"];
        return;
    }
    
    
    // Email Subject
    NSString *emailTitle = @"Отзыв о приложении";
    // Email Content
    NSString *messageBody = @"Здесь ты можешь оставить отзыв о приложении =)";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"feedback@chum.space"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self.vc presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    // Close the Mail Interface
    [self.vc dismissViewControllerAnimated:YES completion:NULL];
}

@end
