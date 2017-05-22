//
//  PAAConversationsTVC.m
//  PartyApp
//
//  Created by Andrey Mikhaylov on 20/11/15.
//  Copyright © 2015 Alfred Zien. All rights reserved.
//

#import "PAAConversation.h"
#import "PAAConversationCell.h"
#import "PAAConversationsTVC.h"
#import "PAAMessageManager.h"
#import "PAAMessagerVC.h"
#import "UIColor+CHMProjectsColor.h"
#import "UITableViewController+ZPPTVCCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"

#import "CHUM-Swift.h"

NSString *const PAAConversationsTVCID = @"PAAConversationsTVCID";
NSString *const PAANeedReloadConversations = @"PAANeedReloadConversations";

@interface PAAConversationsTVC ()
@property (strong, nonatomic) NSArray *conversations;
@end

@implementation PAAConversationsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTitle];
    [self registrateCells];
    [self configureTableView];
    [self setCustomNavigationBackButtonWithTransition];
    [self configureRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.contentSize =
        CGSizeMake(self.tableView.frame.size.width, self.tableView.contentSize.height);
    [self loadConversations];
    self.tableView.scrollsToTop = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadConversations)
                                                 name:PAANeedReloadConversations
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.scrollsToTop = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PAANeedReloadConversations
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - ui

- (void)configureTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor lightBackgroundColor];
}

- (void)configureRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(loadConversations)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PAAConversationCell *cell =
        [tableView dequeueReusableCellWithIdentifier:[PAAConversationCell identifier]];
    PAAConversation *conv = self.conversations[(NSUInteger)indexPath.row];
    [cell configureWithConversation:conv];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PAAConversation *c = self.conversations[(NSUInteger)indexPath.row];
    [self showMessagesWithConversation:c];
}

#pragma mark - actions

- (void)loadConversations {
    [[PAAMessageManager sharedInstance]
        loadAllConversationsWithCompletion:^(NSArray *conversations, NSError *err,
                                             NSInteger statusCode) {
            [self.refreshControl endRefreshing];
            if (conversations) {
                self.conversations = conversations;
            }
            [self updateBackground];
            [self.tableView reloadData];
        }];
}

- (void)showMessagesWithConversation:(PAAConversation *)conversation {
    Router *router = [Router new];
    [router showMessangerWithConversation:conversation];
}

#pragma mark - support

- (void)configureTitle {
    self.navigationItem.titleView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messageIcon"]];
}

- (void)registrateCells {
    [self.tableView registerNib:[PAAConversationCell nib]
         forCellReuseIdentifier:[PAAConversationCell identifier]];
}

- (void)reloadDataSender:(id)sender {
    [self loadConversations];
}

#pragma mark - background
- (void)updateBackground {
    if (self.conversations.count == 0) {
        NSString *text =
            @"Чам хочет, чтобы ты написал кому-нибудь в "
            @"личный "
            @"чат!";
        [self configureBackgroundWithImageWithName:@"noMessages" onBottom:NO withText:text];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        [self configureBackgroundWithImageWithName:nil];
    }
}

@end
