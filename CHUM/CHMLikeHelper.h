//
//  CHMLikeHelper.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CHMPost;
@class CHMComment;
@interface CHMLikeHelper : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) UITableView *tableView;

- (void)likePost:(CHMPost *)post atIndexPath:(NSIndexPath *)ip;
- (void)unlikePost:(CHMPost *)post atIndexPath:(NSIndexPath *)ip;

- (void)likeComment:(CHMComment *)comment atIndexPath:(NSIndexPath *)ip;
- (void)unlikeComment:(CHMComment *)comment atIndexPath:(NSIndexPath *)ip;


@end
