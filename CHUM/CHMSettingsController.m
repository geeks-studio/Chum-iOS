//
//  CHMSettingsController.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 13/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMCurrentUserManager.h"
#import "CHMEmailHelper.h"
#import "CHMServerBase+CHMUserLoader.h"
#import "CHMSettings.h"
#import "CHMSettingsController.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "CHMRulesVC.h"
#import "CHMNotificationCenter.h"

NSString *const CHMSettingsControllerID = @"CHMSettingsControllerID";

NSString *const kCHMOfficialSite = @"http://chumapp.ru/";
NSString *const kCHMRules = @"http://chumapp.ru/Uslovia.pdf";
NSString *const kCHMPolitics = @"http://chumapp.ru/Politika_konfidentsialnosti.pdf";

NSString *const kCHMVkGroup = @"https://vk.com/chumapprus";
NSString *const kCHMInstagram = @"https://www.instagram.com/chum_app/";

@interface CHMSettingsController ()

@property (strong, nonatomic) CHMEmailHelper *emailHelper;

@end

@implementation CHMSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavigationBackButtonWithTransition];

    self.emailHelper = [[CHMEmailHelper alloc] initWithVc:self];

    self.navigationItem.titleView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingsIcon"]];

    UIButton *b = [self addRightButtonWithName:@"confirmIcon"];

    [b addTarget:self
                  action:@selector(saveNotificationData)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self configureSettings];
    [self updateSettings];
    
    [CHMNotificationCenter shared].canShow = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [CHMNotificationCenter shared].canShow = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    self.tableView.contentSize =
        CGSizeMake(self.tableView.frame.size.width, self.tableView.contentSize.height);
    
    self.tableView.showsHorizontalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSettings {
    [[CHMServerBase shared]
        loadSettingsWithCompletion:^(CHMSettings *sets, NSError *error, NSInteger statusCode) {
            if (sets) {
                [CHMCurrentUserManager shared].settings = sets;
            }
        }];
}

- (void)configureSettings {
    CHMSettings *settings = [CHMCurrentUserManager shared].settings;
    self.messageSwith.on = settings.messagePush;
    self.commentsSwitch.on = settings.commentsPush;
    self.levelSwitch.on = settings.levelsPush;
}

- (void)saveNotificationData {
    CHMSettings *setings = [[CHMSettings alloc] init];

    setings.messagePush = self.messageSwith.isOn;
    setings.commentsPush = self.commentsSwitch.isOn;
    setings.levelsPush = self.levelSwitch.isOn;

    [[CHMServerBase shared]
        updateSettings:setings
            completion:^(CHMSettings *sets, NSError *error, NSInteger statusCode) {
                if (sets) {
                    [CHMCurrentUserManager shared].settings = sets;
                    [self showSuccessWithText:@"Обновлено!"];
                }
                [self updateSettings];

            }];
}

- (void)openUrlAsString:(NSString *)urlAsString {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAsString]];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self.emailHelper showEmail];
                break;
            case 1:
                [self openUrlAsString:kCHMOfficialSite];
                break;
            case 2:
                [self openUrlAsString:kCHMRules];
                break;
            case 3:
                [self openUrlAsString:kCHMPolitics];
                break;
            case 4:
                [self showSettings];
                break;

            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                [self openUrlAsString:kCHMVkGroup];
                break;
            case 1:
                [self openUrlAsString:kCHMInstagram];
                break;
            default:
                break;
        }
    }
}

- (void)showSettings {
    CHMRulesVC *vc = [[CHMRulesVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];

}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath
*)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#>
forIndexPath:indexPath];

    // Configure the cell...

    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath
*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath]
withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new
row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
