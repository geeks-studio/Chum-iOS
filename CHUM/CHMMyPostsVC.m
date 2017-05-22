//
//  CHMMyPostsVC.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 11/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMMyPostsVC.h"
#import "CHMPost.h"
#import "CHMPostDirectlyTVC.h"
#import "CHMPostsListController.h"
#import "CHMServerBase+CHMServerFeedLoader.h"
#import "UIColor+CHMProjectsColor.h"
#import "UIViewController+ZPPViewControllerCategory.h"
@interface CHMMyPostsVC () <CHMPostsListControllerDelegate>

@property (strong, nonatomic) NSArray *viewControllers;

@end

@implementation CHMMyPostsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setCustomNavigationBackButtonWithTransition];

    self.buttonBarView.shouldCellsFillAvailableWidth = YES;
    self.buttonBarView.leftRightMargin = 0;
    self.buttonBarView.selectedBarAlignment = XLSelectedBarAlignmentCenter;
    UICollectionViewFlowLayout *fl =
        (UICollectionViewFlowLayout *)self.buttonBarView.collectionViewLayout;
    fl.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"postsIcon"]];

    self.navigationItem.titleView = iv;
    self.view.backgroundColor = [UIColor lightBackgroundColor];
}


- (NSArray *)viewControllers {
    if (!_viewControllers) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        CHMPostsListController *left =
            [sb instantiateViewControllerWithIdentifier:CHMPostsListControllerID];
        CHMPostsListController *right =
            [sb instantiateViewControllerWithIdentifier:CHMPostsListControllerID];

        left.controllerName = NSLocalizedString(@"Мои", @"my posts");
        right.controllerName = NSLocalizedString(@"Активные", @"my posts");
        left.feedType = CHMFeedTypeUser;
        right.feedType = CHMFeedTypeFavorite;
        left.delegate = self;
        right.delegate = self;
        _viewControllers = @[ right, left ];
    }

    return _viewControllers;
}

- (NSArray *)childViewControllersForPagerTabStripViewController:
    (XLPagerTabStripViewController *)pagerTabStripViewController {
    return self.viewControllers;
}

- (void)postListController:(CHMPostsListController *)sender didSelectPost:(CHMPost *)post {
    CHMPostDirectlyTVC *vc = [[CHMPostDirectlyTVC alloc] init];
    [vc configureWithPost:post];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
