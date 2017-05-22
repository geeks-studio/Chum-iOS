//
//  CHMPostsListController.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//
#import "CHMAddPostButton.h"
#import "CHMPostCell.h"
#import "CHMPostCreationVC.h"
#import "CHMPostDirectlyTVC.h"
#import "CHMPostHelper.h"
#import "CHMPostsListController.h"
#import "UIColor+CHMProjectsColor.h"
#import "UIViewController+CHMBackgroundCategory.h"

#import "CHMLikeStatus.h"
#import "CHMLikeView.h"
#import "CHMPost.h"

#import "CHMServerBase+PostLoader.h"
#import "UIViewController+CHMShareCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"

#import "CHMLocationManager.h"
#import "CHMServerBase+CHMServerFeedLoader.h"

#import "CHMCurrentUserManager.h"
#import "CHMLikeHelper.h"
#import "CHMPlace.h"
#import "CHMTextHeightHelper.h"

#import "CHUM-Swift.h"

@import BFPaperButton;
@import MapKit;
@import SVPullToRefresh;
@import INTULocationManager;
@import TLYShyNavBar;
@import PureLayout;

// static CGFloat buttonDiametr = 60;
static NSInteger CHMPostCount = 20;

NSString *const CHMPostsListControllerID = @"CHMPostsListControllerID";

@interface CHMPostsListController () <CHMPostsListControllerDelegate>
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIButton *createPostButton;
@property (strong, nonatomic) NSMutableArray *posts;
@property (assign, nonatomic) CLLocationCoordinate2D lastCoordinate;
@property (strong, nonatomic) CHMLikeHelper *likeHelper;
@property (strong, nonatomic) CHMTextHeightHelper *heightHelper;
@property (strong, nonatomic) CLLocation *lastLoaction;
@end

@implementation CHMPostsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.likeHelper = [[CHMLikeHelper alloc] initWithTableView:self.tableView];
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 16 - 24 - 40;
    self.heightHelper = [[CHMTextHeightHelper alloc] initWithTextWidth:width];
    [self setCustomNavigationBackButtonWithTransition];
    if (!self.delegate) {
        self.delegate = self;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(needReloadNotification:)
                                                 name:CHMNeedUpdateLists
                                               object:nil];
    [self configureController];
    [self loadPosts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    self.tableView.contentSize =
        CGSizeMake(self.tableView.frame.size.width, self.tableView.contentSize.height);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ui

- (void)configureController {
    [self configureTableView];
    [self configureCells];
    [self configureNavigationBar];
    [self configurePostButton];
    [self configureRefreshControl];
    [self configureTitleView];
    [self configurePlaceButton];
}

- (void)configurePostButton {
    switch (self.feedType) {
        case CHMFeedTypePlaces:
        case CHMFeedTypeNear:
        case CHMFeedTypeOnePlace:
            self.createPostButton = [self addRightButtonWithName:@"createPostIcon"];
            [self.createPostButton addTarget:self
                                      action:@selector(showPostCreation:)
                            forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            break;
    }
}

- (void)configurePlaceButton {
//    switch (self.feedType) {
//        case CHMFeedTypePlaces: {
//            UIButton *b = [self addLeftButtonWithName:@"placeChooserIcon"];
//            [b addTarget:self
//                          action:@selector(showPlaces)
//                forControlEvents:UIControlEventTouchUpInside];
//
//        } break;
//        default:
//            break;
//    }
}

- (void)configureTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundView.backgroundColor = [UIColor lightBackgroundColor];
    self.tableView.backgroundColor = [UIColor lightBackgroundColor];
}

- (void)configureRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self
                            action:@selector(loadPosts)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor whiteColor];
    self.refreshControl.layer.zPosition -= 1;
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadBottom];
    }
                                                direction:SVInfiniteScrollingDirectionBottom];
    self.tableView.infiniteScrollingView.activityIndicatorViewStyle =
        UIActivityIndicatorViewStyleWhite;
}

- (void)configureTitleView {
    NSString *titleText;
    switch (self.feedType) {
        case CHMFeedTypeOnePlace:
            titleText = self.place.placeName;
            break;
        case CHMFeedTypeNear:
            titleText = @"Вокруг";
            break;
        default:
            break;
    }
    switch (self.feedType) {
        case CHMFeedTypeNear:
        case CHMFeedTypeOnePlace: {
            [self setCustomTitleWithText:titleText];
            break;
        }
        case CHMFeedTypePlaces:
            self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeFeed"]];
            break;
        default:
            self.navigationItem.titleView = nil;
            return;
    }
}

- (void)configureNavigationBar {
    switch (self.feedType) {
        case CHMFeedTypeNear:
        case CHMFeedTypePlaces:
        case CHMFeedTypeOnePlace:
            self.shyNavBarManager.scrollView = self.tableView;
            break;

        default:
            break;
    }
}

#pragma mark - configure

- (void)configureWithPosts:(NSArray *)posts {
    self.posts = posts.mutableCopy;
}

#pragma mark - UITableViewDataSourse
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHMPostCell *cell = [tableView dequeueReusableCellWithIdentifier:[CHMPostCell identifier]];
    CHMPost *post = self.posts[indexPath.row];

    [cell.likeView.upButton addTarget:self
                               action:@selector(likePost:)
                     forControlEvents:UIControlEventTouchUpInside];
    [cell.likeView.downButton addTarget:self
                                 action:@selector(unlikePost:)
                       forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self
                         action:@selector(shareButtonPressed:)
               forControlEvents:UIControlEventTouchUpInside];

    
    BOOL shouldShow = YES;
    if (self.feedType == CHMFeedTypeOnePlace) {
        shouldShow = NO;
    }
    
    [cell configureWithPost:post placeVisible:shouldShow];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHMPost *p = self.posts[indexPath.row];
    static CGFloat heightWithoutText = 16 + 15 + 16 + 20 + 24;
    static CGFloat minHeight = 130;

    CGFloat textHeight = [self.heightHelper heightOfText:p.text];

    CGFloat heightWithText = heightWithoutText + textHeight;

    if (heightWithText < minHeight) {
        heightWithText = minHeight;
    } else if (heightWithText > 500) {
        return 500;
    }
    if (!p.imgUrl) {
        return heightWithText;
    } else {
        return heightWithText + [CHMPostCell imageHeight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CHMPost *post = self.posts[indexPath.row];

    if (self.delegate) {
        [self.delegate postListController:self didSelectPost:post];
    }
}

#pragma mark - post list delegate

- (void)postListController:(CHMPostsListController *)sender didSelectPost:(CHMPost *)post {
    [[Router new] showPostWithPost:post];
}

#pragma mark - title

- (NSString *)titleForPagerTabStripViewController:
    (XLPagerTabStripViewController *)pagerTabStripViewController {
    return self.controllerName ? self.controllerName : @"";
}

#pragma mark - override

- (void)configureCells {
    [self.tableView registerNib:[CHMPostCell nib] forCellReuseIdentifier:[CHMPostCell identifier]];
}

#pragma mark - actions

- (void)addPost:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CHMPostCreationVC *vc = [sb instantiateViewControllerWithIdentifier:CHMPostCreationVCID];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)shareButtonPressed:(UIButton *)sender {
    CHMPostCell *cell = (CHMPostCell *)[self parentCellForView:sender];
    if (!cell) {
        return;
    }
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];

    CHMPost *post = self.posts[ip.row];
    UIImage *img = nil;
    if (post.imgUrl) {
        img = cell.mainImage.image;
    }

    [self sharePost:post withImage:img];
}

- (void)showPostCreation:(UIButton *)sender {
    Router *router = [Router new];

    switch (self.feedType) {
        case CHMFeedTypeNear:
            [router showCreationScreenForNearFeed];
            break;
        case CHMFeedTypePlaces:
            [router showCreationScreenForPlaceFeed];
            break;
        case CHMFeedTypeOnePlace:
            if (self.place.placeID) {
                [router showCreationScreenWithPlaceID:self.place.placeID];
            }
            break;
        default:
            break;
    }
}

#pragma mark - like

- (void)likePost:(UIButton *)sender {
    NSIndexPath *ip = [self indexPathForSender:sender];
    if (!ip) {
        return;
    }
    CHMPost *post = self.posts[ip.row];
    [self.likeHelper likePost:post atIndexPath:ip];
}

- (void)unlikePost:(UIButton *)sender {
    NSIndexPath *ip = [self indexPathForSender:sender];
    if (!ip) {
        return;
    }
    CHMPost *post = self.posts[ip.row];
    [self.likeHelper unlikePost:post atIndexPath:ip];
}

#pragma mark - lazy

- (NSMutableArray *)posts {
    if (!_posts) {
        _posts = [NSMutableArray array];
    }
    return _posts;
}

#pragma mark - notifications

- (void)needReloadNotification:(NSNotification *)note {
    if ([note.name isEqualToString:CHMNeedUpdateLists]) {
        [self loadPosts];
    }
}

#pragma mark - loader

- (void)loadPostsCount:(NSInteger)count
                offset:(NSInteger)offset
            Completion:(void (^)(NSArray *posts, NSError *error, NSInteger statusCode))completion {
    CHMFeedType type = self.feedType;
    switch (type) {
        case CHMFeedTypeNear: {
            [self loadNearPostCount:count offset:offset completion:completion];
            break;
        }
//        case CHMFeedTypePlaces:
//            [[CHMServerBase shared] getPlaceFeedWithCount:count
//                                                   offset:offset
//                                               completion:completion];
//            break;
        case CHMFeedTypeUser:
            [[CHMServerBase shared] loadUserPostsWithCount:count
                                                    offset:offset
                                                completion:completion];
            break;
        case CHMFeedTypeFavorite:
            [[CHMServerBase shared] loadFavePostsWithCount:count
                                                    offset:offset
                                                completion:completion];
            break;
        case CHMFeedTypeOnePlace:
            [[CHMServerBase shared] onePlaceFeed:self.place.placeID
                                           count:count
                                          offset:offset
                                      completion:completion];
            break;
        default:
            break;
    }
}

- (void)loadNearPostCount:(NSInteger)count
                   offset:(NSInteger)offset
               completion:
                   (void (^)(NSArray *posts, NSError *error, NSInteger statusCode))completion {
    if (offset == 0) {
        self.lastLoaction = [CHMLocationManager shared].lastCoordinate;
    }
    if (self.lastLoaction) {
        [[CHMServerBase shared] getNearFeedForCoordinate:self.lastLoaction.coordinate
                                                   count:count
                                                  offset:offset
                                              completion:completion];
    } else {
        [[CHMLocationManager shared]
            loadLocationCompletion:^(CLLocation *currentLocation, NSError *err) {
                if (currentLocation) {
                    self.lastLoaction = currentLocation;
                    [[CHMServerBase shared] getNearFeedForCoordinate:currentLocation.coordinate
                                                               count:count
                                                              offset:offset
                                                          completion:completion];
                } else {
                    [self updateBackground];
                    if (completion) {
                        completion(nil, err, err.code);
                    }
                }
            }];
    }
}

- (void)reloadDataSender:(id)sender {
    [self loadPosts];
}

- (void)loadPosts {
    [self loadPostsCount:CHMPostCount
                  offset:0
              Completion:^(NSArray *posts, NSError *error, NSInteger statusCode) {
                  [self.refreshControl endRefreshing];
                  if (posts) {
                      self.posts = posts.mutableCopy;  // [self appendPosts:posts];
                      [self.tableView reloadData];
                      [self updateBackground];
                  }
              }];
}

- (void)loadBottom {
    [self loadPostsCount:CHMPostCount
                  offset:self.posts.count
              Completion:^(NSArray *posts, NSError *error, NSInteger statusCode) {

                  [self.tableView.infiniteScrollingView stopAnimating];
                  if (posts) {
                      [self appendPosts:posts];
                  }
              }];
}

- (void)appendPosts:(NSArray *)posts {
    [self.posts addObjectsFromArray:posts];

    [self.tableView reloadData];
}

#pragma mark - background

- (void)updateBackground {
    CHMFeedType ft = self.feedType;
    if (self.posts.count == 0 &&
        (ft == CHMFeedTypeOnePlace || ft == CHMFeedTypePlaces || ft == CHMFeedTypeNear)) {
        NSString *text = @"Разбуди чама - напиши пост!";
        if (self.feedType == CHMFeedTypeNear) {
            text = @"Рядом с тобой нет постов, будь первым!";
            if ([INTULocationManager locationServicesState] != INTULocationServicesStateAvailable) {
                text = @"Включи геолокацию чтобы увидеть посты "
                       @"рядом";
            }
        } else if (self.feedType == CHMFeedTypePlaces) {
            text = @"Тут пока пусто. Выбери новое место или "
                   @"напиши "
                   @"пост";
        }
        [self configureBackgroundWithImageWithName:@"noposts" onBottom:NO withText:text];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        [self configureBackgroundWithImageWithName:nil];
    }
}

#pragma mark - override

//- (BOOL)hidesBottomBarWhenPushed {
//    return NO;
//}

@end
