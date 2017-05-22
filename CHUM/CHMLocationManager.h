//
//  CHMLocationManager.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 15/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface CHMLocationManager : NSObject

@property (strong, nonatomic, nullable) CLLocation *lastCoordinate;

+ (instancetype)shared;

- (void)loadLocationCompletion:(void (^)(CLLocation * _Nullable currentLocation, NSError *_Nullable err))completion;

- (void)loadLocationSubscibe:(void (^)(CLLocation * _Nullable currentLocation, NSError * _Nullable err))completion;


- (NSNumber *)calulateDistanceToLat:(NSNumber *)lat lon:(NSNumber *)lon;

//- (BOOL)isLocationAllowed;

@end
