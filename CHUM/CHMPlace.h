//
//  CHMPlace.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 11/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHMPlace : NSObject

@property (strong, nonatomic) NSString *placeID;
@property (strong, nonatomic) NSString *placeName;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lon;

@property (strong, nonatomic) NSArray *tags;

@property (assign, nonatomic) BOOL isAdmin;

@property (strong, nonatomic, nullable) NSURL *placeURL;

@property (assign, nonatomic) BOOL isChoosed;


@end
