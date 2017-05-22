//
//  CHMPostDirectlyTVC.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMComment.h"
#import "CHMCommentCell.h"
#import "CHMCurrentUserManager.h"
#import "CHMEmptyCommentCell.h"
#import "CHMLikeStatus.h"
#import "CHMLikeView.h"
#import "CHMLoadingCell.h"
#import "CHMNotificationCenter.h"
#import "CHMPhoto.h"
#import "CHMPlace.h"
#import "CHMPost.h"
#import "CHMPostDirectlyTVC.h"
#import "CHMPostMainCell.h"
#import "CHMUser.h"
#import "MGSwipeTableCell.h"
#import "PAAMessagerVC.h"
#import "UIColor+CHMProjectsColor.h"
#import "UITableViewController+ZPPTVCCategory.h"
#import "UIViewController+CHMShareCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"

#import "CHMServerBase+PostLoader.h"

#import "CHMLikeHelper.h"
#import "CHMTextHeightHelper.h"
#import "CHMTextView.h"
#import "MGSwipeTableCell.h"

#import "CHMFloatButtonWorker.h"

#import "CHUM-Swift.h"

@import MBProgressHUD;
@import CCBottomRefreshControl;
@import NYTPhotoViewer;
@import LGPlusButtonsView;
@import Crashlytics;

#define DEBUG_CUSTOM_TYPING_INDICATOR 0

NSString *const CHMPostDirectlyTVCID = @"CHMPostDirectlyTVCID";
static NSString *kCHMDidShowedMessangerCell = @"kCHMDidShowedMessangerCell";

@interface CHMPostDirectlyTVC () <MGSwipeTableCellDelegate, LGPlusButtonsViewDelegate>
@property (strong, nonatomic) CHMPost *post;
@property (assign, nonatomic) BOOL isMenuHidden;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) CHMPost *originalPost;
//дикие опасные костыли. это тут только для того чтобы в ленте норм обновлялось
@property (strong, nonatomic) CHMLikeHelper *likeHelper;
@property (strong, nonatomic) CHMTextHeightHelper *heightHelper;
@property (strong, nonatomic) NSMutableArray *comments;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isShowedMessagerCell;
@property (strong, nonatomic) CHMComment *replyComment;
@property (strong, nonatomic) CHMFloatButtonWorker *buttonWorker;
@end

@implementation CHMPostDirectlyTVC

#pragma mark - init

- (id)init {
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder {
    return UITableViewStylePlain;
}

- (void)commonInit {
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView
                                             selector:@selector(reloadData)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];

    self.isMenuHidden = YES;
    [self registerClassForTextView:[CHMTextView class]];
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inverted = NO;
    [self setCustomNavigationBackButtonWithTransition];
    [self configureCells];
    [self configureTextView];
    [self configureUI];
    self.likeHelper = [[CHMLikeHelper alloc] initWithTableView:self.tableView];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"postIcon"]];
    self.navigationItem.titleView = iv;
    [self.rightButton setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    self.isShowedMessagerCell =
        [[NSUserDefaults standardUserDefaults] boolForKey:kCHMDidShowedMessangerCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];

    // don,t touch, fucking magic
    [self.tableView.bottomRefreshControl addTarget:self
                                            action:@selector(loadComments)
                                  forControlEvents:UIControlEventValueChanged];

    [CHMNotificationCenter shared].currentPostID = self.post.postID;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.originalPost.commentCount = [self countOfComments];
    self.originalPost.likeStatus = self.post.likeStatus;
    self.originalPost.text = self.post.text;
    [CHMNotificationCenter shared].currentPostID = nil;

    // dont touch, fucking magic
    [self.tableView.bottomRefreshControl removeTarget:self
                                               action:@selector(loadComments)
                                     forControlEvents:UIControlEventValueChanged];
    [self clearCachedText];
}

- (NSNumber *)countOfComments {
    NSInteger count = [self.post countOfComments];
    if (count < self.comments.count) {
        count = self.comments.count;
    }

    return @(count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureWithPost:(CHMPost *)post {
    self.post = post;

    if (!self.originalPost) {
        self.originalPost = post;
    }

    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[ ip ] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - text view setup

- (void)configureTextView {
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.textInputbarHidden = !self.post.commentsIsOn;

    [self.leftButton setTintColor:[UIColor grayColor]];

    [self.rightButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];

    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 200;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
    self.textView.placeholder = @"Сообщение";

    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    [self.textInputbar.editorLeftButton setTintColor:[UIColor colorWithRed:0.0 / 255.0
                                                                     green:122.0 / 255.0
                                                                      blue:255.0 / 255.0
                                                                     alpha:1.0]];
    [self.textInputbar.editorRightButton setTintColor:[UIColor colorWithRed:0.0 / 255.0
                                                                      green:122.0 / 255.0
                                                                       blue:255.0 / 255.0
                                                                      alpha:1.0]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Overriden Methods

- (BOOL)ignoreTextInputbarAdjustment {
    return [super ignoreTextInputbarAdjustment];
}

- (BOOL)forceTextInputbarAdjustmentForResponder:(UIResponder *)responder {
    // On iOS 9, returning YES helps keeping the input view visible when the keyboard if presented
    // from another app when using multi-tasking on iPad.
    return SLK_IS_IPAD;
}

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status {
    // Notifies the view controller that the keyboard changed status.
}

- (void)textWillUpdate {
    // Notifies the view controller that the text will update.

    [super textWillUpdate];
}

- (void)textDidUpdate:(BOOL)animated {
    // Notifies the view controller that the text did update.
    [super textDidUpdate:animated];
}

- (void)didPressLeftButton:(id)sender {
    // Notifies the view controller when the left button's action has been triggered, manually.
    [super didPressLeftButton:sender];
}

- (void)didPressRightButton:(id)sender {
    if (!self.comments) {
        return;
    }
    if (self.post.postID) {
        [Answers logCustomEventWithName:@"comment sended"
                       customAttributes:@{
                           @"post_id" : self.post.postID
                       }];
    }
    NSString *commentText = [self commentText];
    if (commentText.length <= 0) {
        return;
    }

    CHMComment *c = [CHMComment new];
    CHMComment *replyComment = [self userReplyComment];

    if (replyComment) {
        c.replyCommentID = replyComment.commentID;
        c.replyAvatarProvider = replyComment.avatarProvider;
    }
    self.replyComment = nil;
    c.commentText = commentText;
    BOOL wasEmpty = self.comments.count > 0 ? NO : YES;
    [self.comments addObject:c];

    [self.textView refreshFirstResponder];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.comments.count - 1 inSection:1];
    UITableViewRowAnimation rowAnimation =
        self.inverted ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
    UITableViewScrollPosition scrollPosition =
        !self.inverted ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop;

    [self.tableView beginUpdates];
    if (!wasEmpty) {
        [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:rowAnimation];
    } else {
        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:rowAnimation];
    }
    [self.tableView endUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:UITableViewRowAnimationAutomatic];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self.tableView scrollToRowAtIndexPath:indexPath
                                             atScrollPosition:scrollPosition
                                                     animated:YES];
                   });
    [self sendComment:c];
    [super didPressRightButton:sender];
}

- (NSString *)commentText {
    CHMComment *replyComment = [self userReplyComment];
    NSString *commentText;

    if (replyComment) {
        commentText = self.textView.text.copy;
        NSRange avatarRange = NSMakeRange(0, 1);
        commentText = [commentText stringByReplacingCharactersInRange:avatarRange withString:@""];
        if (commentText.length > 0) {
            NSString *firstChar = [commentText substringToIndex:1];
            if ([firstChar isEqualToString:@","]) {
                commentText =
                    [commentText stringByReplacingCharactersInRange:avatarRange withString:@""];
            }
        }
        commentText =
            [commentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        commentText = [self.textView.text copy];
    }

    return commentText;
}

- (NSString *)keyForTextCaching {
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (void)willRequestUndo {
    [super willRequestUndo];
}

- (void)didCancelTextEditing:(id)sender {
    [super didCancelTextEditing:sender];
}

- (BOOL)canPressRightButton {
    return [super canPressRightButton];
}

#pragma mark - action button actions

- (void)showMap:(UIButton *)sender {
    CHMPlace *locationPlace = [self.post locationPlace];
    NSNumber *lat = locationPlace.lat;
    NSNumber *lon = locationPlace.lon;

    if (!lat || !lon || [lat isEqual:[NSNull null]] || [lon isEqual:[NSNull null]]) {
        return;
    }

    CLLocationCoordinate2D c = CLLocationCoordinate2DMake(lat.floatValue, lon.floatValue);

    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:c addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
    mapItem.name = NSLocalizedString(@"CHUM", @"post");

    [MKMapItem openMapsWithItems:@[ mapItem ] launchOptions:@{}];
}

- (void)sharePost:(UIButton *)sender {
    UIImage *img = [self postImage];
    [self sharePost:self.post withImage:img];
}

- (void)reportPostAction:(UIButton *)sender {
    if ([[CHMCurrentUserManager shared] canDeletePostInPlaceWithID:self.post.place.placeID]) {
        [self deletePost];
    } else {
        [self reportPost:sender];
    }
}

#pragma mark - UITableViewDataSourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (self.comments.count) {
            return self.comments.count;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CHMPostMainCell *cell =
            [self.tableView dequeueReusableCellWithIdentifier:[CHMPostMainCell identifier]];

        [cell configureWithPost:self.post];
        [self addTargetsOnCell:cell];

        cell.transform = tableView.transform;

        [cell layoutSubviews];

        return cell;
    } else if (indexPath.section == 1) {
        if (!self.comments) {
            CHMLoadingCell *cell =
                [tableView dequeueReusableCellWithIdentifier:[CHMLoadingCell identifier]];

            [cell.reloadButton addTarget:self
                                  action:@selector(reloadData)
                        forControlEvents:UIControlEventTouchUpInside];

            [cell setLoading:self.isLoading];

            return cell;
        }

        if (!self.comments.count) {
            CHMEmptyCommentCell *cell =
                [tableView dequeueReusableCellWithIdentifier:[CHMEmptyCommentCell identifier]];
            cell.commentsAllowed = self.post.commentsIsOn;
            return cell;
        }

        return [self commentCellAtIndexPath:indexPath];
    }

    return nil;
}

- (void)addTargetsOnCell:(CHMPostMainCell *)cell {
    //    [cell.actionButton addTarget:self
    //                          action:@selector(showMenu:)
    //                forControlEvents:UIControlEventTouchUpInside];

    [cell.likeView.upButton addTarget:self
                               action:@selector(likePost:)
                     forControlEvents:UIControlEventTouchUpInside];

    [cell.likeView.downButton addTarget:self
                                 action:@selector(unlikePost:)
                       forControlEvents:UIControlEventTouchUpInside];
    [cell.placeButton addTarget:self
                         action:@selector(showPlaceFeed)
               forControlEvents:UIControlEventTouchUpInside];
}

- (CHMCommentCell *)commentCellAtIndexPath:(NSIndexPath *)indexPath {
    CHMCommentCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:[CHMCommentCell identifier]];

    CHMComment *c = self.comments[indexPath.row];

    cell.delegate = self;

    cell.leftSwipeSettings.transition = MGSwipeStateSwippingRightToLeft;
    cell.rightSwipeSettings.transition = MGSwipeStateSwippingRightToLeft;
    cell.leftButtons = @[];
    if (!c.isOwn) {
        MGSwipeButton *reportButton =
            [MGSwipeButton buttonWithTitle:@""
                                      icon:[UIImage imageNamed:@"reportCyan"]
                           backgroundColor:[UIColor clearColor]
                                   padding:0];
        reportButton.buttonWidth = 58.0;
        MGSwipeButton *messageButton =
            [MGSwipeButton buttonWithTitle:@""
                                      icon:[UIImage imageNamed:@"messageCyan"]
                           backgroundColor:[UIColor clearColor]
                                   padding:0];
        messageButton.buttonWidth = 58.0;
        MGSwipeButton *replyButton =
            [MGSwipeButton buttonWithTitle:@""
                                      icon:[UIImage imageNamed:@"commentReply"]
                           backgroundColor:[UIColor clearColor]
                                   padding:0];
        replyButton.buttonWidth = 58.0;
        cell.rightButtons = @[ replyButton, reportButton, messageButton ];
        cell.leftSwipeSettings.transition = MGSwipeStateSwippingRightToLeft;
        cell.rightSwipeSettings.transition = MGSwipeStateSwippingRightToLeft;

    } else {
        MGSwipeButton *deleteButton =
            [MGSwipeButton buttonWithTitle:@""
                                      icon:[UIImage imageNamed:@"deleteComment"]
                           backgroundColor:[UIColor clearColor]
                                   padding:0];
        deleteButton.buttonWidth = 58.0;
        cell.rightButtons = @[ deleteButton ];
    }

    [cell.resendButton addTarget:self
                          action:@selector(resendComment:)
                forControlEvents:UIControlEventTouchUpInside];
    [cell.likeView.upButton addTarget:self
                               action:@selector(likeComment:)
                     forControlEvents:UIControlEventTouchUpInside];
    [cell.likeView.downButton addTarget:self
                                 action:@selector(unlikeComment:)
                       forControlEvents:UIControlEventTouchUpInside];

    cell.transform = self.tableView.transform;
    [cell layoutSubviews];
    [cell configureWithComment:c];

    return cell;
}

#pragma mark - float button delegate

- (void)plusButtonsViewWillShow:(LGPlusButtonsView *)plusButtonsView {
    [self setTextInputbarHidden:YES animated:YES];
}

- (void)plusButtonsViewWillHide:(LGPlusButtonsView *)plusButtonsView {
    if (self.post.commentsIsOn) {
        [self setTextInputbarHidden:NO animated:YES];
    }
}

- (void)plusButtonsView:(LGPlusButtonsView *)plusButtonsView
 buttonPressedWithTitle:(NSString *)title
            description:(NSString *)description
                  index:(NSUInteger)index {
    switch (index) {
        case 0:
            [self reportPostAction:nil];
            break;
        case 1:
            [self sharePost:nil];
            break;
        case 2:
            [self sendMessage:nil];
            break;
        default:
            break;
    }
}

#pragma mark - tableViewDelegate
// lots of magic numbers goes here=(
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 250.;
    } else {
        if (!self.comments) {
            return 60 + 16;
        }
        if (!self.comments.count) {
            return [UIScreen mainScreen].bounds.size.height - 250 - 100;
        }
        CHMComment *c = self.comments[indexPath.row];

        NSString *text = c.commentText;

        if (c.replyCommentID) {
            text = [text stringByAppendingString:@"  , "];  // reply avatar goes outside of comment
        }
        CGFloat height = [self.heightHelper heightOfText:text];
        CGFloat result = height + 32 + 15 + 8 + 4;

        if (result < 60 + 20 + 24) {
            result = 60 + 20 + 24;
        } else if (result > 480) {
            result = 480;
        }
        return result;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIImage *img = [self postImage];
        if (!img) {
            return;
        }
        CHMPhoto *p = [[CHMPhoto alloc] init];
        p.image = img;

        NYTPhotosViewController *photosViewController =
            [[NYTPhotosViewController alloc] initWithPhotos:@[ p ]];
        [self presentViewController:photosViewController animated:YES completion:nil];
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        if ([cell isKindOfClass:[MGSwipeTableCell class]]) {
            MGSwipeTableCell *c = (MGSwipeTableCell *)cell;

            [c showSwipe:MGSwipeDirectionRightToLeft animated:YES];
        }
    }
}

- (UIImage *)postImage {
    if (self.post.imgUrl) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
        CHMPostMainCell *c = [self.tableView cellForRowAtIndexPath:ip];

        if (c && [c isKindOfClass:[CHMPostMainCell class]] && c.mainImageView.image) {
            return c.mainImageView.image;
        }
    }

    return nil;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
}

#pragma mark - UITextViewDelegate Methods

- (BOOL)textView:(SLKTextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
    return [super textView:textView shouldChangeTextInRange:range replacementText:text];
}

#pragma mark - swipe delegate

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell
   tappedButtonAtIndex:(NSInteger)index
             direction:(MGSwipeDirection)direction
         fromExpansion:(BOOL)fromExpansion {
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];

    if (!ip) {
        return YES;
    }
    if (direction != MGSwipeDirectionRightToLeft) {
        return YES;
    }

    CHMComment *comment = self.comments[ip.row];

    if (comment.isOwn) {
        [self deleteComment:cell];
        return YES;
    }

    switch (index) {
        case 0:
            [self replyCommentSender:cell];
            break;
        case 1:
            [self reportCommentAction:cell];
            break;
        case 2:
            [self showMessengerForCommentCell:cell];
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - loading

- (void)reloadData {
    [[CHMServerBase shared] getPostWithID:self.post.postID
                               completion:^(CHMPost *post, NSError *error, NSInteger statusCode) {
                                   [self.refreshControl endRefreshing];
                                   if (!error) {
                                       [self configureWithPost:post];
                                       [self configureTextView];
                                   } else {
                                       [self showNoInternetVC];
                                   }
                               }];
    [self loadComments];
}

- (void)loadComments {
    //    NSLog(@"%@", [NSThread callStackSymbols]);
    if (!self.post.postID) {
        [self.tableView.bottomRefreshControl endRefreshing];
        return;
    }

    self.isLoading = YES;
    [self.tableView reloadData];
    [[CHMServerBase shared]
        getCommentsForPostWithID:self.post.postID
                           count:-1
                          offset:0
                      completion:^(NSMutableArray *result, NSError *err, NSInteger statusCode) {
                          self.isLoading = NO;

                          if (result) {
                              self.comments = result;
                              [self.tableView reloadData];

                              [self tryShowMessangerButton];
                          } else {
                              [self.tableView reloadData];
                          }

                          [self.tableView.bottomRefreshControl endRefreshing];

                      }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////UI//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ui

- (void)configureUI {
    [self configureTableView];
    [self configureMoreButton];
    [self configureRefreshControls];
}

- (void)configureMoreButton {
    UIButton *b = [self addRightButtonWithName:@"moreIcon"];
    [b addTarget:self action:@selector(showButtons) forControlEvents:UIControlEventTouchUpInside];
    self.buttonWorker = [[CHMFloatButtonWorker alloc] initWithTableView:self.tableView];
    [self updateFloatButton];
}

- (void)updateFloatButton {
    self.buttonWorker.canShowMessageButton = !self.post.isOwn;
    [self.buttonWorker configureFloatButton];
    self.buttonWorker.plusButtonsViewExample.delegate = self;
}

- (void)configureTableView {
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundView.backgroundColor = [UIColor lightBackgroundColor];
    self.tableView.backgroundColor = [UIColor lightBackgroundColor];
}

- (void)configureRefreshControls {
    UIRefreshControl *refreshContol = [[UIRefreshControl alloc] init];
    [refreshContol addTarget:self
                      action:@selector(reloadData)
            forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshContol];

    self.refreshControl = refreshContol;
    self.refreshControl.layer.zPosition -= 1;

    UIRefreshControl *bottomRefresh = [[UIRefreshControl alloc] init];
    bottomRefresh.triggerVerticalOffset = 50.;
    self.tableView.bottomRefreshControl = bottomRefresh;
    [bottomRefresh.superview sendSubviewToBack:bottomRefresh];
    bottomRefresh.layer.zPosition = -1;
}

#pragma mark - action
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////ACTION//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)showPlaceFeed {
    CHMPlace *place = self.post.place;
    if (!place.placeName) {
        return;
    }
    Router *r = [Router new];
    [r showPlaceFeedWithPlace:place];
}

- (void)showButtons {
    [self.buttonWorker buttonAction];
}

#pragma mark - reply
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////REPLY///////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)replyCommentSender:(UITableViewCell *)cell {
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];

    if (!ip)
        return;
    CHMComment *comment = self.comments[ip.row];
    self.replyComment = comment;
    CHMAvatarProvider *ap = comment.avatarProvider;
    UIFont *font = self.textView.font;
    NSDictionary *attrsDictionary =
        [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CHMAvatarImageGenerator *imgGenerator =
        [[CHMAvatarImageGenerator alloc] initWithAvatarProvider:ap];

    UIImage *img = [imgGenerator imageWithHeight:17.];

    NSMutableAttributedString *attrStringWithImage =
        [imgGenerator attrStringWithImage:img].mutableCopy;

    attrStringWithImage = [imgGenerator appendCommaToString:attrStringWithImage];
    [attrStringWithImage addAttributes:attrsDictionary
                                 range:NSMakeRange(0, attrStringWithImage.length)];

    self.textView.attributedText = attrStringWithImage;
}

- (CHMComment *)userReplyComment {
    if (!self.replyComment) {
        return nil;
    }
    NSAttributedString *attrString = self.textView.attributedText;
    NSRange range = NSMakeRange(0, 1);

    if ([attrString containsAttachmentsInRange:range]) {  // redo
        return self.replyComment;
    } else {
        return nil;
    }
}

#pragma mark - onboarding
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////Onboarding//////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tryShowMessangerButton {
    if (self.isShowedMessagerCell) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       for (int i = 0; i < self.comments.count; i++) {
                           CHMComment *comment = self.comments[i];
                           if (!comment.isOwn) {
                               NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:1];

                               CHMCommentCell *cell = [self.tableView cellForRowAtIndexPath:ip];
                               if (cell) {
                                   [cell showSwipe:MGSwipeDirectionRightToLeft animated:YES];
                                   self.isShowedMessagerCell = YES;
                                   [[NSUserDefaults standardUserDefaults]
                                       setBool:YES
                                        forKey:kCHMDidShowedMessangerCell];
                                   break;
                               }
                           }
                       }
                   });
}

#pragma mark - messenger
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////Messenger///////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)sendMessage:(UIButton *)sender {
    [self showMessengerForCommentID:nil];
}

- (void)showMessengerForCommentCell:(UITableViewCell *)sender {
    NSIndexPath *ip = [self.tableView indexPathForCell:sender];
    if (!ip)
        return;
    CHMComment *comment = self.comments[ip.row];

    [self showMessengerForCommentID:comment.commentID];
}

- (void)showMessengerForCommentID:(nullable NSString *)commentID {
    if (self.post.postID) {
        [Answers logCustomEventWithName:@"messager open"
                       customAttributes:@{
                           @"post_id" : self.post.postID
                       }];
        [[Router new] showMessangerWithPostID:self.post.postID commentID:commentID];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////REPORT//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - report

- (void)reportPost:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[CHMServerBase shared]
        reportPostWithID:self.post.postID
              completion:^(NSError *error, NSInteger statusCode) {
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                  if (!error) {
                      [self showSuccessWithText:NSLocalizedString(@"Жалоба "
                                                                  @"отправлена!",
                                                                  @"post")];
                  }
              }];
}

- (void)reportComment:(UITableViewCell *)sender {
    NSIndexPath *ip = [self.tableView indexPathForCell:sender];

    if (!ip)
        return;
    CHMComment *comment = self.comments[ip.row];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[CHMServerBase shared]
        reportCommentWithID:comment.commentID
                 completion:^(NSError *error, NSInteger statusCode) {
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     if (!error) {
                         [self showSuccessWithText:NSLocalizedString(@"Жалоба "
                                                                     @"отправлена!",
                                                                     @"post")];
                     }
                 }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////DELETE//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - delete

- (void)deleteComment:(UITableViewCell *)sender {
    NSIndexPath *ip = [self.tableView indexPathForCell:sender];

    if (!ip)
        return;
    CHMComment *comment = self.comments[ip.row];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[CHMServerBase shared]
        deleteCommentWithID:comment.commentID
                 completion:^(NSError *error, NSInteger statusCode) {
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     if (!error) {
                         [self showSuccessWithText:NSLocalizedString(@"Удалено!", @"post")];
                         comment.commentText = @"Удалено";
                         [self.tableView reloadRowsAtIndexPaths:@[ ip ]
                                               withRowAnimation:UITableViewRowAnimationAutomatic];
                     }
                 }];
}

- (void)deletePost {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[CHMServerBase shared]
        deletePostWithID:self.post.postID
              completion:^(NSError *error, NSInteger statusCode) {
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                  if (!error) {
                      [self showSuccessWithText:NSLocalizedString(@"Удалено!", @"post")];

                      self.post.text = @"Удалено";
                      self.originalPost.text = @"Удалено";
                      NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];

                      [self.tableView reloadRowsAtIndexPaths:@[ ip ]
                                            withRowAnimation:UITableViewRowAnimationAutomatic];
                  }
              }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////COMMENTS////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - comments
#pragma mark - comment action

- (void)sendComment:(CHMComment *)comment {
    comment.isSending = YES;
    comment.isSended = NO;
    comment.isOwn = YES;
    NSIndexPath *ip =
        [NSIndexPath indexPathForRow:[self.comments indexOfObject:comment] inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[ ip ]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    NSString *postID = self.post.postID;  // redo
    [[CHMServerBase shared] pubComment:comment
                          inPostWithID:postID
                            completion:^(CHMComment *com, NSError *error, NSInteger statusCode) {

                                comment.isSending = NO;
                                if (com) {
                                    comment.isSended = YES;
                                    comment.commentID = com.commentID;
                                    comment.date = com.date;
                                    comment.avatarProvider = com.avatarProvider;
                                } else {
                                    comment.isSended = NO;
                                }
                                [self.tableView
                                    reloadRowsAtIndexPaths:@[ ip ]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                            }];
}

- (void)resendComment:(UIButton *)sender {
    CHMCommentCell *cell = (CHMCommentCell *)[self parentCellForView:sender];

    if (cell) {
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];

        CHMComment *comment = self.comments[ip.row];

        [self sendComment:comment];
    }
}

// for choosing action is user is admin
- (void)reportCommentAction:(UITableViewCell *)sender {
    if ([[CHMCurrentUserManager shared] canDeletePostInPlaceWithID:self.post.place.placeID]) {
        [self deleteComment:sender];
    } else {
        [self reportComment:sender];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////LIKES///////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - likes

#pragma mark - like post
- (void)likePost:(UIButton *)sender {
    NSIndexPath *ip = [self indexPathForSender:sender];

    if (!ip) {
        return;
    }

    [self.likeHelper likePost:self.post atIndexPath:ip];
}

- (void)unlikePost:(UIButton *)sender {
    NSIndexPath *ip = [self indexPathForSender:sender];
    if (!ip) {
        return;
    }
    [self.likeHelper unlikePost:self.post atIndexPath:ip];
}

#pragma mark - like comment

- (void)likeComment:(UIButton *)sender {
    NSIndexPath *ip = [self indexPathForSender:sender];
    if (!ip)
        return;
    CHMComment *comment = self.comments[ip.row];
    [self.likeHelper likeComment:comment atIndexPath:ip];
}

- (void)unlikeComment:(UIButton *)sender {
    NSIndexPath *ip = [self indexPathForSender:sender];
    if (!ip)
        return;
    CHMComment *comment = self.comments[ip.row];
    [self.likeHelper unlikeComment:comment atIndexPath:ip];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////OTHERS//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - override

- (void)configureCells {
    [self.tableView registerNib:[CHMPostMainCell nib]
         forCellReuseIdentifier:[CHMPostMainCell identifier]];
    [self.tableView registerNib:[CHMCommentCell nib]
         forCellReuseIdentifier:[CHMCommentCell identifier]];
    [self.tableView registerNib:[CHMEmptyCommentCell nib]
         forCellReuseIdentifier:[CHMEmptyCommentCell identifier]];
    [self.tableView registerNib:[CHMLoadingCell nib]
         forCellReuseIdentifier:[CHMLoadingCell identifier]];
}

#pragma mark - lazy

- (CHMTextHeightHelper *)heightHelper {
    if (!_heightHelper) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 60 - 32 - 30 - 16 - 16;
        _heightHelper = [[CHMTextHeightHelper alloc] initWithTextWidth:width];
    }
    return _heightHelper;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////override////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - override

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

@end
