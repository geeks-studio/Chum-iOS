//
//  CHMLocationManager.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 15/02/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMLocationManager.h"

NSString *const CHMLocationManagerErrorDomain = @"CHMLocationManagerErrorDomain";

//-1 time out
//-2 failed

@import INTULocationManager;

@implementation CHMLocationManager

+ (instancetype)shared {
    static CHMLocationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CHMLocationManager alloc] init];
    });
    return sharedInstance;
}

- (void)loadLocationCompletion:(void (^)(CLLocation *currentLocation, NSError *err))completion {
    
    if ([INTULocationManager locationServicesState] != INTULocationServicesStateAvailable) {
        NSError *failedError = [NSError
                                errorWithDomain:
                                CHMLocationManagerErrorDomain
                                code:INTULocationStatusError
                                userInfo:nil];
        
        if (completion) {
            completion(nil, failedError);
        }
        
        return;
    }

    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                       timeout:10.0
                          delayUntilAuthorized:YES
                                         block:^(CLLocation *currentLocation,
                                                 INTULocationAccuracy achievedAccuracy,
                                                 INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 if (completion) {
                                                     completion(currentLocation, nil);
                                                 }

                                                 self.lastCoordinate = currentLocation;
                                                 // Request succeeded, meaning achievedAccuracy is
                                                 // at least the requested accuracy, and
                                                 // currentLocation contains the device's current
                                                 // location.
                                             } else if (status == INTULocationStatusTimedOut) {
                                                 // Wasn't able to locate the user with the
                                                 // requested accuracy within the timeout interval.
                                                 // However, currentLocation contains the best
                                                 // location available (if any) as of right now,
                                                 // and achievedAccuracy has info on the
                                                 // accuracy/recency of the location in
                                                 // currentLocation.

                                                 NSError *timedOutError = [NSError
                                                     errorWithDomain:CHMLocationManagerErrorDomain
                                                                code:-1
                                                            userInfo:nil];
                                                 if (completion) {
                                                     completion(nil, timedOutError);
                                                 }
                                             } else {
                                                 NSError *failedError = [NSError
                                                     errorWithDomain:CHMLocationManagerErrorDomain
                                                                code:status
                                                            userInfo:nil];

                                                 if (completion) {
                                                     completion(nil, failedError);
                                                 }
                                                 // An error occurred, more info is available by
                                                 // looking at the specific status returned.
                                             }
                                         }];
}




- (void)loadLocationSubscibe:(void (^)(CLLocation *currentLocation, NSError *err))completion {
    
    
    if ([INTULocationManager locationServicesState] != INTULocationServicesStateAvailable) {
        NSError *failedError = [NSError
                                errorWithDomain:
                                CHMLocationManagerErrorDomain
                                code:INTULocationStatusError
                                userInfo:nil];
        
        if (completion) {
            completion(nil, failedError);
        }
        return;

    }
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    
    
    
    INTULocationRequestID locID = [locMgr subscribeToLocationUpdatesWithDesiredAccuracy:INTULocationAccuracyHouse
                                                    block:^(CLLocation *currentLocation,
                                                            INTULocationAccuracy achievedAccuracy,
                                                            INTULocationStatus status) {
                                                        if (status == INTULocationStatusSuccess) {
                                                            // A new updated location is available
                                                            // in currentLocation, and
                                                            // achievedAccuracy
                                                            // indicates how accurate this
                                                            // particular location is.

                                                            if (completion) {
                                                                completion(currentLocation, nil);
                                                            }

                                                            self.lastCoordinate = currentLocation;
                                                        } else {
                                                            NSError *failedError = [NSError
                                                                errorWithDomain:
                                                                    CHMLocationManagerErrorDomain
                                                                           code:status
                                                                       userInfo:nil];

                                                            if (completion) {
                                                                completion(nil, failedError);
                                                            }
                                                            // An error occurred, more info is
                                                            // available by looking at the specific
                                                            // status
                                                            // returned. The subscription has been
                                                            // kept alive.
                                                        }
                                                    }];
    
//    NSLog(@"request subscribe id %@", @(locID));
}

- (NSNumber *)calulateDistanceToLat:(NSNumber *)lat lon:(NSNumber *)lon {
    
    if(!lat || !lon) {
        return nil;
    }
    
    if(!self.lastCoordinate) {
        return @(-1);
    }
    
//    CLLocationCoordinate2D c = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
    
    CLLocation *curentLocation = self.lastCoordinate;
    CLLocation *l = [[CLLocation alloc] initWithLatitude:lat.doubleValue
                                               longitude:lon.doubleValue];
    CLLocationDistance d = [curentLocation distanceFromLocation :l ];
    
    return @(d);
    
   
}


@end
