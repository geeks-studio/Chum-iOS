//
//  CHMUserProfile.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMCarmaCell.h"
#import "CHMCurrentUserManager.h"
#import "CHMEmailHelper.h"
#import "CHMMyPostsVC.h"
#import "CHMNavigationController.h"
#import "CHMServerBase+CHMUserLoader.h"
#import "CHMSettingsController.h"
#import "CHMUser.h"
#import "CHMUserAction.h"
#import "CHMUserActionCell.h"
#import "CHMUserProfileController.h"
#import "PAAConversationsTVC.h"
#import "PAAMessageManager.h"
#import "UIColor+CHMProjectsColor.h"
#import "UIViewController+CHMShareCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"

#import "CHUM-Swift.h"

@import MBProgressHUD;

NSString *const CHMUserProfileControllerID = @"CHMUserProfileControllerID";

NSString *const kCHMCHUMTutorialShowedKey = @"kCHMCHUMTutorialShowedKey";

@interface CHMUserProfileController ()

@property (strong, nonatomic) CHMUser *user;
@property (strong, nonatomic) NSArray *actions;
@property (strong, nonatomic) NSNumber *unreadCount;
@property (strong, nonatomic) CHMEmailHelper *emailHelper;
@property (strong, nonatomic) NSString *unwathedCountString;
@property (strong, nonatomic) TutorialWorker *tutorialWorker;
@property (strong, nonatomic) Karma *karma;
@property (strong, nonatomic) NSNumber *radius;

@end

@implementation CHMUserProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self registrateCells];
    //    [self loadUser];
    [self setCustomNavigationBackButtonWithTransition];

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(updateUnwathedCount:)
               name:[UserActivityNotifier CHMUnshowedActivityCountNotification]
             object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UserActivityNotifier updateUnwatherCountEverythere];
    [self updateKarma];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.scrollsToTop = YES;
    [self tryShowTutorial];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.scrollsToTop = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ui
- (void)configureUI {
    [self configureTitleView];
    [self configureTableView];
    [self configureFooter];
}

- (void)configureTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor lightBackgroundColor];
}

- (void)configureFooter {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    v.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = v;
}

- (void)configureTitleView {
    UIImage *img = [UIImage imageNamed:@"profile"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    self.navigationItem.titleView = imgView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.actions.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self karmaCell];
    } else {
        return [self actionCellForIndexPath:indexPath];
    }
}

- (CHMCarmaCell *)karmaCell {
    CHMCarmaCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:[CHMCarmaCell identifier]];

    //    [cell configureWithUser:self.user];
    [cell configureWithKarma:self.karma];
    [cell configureWithRadius:self.radius];

    return cell;
}

- (CHMUserActionCell *)actionCellForIndexPath:(NSIndexPath *)indexPath {
    CHMUserActionCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:[CHMUserActionCell identifier]];
    CHMUserAction *action = self.actions[indexPath.row];
    [cell configureWithAction:action];
    switch (action.type) {
        case CHMUserActionTypeSuperUser: {
            NSString *userTypeName = [CHMCurrentUserManager shared].user.superUserTypeName;
            if (userTypeName && ![userTypeName isEqual:[NSNull null]]) {
                [cell configureWithText:userTypeName];
            } else {
                [cell configureWithText:nil];
            }
            break;
        }
        case CHMUserActionTypeActivity:
            [cell configureWithText:self.unwathedCountString];
            break;
        default:
            [cell configureWithText:nil];
            break;
    }
    return cell;
}

#pragma mark - tableviewdelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [UIScreen mainScreen].bounds.size.width * 0.7;
    } else {
        return 80.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1) {
        CHMUserAction *action = self.actions[indexPath.row];

        [self actionForAction:action];
    }
}

#pragma mark - actions

- (void)actionForAction:(CHMUserAction *)action {
    CHMUserActionType type = action.type;

    switch (type) {
        case CHMUserActionTypeShowMyPosts:
            [self showMyPosts];
            break;
        case CHMUserActionTypeShowDialogs:
            [self showDialogs];
            break;
        //        case CHMUserActionTypeShowMyPlaces:
        //            [self showMyPlaces];
        //            break;
        case CHMUserActionTypeFeedBack:
            [self showFeedBack];
            break;
        case CHMUserActionTypeShareApplication:
            [self shareApplication];  // category method
            break;
        case CHMUserActionTypeShowMySettings:
            [self showSettings];
            break;
        case CHMUserActionTypeSuperUser:
            [self showSuperUser];
            break;
        case CHMUserActionTypeActivity:
            [self showActivity];
            break;
        default:
            break;
    }
}

- (void)showMyPosts {
    CHMMyPostsVC *vc = [[CHMMyPostsVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)showMyPlaces {
//    CHMMyPlacesController *vc = [[CHMMyPlacesController alloc]
//        initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)showDialogs {
    PAAConversationsTVC *vc = [[PAAConversationsTVC alloc] init];

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showFeedBack {
    self.emailHelper = [[CHMEmailHelper alloc] initWithVc:self];
    [self.emailHelper showEmail];
}

- (void)showSettings {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CHMSettingsController *vc =
        [sb instantiateViewControllerWithIdentifier:CHMSettingsControllerID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showActivity {
    Router *r = [Router new];
    [r showActivityController];
}

- (void)showSuperUser {
    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"Admin"
                                            message:@"input code"
                                     preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *loginAction =
        [UIAlertAction actionWithTitle:@"Login"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *_Nonnull action) {

                                   UITextField *codeTextField = alertController.textFields[0];
                                   [self activateSuperUserWithCode:codeTextField.text];

                               }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action){

                                                         }];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.placeholder = @"Code";
    }];

    [alertController addAction:loginAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController
                       animated:YES
                     completion:^{

                     }];
}

- (void)activateSuperUserWithCode:(NSString *)code {
    if (!code) {
        return;
    }

    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[CHMServerBase shared] activateSuperUserWithCode:code
                                           completion:^(NSError *error, NSInteger statusCode) {
                                               [MBProgressHUD
                                                   hideHUDForView:self.navigationController.view
                                                         animated:YES];
                                               if (!error) {
                                                   [self showSuccessWithText:@"Успешно!"];
                                                   [self loadUser];
                                               }
                                           }];
}

#pragma mark - notifications

- (void)updateUnwathedCount:(NSNotification *)note {
    NSNumber *count = note.object;
    if (count.integerValue != 0) {
        self.unwathedCountString = [NSString stringWithFormat:@"%@", note.object];
    } else {
        self.unwathedCountString = nil;
    }
    [self.tableView reloadData];
}

#pragma mark - server

- (void)reloadDataSender:(id)sender {
    [self loadUser];
}
- (void)loadUser {
    [[CHMServerBase shared]
        getCurrentUserWithCompletion:^(CHMUser *user, NSError *error, NSInteger statusCode) {
            self.user = user;
            [self.tableView reloadData];
        }];
}

- (void)updateKarma {
    [[CHMServerBase shared]
        loadKarmaWithCompletion:^(Karma *karma, NSError *error, NSInteger statusCode) {
            self.karma = karma;
            [self.tableView reloadData];
        }];

    [[CHMServerBase shared]
        loadRadiusWithCompletion:^(NSNumber *radius, NSError *error, NSInteger statusCode){
            self.radius = radius;
            [self.tableView reloadData];
        }];
}

#pragma mark - lazy

- (NSArray *)actions {
    if (!_actions) {
        _actions = [CHMUserAction allActions];
    }
    return _actions;
}

- (NSString *)unwathedCountString {
    if (!_unwathedCountString) {
        _unwathedCountString = @"";
    }

    return _unwathedCountString;
}

#pragma mark - support

- (void)registrateCells {
    [self.tableView registerNib:[CHMUserActionCell nib]
         forCellReuseIdentifier:[CHMUserActionCell identifier]];
    [self.tableView registerNib:[CHMCarmaCell nib]
         forCellReuseIdentifier:[CHMCarmaCell identifier]];
}

#pragma mark - tutorial

- (void)tryShowTutorial {
    BOOL didShow = [[NSUserDefaults standardUserDefaults] boolForKey:kCHMCHUMTutorialShowedKey];

    if (didShow) {
        return;
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kCHMCHUMTutorialShowedKey];
    }

    CGFloat verticalOffset = self.navigationController.navigationBar.frame.size.height + 20 +
                             [UIScreen mainScreen].bounds.size.width * 0.7 - 32;
    CGSize s = [UIScreen mainScreen].bounds.size;
    CGRect backR = CGRectMake(0, 0, s.width, s.height);

    self.tutorialWorker = [TutorialWorker new];
    UIView *v = [self.tutorialWorker
        generateTutorialViewForScreenCenterWithTitle:@"ВЫРАСТИ ЧАМА"
                                                text:@"Это Чам. "
                                                     @"Когда другие "
                                                     @"пользователи "
                                                     @"ставят лайки "
                                                     @"на твои посты "
                                                     @"и "
                                                     @"комментарии, "
                                                     @"растет твой "
                                                     @"щенок и "
                                                     @"максимальный "
                                                     @"радиус постов."
                                      verticalOffset:verticalOffset
                                           backFrame:backR];

    [self.tabBarController.view addSubview:v];
    [self.tutorialWorker showView];
}

@end
