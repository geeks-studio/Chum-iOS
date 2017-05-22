//
//  CHMPostProtocol.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHMPost;

@protocol CHMPostProtocol <NSObject>

- (void)configureWithPost:(CHMPost *)post;

@end
