//
//  QZBMessagerVC.m
//  QZBQuizBattle
//
//  Created by Andrey Mikhaylov on 30/04/15.
//  Copyright (c) 2015 Andrey Mikhaylov. All rights reserved.
//

//#import <JSQMessagesViewController/JSQMessages.h>
//#import <NSDate+DateTools.h>
//#import <TSMessage.h>
//#import "PAAMessagerVC.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "CHMAvatarView.h"
#import "CHMCurrentUserManager.h"
#import "CHMNotificationCenter.h"
#import "CHMPost.h"
#import "CHMPostDirectlyTVC.h"
#import "CHMServerBase+CallLoader.h"
#import "CHUM-Swift.h"
#import "JSQMessagesToolbarContentView.h"
#import "PAAConversation.h"
#import "PAAMessage.h"
#import "PAAMessageManager.h"
#import "PAAMessagerVC.h"
#import "UIColor+CHMProjectsColor.h"
#import "UIViewController+ZPPViewControllerCategory.h"

@import SVPullToRefresh;
@import DateTools;
@import MBProgressHUD;
@import Crashlytics;
@import JSQMessagesViewController;

const NSTimeInterval QZBMessageTimeInterval = 600;

@interface PAAMessagerVC () <JSQMessagesCollectionViewDelegateFlowLayout>

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *notSendedeBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *sendingBubbleImageData;
@property (strong, nonatomic) PAAUserLite *user;
@property (strong, nonatomic) PAAConversation *conversation;
@property (strong, nonatomic) NSString *postID;
@property (strong, nonatomic) NSString *commentID;
@property (strong, nonatomic) CHMAvatarView *avatarView;
@property (strong, nonatomic) UIBarButtonItem *videCallButton;
@property (strong, nonatomic) TutorialWorker *tutorialWorker;

@end

@implementation PAAMessagerVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.collectionView.delegate = self;

    self.automaticallyScrollsToMostRecentMessage = YES;

    [self setCustomNavigationBackButtonWithTransition];
    [self configureBubbleFactorys];
    [self configureRefreshControl];
    [self configureAvatarView];
    [self configureMessangerButtons];

    self.senderId = [PAAMessage senderNameforIsSelf:YES];
    self.senderDisplayName = [PAAMessage senderNameforIsSelf:YES];

    [PAAMessageManager sharedInstance].messageRecieved = ^(PAAMessage *message) {
        if ([message.conversationID isEqualToString:self.conversation.conversationID]) {
            [self.conversation.messages addObject:message];
            [self finishReceivingMessage];
            [self readAllMessages];
            [self updateCallButtonOnIncomingMessage];
        }
    };

    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [self loadOldMessages:nil];
    }
                                                     direction:SVInfiniteScrollingDirectionTop];

    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView reloadData];
    [self scrollToBottomAnimated:NO];
    [self reloadConversation:nil];
    self.navigationController.navigationBar.topItem.title = @"";
    [self configureAvatar];
    [self configureButtons];
    [CHMNotificationCenter shared].inMessanger = YES;
    [[PAAMessageManager sharedInstance] connect];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self readAllMessages];
    [CHMNotificationCenter shared].inMessanger = NO;
    [[PAAMessageManager sharedInstance] disconnectWebSocket];
    self.navigationItem.rightBarButtonItems = nil;
    [self tryRemoveTutorial];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - configuration

- (void)configureBubbleFactorys {
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];

    self.outgoingBubbleImageData =
        [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor mainColor]];
    self.incomingBubbleImageData =
        [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor projectPinkColor]];
    self.notSendedeBubbleImageData =
        [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleRedColor]];
    self.sendingBubbleImageData =
        [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];

    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
}

- (void)configureWithConverstion:(PAAConversation *)conversation {
    self.conversation = conversation;

    [self.collectionView reloadData];
}

- (void)configureWithPostID:(NSString *)postID commentID:(NSString *)commentID {
    // redo

    self.postID = postID;
    self.commentID = commentID;

    [self reloadConversation:nil];
}

- (void)reloadConversation:(UIRefreshControl *)sender {
    [self updateChatForBlocked];

    if (self.conversation.conversationID) {
        [self loadCurrentConversation];
        [self loadNewestMessages:sender];

    } else if (self.postID) {
        [[PAAMessageManager sharedInstance]
            conversationForPostID:self.postID
                        commentID:self.commentID
                       completion:^(PAAConversation *conversation, NSError *err,
                                    NSInteger statusCode) {
                           [self updateChatForBlocked];
                           if (sender) {
                               [sender endRefreshing];
                           }
                           if (conversation) {
                               self.conversation = conversation;
                               [self loadNewestMessages:sender];
                               [self loadCurrentConversation];
                           }
                       }];
    }
}

- (void)loadCurrentConversation {
    [[PAAMessageManager sharedInstance]
        loadConversationWithID:self.conversation.conversationID
                    completion:^(PAAConversation *conversation, NSError *err,
                                 NSInteger statusCode) {

                        if (conversation) {
                            self.conversation.avatar = conversation.avatar;
                            self.conversation.postID = conversation.postID;
                            self.conversation.isBlocked = conversation.isBlocked;
                            self.conversation.opponentID = conversation.opponentID;
                            self.conversation.canUnblock = conversation.canUnblock;
                            self.conversation.canMakeCall = conversation.canMakeCall;
                            [self tryShowTutorial];
                            [self configureAvatar];
                            [self configureButtons];
                            [self updateChatForBlocked];
                        }
                    }];
}

- (void)loadOldMessages:(UIRefreshControl *)sender {
    if (!self.conversation.conversationID) {
        [self reloadConversation:sender];
        return;
    }

    PAAMessage *m = self.conversation.messages.firstObject;
    if (!m) {
        [self.collectionView.infiniteScrollingView stopAnimating];
        return;
    }
    [[PAAMessageManager sharedInstance]
        loadAllMessagesInConversation:self.conversation.conversationID
                           untillDate:m.date
                                count:20
                           completion:^(NSArray *messages, NSError *err, NSInteger statusCode) {

                               if (!messages) {
                                   [self.collectionView.infiniteScrollingView stopAnimating];
                                   return;
                               }
                               if (messages.count == 0) {
                                   self.collectionView.infiniteScrollingView.enabled = NO;
                               }
                               // ui updating magic goes here
                               [CATransaction begin];
                               [CATransaction setDisableActions:YES];
                               CGFloat oldOffset = self.collectionView.contentSize.height -
                                                   self.collectionView.contentOffset.y;

                               [self.collectionView performBatchUpdates:^{

                                   NSInteger lastIdx = messages.count - 1;
                                   NSMutableArray *indexPaths = [NSMutableArray array];

                                   for (int i = 0; i <= lastIdx; i++) {
                                       NSIndexPath *ip =
                                           [NSIndexPath indexPathForRow:i inSection:0];
                                       [indexPaths addObject:ip];
                                   }

                                   self.conversation.messages =
                                       [messages
                                           arrayByAddingObjectsFromArray:self.conversation.messages]
                                           .mutableCopy;
                                   [self sortMessages];

                                   [self.collectionView insertItemsAtIndexPaths:indexPaths];

                                   // invalidate layout
                                   [self.collectionView.collectionViewLayout
                                       invalidateLayoutWithContext:
                                           [JSQMessagesCollectionViewFlowLayoutInvalidationContext
                                               context]];

                               }
                                   completion:^(BOOL finished) {
                                       [self finishReceivingMessageAnimated:NO];
                                       [self.collectionView layoutIfNeeded];
                                       self.collectionView.contentOffset = CGPointMake(
                                           0, self.collectionView.contentSize.height - oldOffset);
                                       [CATransaction commit];
                                       [self.collectionView.infiniteScrollingView stopAnimating];
                                   }];
                           }];
}

- (void)loadNewestMessages:(UIRefreshControl *)sender {
    if (!self.conversation.conversationID) {
        [self reloadConversation:sender];
        return;
    }
    [[PAAMessageManager sharedInstance]
        loadAllMessagesInConversation:self.conversation.conversationID
                           untillDate:nil
                                count:20
                           completion:^(NSArray *messages, NSError *err, NSInteger statusCode) {
                               dispatch_async(dispatch_get_main_queue(), ^{

                                   self.conversation.messages = messages.mutableCopy;
                                   [self readAllMessages];

                                   [self reloadCollectionViewAnimated:YES];
                                   self.collectionView.infiniteScrollingView.enabled = YES;
                                   if (!sender) {
                                   } else {
                                       [sender endRefreshing];
                                   }
                               });
                           }];
}

- (void)reloadCollectionViewAnimated:(BOOL)animated {
    if (animated) {
        [UIView
            animateWithDuration:0
                     animations:^{
                         [self.collectionView performBatchUpdates:^{

                             [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                             self.collectionView.contentOffset =
                                 CGPointMake(0, MAX(-self.collectionView.contentInset.top,
                                                    self.collectionView.contentSize.height -
                                                        (self.collectionView.bounds.size.height -
                                                         self.collectionView.contentInset.bottom)));

                         }
                             completion:^(BOOL finished) {
                                 self.collectionView.contentOffset = CGPointMake(
                                     0, MAX(-self.collectionView.contentInset.top,
                                            self.collectionView.contentSize.height -
                                                (self.collectionView.bounds.size.height -
                                                 self.collectionView.contentInset.bottom)));

                             }];
                     }];
    } else {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        CGFloat collectionViewContentHeight = self.collectionView.contentSize.height;
        CGFloat collectionViewFrameHeightAfterInserts =
            self.collectionView.frame.size.height -
            (self.collectionView.contentInset.top + self.collectionView.contentInset.bottom);

        if (collectionViewContentHeight > collectionViewFrameHeightAfterInserts) {
            [self.collectionView
                setContentOffset:CGPointMake(0, self.collectionView.contentSize.height -
                                                    self.collectionView.frame.size.height)
                        animated:NO];
        }

        [CATransaction commit];
    }
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    if (!self.conversation.conversationID || text.length == 0) {
        return;
    }

    [Answers logCustomEventWithName:@"message sended" customAttributes:nil];
    PAAMessage *notSendedMessage = [self messageFromSelfWithText:text];
    [self.conversation.messages addObject:notSendedMessage];
    [self finishSendingMessage];
    [self sendMessage:notSendedMessage sender:button];
}

//- (void)didPressAccessoryButton:(UIButton *)sender {
//    [self showVideoView];
//}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView
       messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *messageView = [self messageAtIndexPath:indexPath];

    return messageView;
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self messageAtIndexPath:indexPath];

    PAAMessage *msg = self.conversation.messages[(NSUInteger)indexPath.row];
    if (msg.isSending && !msg.isSended) {
        return self.sendingBubbleImageData;
    }
    if (!msg.isSended && !msg.isSending) {
        return self.notSendedeBubbleImageData;
    }
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    return self.incomingBubbleImageData;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    NSInteger rows = (NSInteger)self.conversation.messages.count;
    return rows;
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell =
        (JSQMessagesCollectionViewCell *)[super collectionView:collectionView
                                        cellForItemAtIndexPath:indexPath];
    JSQMessage *msg = [self messageAtIndexPath:indexPath];

    if (!msg.isMediaMessage) {
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor whiteColor];
        } else {
            cell.textView.textColor = [UIColor whiteColor];
        }

        cell.textView.linkTextAttributes = @{
            NSForegroundColorAttributeName : cell.textView.textColor,
            NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid)
        };
    }

    return cell;
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
    didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath {
    PAAMessage *msg = self.conversation.messages[indexPath.row];
    if (!msg.isSended && !msg.isSending) {
        msg.isSending = YES;
        msg.isSended = NO;
        [self sendMessage:msg sender:nil];
        [self.collectionView reloadData];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - server methods

- (void)sendMessage:(PAAMessage *)notSendedMessage sender:(UIButton *)button {
    if (!self.conversation.conversationID) {
        [self reloadConversation:nil];
        return;
    }
    if (button) {
        button.enabled = NO;
    }
    [[PAAMessageManager sharedInstance]
         sendMessageWithText:notSendedMessage.text
        toConversationWithID:self.conversation.conversationID
                  completion:^(PAAMessage *msg, NSError *err, NSInteger statusCode) {
                      if (button) {
                          button.enabled = YES;
                      }
                      if (msg) {
                          notSendedMessage.isSended = YES;
                          notSendedMessage.isSending = NO;
                          notSendedMessage.date = msg.date;
                          notSendedMessage.messageID = msg.messageID;

                          if (!self.conversation) {
                              [self reloadConversation:nil];
                          }
                          [self.collectionView reloadData];
                      } else {
                          notSendedMessage.isSending = NO;
                          notSendedMessage.isSended = NO;
                      }
                      [self.collectionView reloadData];
                  }];
}

- (void)readAllMessages {
    if (self.conversation.messages.count > 0) {
        BOOL flag = NO;
        for (PAAMessage *m in self.conversation.messages) {
            if (!m.messageID || m.isRead || m.isOwn) {
                continue;
            } else {
                m.isRead = YES;
                flag = YES;
            }
        }
        if (!flag) {
            return;
        }

        [[PAAMessageManager sharedInstance]
            readAllMessagesInConversation:self.conversation.conversationID
                               completion:^(NSError *err, NSInteger statusCode) {
                                   [[PAAMessageManager sharedInstance] updateUnreadCountEverywhere];
                               }];
    }
}

#pragma mark - support methods

- (PAAMessage *)messageFromSelfWithText:(NSString *)text {
    PAAMessage *msg = [[PAAMessage alloc] init];
    msg.text = text;
    msg.userID = [CHMCurrentUserManager shared].token;
    msg.isSending = YES;
    msg.isSended = NO;
    msg.isOwn = YES;
    msg.date = [NSDate new];

    return msg;
}

- (void)configureAvatar {
    if (self.conversation.avatar) {
        [self.avatarView configureWithAvatarProvider:self.conversation.avatar];
    }
}

- (JSQMessage *)messageAtIndexPath:(NSIndexPath *)path {
    if (self.conversation.messages.count <= path.row) {
        JSQMessage *messageView =
            [JSQMessage messageWithSenderId:self.senderId displayName:self.senderId text:@""];
        return messageView;
    }

    PAAMessage *m = self.conversation.messages[(NSUInteger)path.row];

    NSString *senderID = m.userID;  // redo

    // redo
    JSQMessage *messageView =
        [JSQMessage messageWithSenderId:senderID displayName:senderID text:m.text];

    return messageView;
}

- (void)sortMessages {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [self.conversation.messages sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

#pragma mark - call

- (void)showCallScreen {
    if (![self canMakeCall]) {
        return;
    }

    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[CHMServerBase shared]
        getInterlocutorNameForConversationWithID:self.conversationID
                                      completion:^(NSString *_Nullable opponenName,
                                                   NSError *_Nullable error, NSInteger statusCode) {
                                          [MBProgressHUD
                                              hideHUDForView:self.navigationController.view
                                                    animated:YES];
                                          if (error) {
                                              [self showWarningWithText:@"Ошибка связи"];
                                              return;
                                          }
                                          if (opponenName) {
                                              self.conversation.opponentID = opponenName;
                                              [self showVideoCallController];
                                          } else {
                                              [self showWarningWithText:@"Пользователь "
                                                                        @"оффлайн"];
                                          }
                                      }];
}

- (BOOL)canMakeCall {
    return self.conversation.canMakeCall && self.conversationID;
}

#pragma mark - ui

- (void)updateCallButtonOnIncomingMessage {
    if (self.conversation.canMakeCall) {
        return;
    }
    self.conversation.canMakeCall = YES;
    [self tryShowTutorial];
    [self configureButtons];
}

- (void)configureAvatarView {
    self.avatarView = [[CHMAvatarView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.navigationItem.titleView = self.avatarView;
    self.navigationItem.titleView.backgroundColor = [UIColor clearColor];
}

- (void)configureRefreshControl {
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.triggerVerticalOffset = 50.;
    refreshControl.tintColor = [UIColor lightBackgroundColor];
    [refreshControl addTarget:self
                       action:@selector(loadNewestMessages:)
             forControlEvents:UIControlEventValueChanged];
    self.collectionView.bottomRefreshControl = refreshControl;
}

- (void)configureButtons {
    UIButton *more = [self buttonWithImageName:@"moreIcon"];
    UIBarButtonItem *moreBarItem = [[UIBarButtonItem alloc] initWithCustomView:more];

    NSMutableArray *buttons = @[ moreBarItem ].mutableCopy;

    if (self.conversation.canMakeCall) {
        UIButton *camera = [self buttonWithImageName:@"cameraCall"];
        [camera addTarget:self
                      action:@selector(showCallScreen)
            forControlEvents:UIControlEventTouchUpInside];
        self.videCallButton = [[UIBarButtonItem alloc] initWithCustomView:camera];
        [camera addTarget:self
                      action:@selector(showCallScreen)
            forControlEvents:UIControlEventTouchUpInside];

        [buttons addObject:self.videCallButton];
    }

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithArray:buttons];

    [more addTarget:self
                  action:@selector(showActionSheet)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureMessangerButtons {
    [self configureLeftButton];
    [self.inputToolbar.contentView.rightBarButtonItem setTitleColor:[UIColor mainColor]
                                                           forState:UIControlStateNormal];
}

- (void)configureLeftButton {
    self.inputToolbar.contentView.leftBarButtonItem = nil;
}

- (void)updateChatForBlocked {
    BOOL isBlocked = self.conversation.isBlocked;

    JSQMessagesComposerTextView *tv = self.inputToolbar.contentView.textView;
    NSString *placeHolderText = nil;
    if (isBlocked) {
        placeHolderText = @"Чат заблокирован";
        tv.text = @"";
    } else {
        placeHolderText = @"Сообщение";
    }
    tv.placeHolder = placeHolderText;
    tv.editable = !isBlocked;
    self.videCallButton.enabled = !isBlocked;
}

#pragma mark - chat actions

- (void)showActionSheet {
    [self.view endEditing:YES];
    UIAlertController *as =
        [UIAlertController alertControllerWithTitle:@"Действия"
                                            message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Перейти к записи"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                            [self showPost];
                                                        }];
    NSString *title = @"";
    UIAlertActionStyle style;

    if (self.conversation.isBlocked) {
        title = @"Разблокировать";
        style = UIAlertActionStyleDefault;
    } else {
        title = @"Заблокировать";
        style = UIAlertActionStyleDestructive;
    }
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:title
                                                           style:style
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             [self blockUnblockAction];
                                                         }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action){
                                                         }];
    [as addAction:firstAction];

    BOOL canUnblock = self.conversation.canUnblock && self.conversation.canUnblock.boolValue;

    if (!self.conversation.isBlocked || canUnblock) {
        [as addAction:secondAction];
    }
    [as addAction:cancelAction];

    [self presentViewController:as animated:YES completion:nil];
}

- (void)blockUnblockAction {
    if (!self.conversation.conversationID) {
        return;
    }
    if (self.conversation.isBlocked) {
        [self unblockChat];
    } else {
        [self blockChat];
    }
}

- (void)unblockChat {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[PAAMessageManager sharedInstance]
        unBlockConversationWithID:self.conversation.conversationID
                       completion:^(NSError *err, NSInteger statusCode) {
                           [MBProgressHUD hideAllHUDsForView:self.navigationController.view
                                                    animated:YES];
                           if (!err) {
                               [self showSuccessWithText:@"Разблокированно!"];
                               self.conversation.isBlocked = NO;
                               [self updateChatForBlocked];
                           }
                       }];
}

- (void)blockChat {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[PAAMessageManager sharedInstance]
        blockConversationWithID:self.conversation.conversationID
                     completion:^(NSError *err, NSInteger statusCode) {
                         [MBProgressHUD hideAllHUDsForView:self.navigationController.view
                                                  animated:YES];
                         if (!err) {
                             [self showSuccessWithText:@"Заблокированно!"];
                             self.conversation.isBlocked = YES;
                             [self updateChatForBlocked];
                         }
                     }];
}

#pragma mark - Navigation

- (void)showPost {
    if (!self.conversation.postID) {
        [self loadCurrentConversation];
        return;
    }
    Router *r = [Router new];
    [r showPostWithID:self.conversation.postID];
}

- (void)showVideoCallController {
    if (!self.conversation.opponentID || !self.conversationID || !self.conversation.canMakeCall) {
        return;
    }
    Router *router = [[Router alloc] init];
    [router showCallControllerWithID:self.conversation.opponentID
                      conversationID:self.conversationID];
}

#pragma mark - override

- (NSString *)conversationID {
    return self.conversation.conversationID;
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

#pragma mark - tutorial

- (void)tryShowTutorial {
    static NSString *kCHMVideoCallTutorialKey = @"kCHMVideoCallTutorialKey";
    BOOL showed = [[NSUserDefaults standardUserDefaults] boolForKey:kCHMVideoCallTutorialKey];
    if (showed) {
        return;
    }

    if (!self.conversation.canMakeCall || self.tutorialWorker) {
        return;
    }

    [self.view endEditing:YES];

    CGFloat y = self.navigationController.navigationBar.frame.size.height + 20;
    CGSize s = [UIScreen mainScreen].bounds.size;
    CGRect backR = CGRectMake(0, y, s.width, s.height);

    self.tutorialWorker = [[TutorialWorker alloc] init];
    UIView *tutorialView = [self.tutorialWorker
        generateTutorialViewForNavBarWithTitle:@"Стань ближе!"
                                          text:@"Стань ближе с людьми, "
                                               @"которые "
                                               @"тебе "
                                               @"понравились! Видеозвонки "
                                               @"помогут "
                                               @"открыться "
                                               @"тем, кто этого заслуживает!"
                                        offset:s.width - 50 - 30
                                     backFrame:backR];

    [self.navigationController.view addSubview:tutorialView];
    [self.tutorialWorker showView];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kCHMVideoCallTutorialKey];
}

- (void)tryRemoveTutorial {
    if ([self.tutorialWorker canRemoveFromSuperView]) {
        [self.tutorialWorker removeBackView];
    }
}

@end
