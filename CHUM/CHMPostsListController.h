//
//  CHMPostsListController.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMBaseTVC.h"
#import "CHMCanBeReloaded.h"
//#import "XLButtonBarPagerTabStripViewController.h"

@import XLPagerTabStrip;

extern NSString *const CHMPostsListControllerID;

typedef NS_ENUM(NSInteger, CHMFeedType) {
    CHMFeedTypeNone = 0,
    CHMFeedTypeNear,
    CHMFeedTypePlaces,
    CHMFeedTypeUser,
    CHMFeedTypeFavorite,
    CHMFeedTypeOnePlace
};

@class CHMPostsListController;
@class CHMPost;
@class CHMPlace;
@protocol CHMPostsListControllerDelegate <NSObject>
- (void)postListController:(CHMPostsListController *)sender didSelectPost:(CHMPost *)post;
@end

@interface CHMPostsListController : UIViewController <XLPagerTabStripChildItem,
                                                      CHMCanBeReloaded,
                                                      UITableViewDelegate,
                                                      UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) CHMFeedType feedType;
@property (nonatomic, weak) id<CHMPostsListControllerDelegate> delegate;
@property (strong, nonatomic) NSString *controllerName;
@property (strong, nonatomic) CHMPlace *place;


- (void)loadPosts;

- (void)configureWithPosts:(NSArray *)posts;

@end
