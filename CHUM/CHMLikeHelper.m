//
//  CHMLikeHelper.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMLikeHelper.h"
#import "CHMPostCell.h"
#import "CHMLikeView.h"
#import "CHMLikeStatus.h"
#import "CHMPost.h"
#import "CHMServerBase+PostLoader.h"
#import "CHMComment.h"
#import "CHMCommentCell.h"

@import Crashlytics;
@import Fabric;
@implementation CHMLikeHelper



- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
    }
    return self;
}


//- (void)updateCellAtIndexPAth:(NSIndexPath *)ip {
//    [self.tableView beginUpdates];
//    [self.tableView reloadRowsAtIndexPaths:@[ ip ] withRowAnimation:UITableViewRowAnimationAutomatic];
//    
//    [self.tableView endUpdates];
//    [self.tableView reloadRowsAtIndexPaths:@[ ip ]
//                               withRowAnimation:UITableViewRowAnimationAutomatic];
//}


- (void)updateCellAtIndexPath:(NSIndexPath *)ip withLikeStatus:(CHMLikeStatus *)likeStatus {
    
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
    
    
    if(!cell) {
        return;
    }
    
    
    if([cell respondsToSelector:@selector(likeView)]) {
        id c = cell;
        CHMLikeView *lv = [c likeView];
        
        [lv configureWithLikeStatus:likeStatus];
    }
    
}


- (void)likePost:(CHMPost *)post atIndexPath:(NSIndexPath *)ip {
    if (!ip || !post || !self.tableView) {
        return;
    }
    
    [Answers logCustomEventWithName:@"post liked" customAttributes:nil];
    
    [self likeLikeStatus:post.likeStatus];
    
    [self updateCellAtIndexPath:ip withLikeStatus:post.likeStatus];
    
    [[CHMServerBase shared]
     likePostWithID:post.postID
     completion:^(NSNumber *likeCount, NSError *error, NSInteger statusCode) {
         
         if(!self.tableView) {
             return ;
         }
         
         if (!error) {
             post.likeStatus.likeCount = likeCount.integerValue;
         } else {
             [self unlikeLikeStatus:post.likeStatus];
         }
         [self updateCellAtIndexPath:ip withLikeStatus:post.likeStatus];
         
     }];
}


- (void)unlikePost:(CHMPost *)post atIndexPath:(NSIndexPath *)ip {
    
    if (!ip || !post || !self.tableView) {
        return;
    }
    [Answers logCustomEventWithName:@"post unliked" customAttributes:nil];
    [self unlikeLikeStatus:post.likeStatus];
    [self updateCellAtIndexPath:ip withLikeStatus:post.likeStatus];
    
    [[CHMServerBase shared]
     unlikePostWithID:post.postID
     completion:^(NSNumber *likeCount, NSError *error, NSInteger statusCode) {
         if(!self.tableView) {
             return ;
         }
         if (!error) {
             post.likeStatus.likeCount = likeCount.integerValue;
         } else {
             [self likeLikeStatus:post.likeStatus];
             
         }
         [self updateCellAtIndexPath:ip withLikeStatus:post.likeStatus];
         
     }];
}


#pragma mark - comment

- (void)likeComment:(CHMComment *)comment atIndexPath:(NSIndexPath *)ip {
    if (!ip || !comment || !self.tableView) {
        return;
    }
    [Answers logCustomEventWithName:@"comment liked" customAttributes:nil];
    [self likeLikeStatus:comment.likeStatus];
    
    [self updateCellAtIndexPath:ip withLikeStatus:comment.likeStatus];
    
    [[CHMServerBase shared]
     likeCommnetWithID:comment.commentID
     completion:^(NSNumber *likeCount, NSError *error, NSInteger statusCode) {
         if(!self.tableView) {
             return ;
         }
         if (!error) {
             comment.likeStatus.likeCount = likeCount.integerValue;
         } else {
             [self unlikeLikeStatus:comment.likeStatus];
         }
         [self updateCellAtIndexPath:ip withLikeStatus:comment.likeStatus];
         
     }];
}

- (void)unlikeComment:(CHMComment *)comment atIndexPath:(NSIndexPath *)ip {
    if (!ip || !comment || !self.tableView) {
        return;
    }
    [Answers logCustomEventWithName:@"comment unliked" customAttributes:nil];
    [self unlikeLikeStatus:comment.likeStatus];
    [self updateCellAtIndexPath:ip withLikeStatus:comment.likeStatus];
    
    [[CHMServerBase shared]
     unlikeCommnetWithID:comment.commentID
     completion:^(NSNumber *likeCount, NSError *error, NSInteger statusCode) {
         if(!self.tableView) {
             return ;
         }
         if (!error) {
             comment.likeStatus.likeCount = likeCount.integerValue;
         } else {
             [self likeLikeStatus:comment.likeStatus];
             
         }
         [self updateCellAtIndexPath:ip withLikeStatus:comment.likeStatus];
         
     }];

}


#pragma mark - common


- (void)likeLikeStatus:(CHMLikeStatus *)status {
    if(status.likeType == CHMLikeTypeNone) {
        status.likeCount+=1;
        status.likeType = CHMLikeTypePositive;
    } else if (status.likeType == CHMLikeTypeNegative) {
        status.likeCount+=1;
        status.likeType = CHMLikeTypeNone;
    } else {
        return;
    }
}

- (void)unlikeLikeStatus:(CHMLikeStatus *)status {
    if(status.likeType == CHMLikeTypeNone) {
        status.likeCount-=1;
        status.likeType = CHMLikeTypeNegative;
    } else if (status.likeType == CHMLikeTypePositive) {
        status.likeCount-=1;
        status.likeType = CHMLikeTypeNone;
    } else {
        return;
    }
}





@end
