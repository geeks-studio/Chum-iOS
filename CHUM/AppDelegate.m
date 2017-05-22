//
//  AppDelegate.m
//  CHUM
//
//  Created by Andrey Mikhaylov on 05/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "AppDelegate.h"
//#import "CHMTopNavigationVC.h"
#import "CHMCurrentUserManager.h"
#import "CHMLocationManager.h"

#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import "CHMPost.h"
#import "CHMPostDirectlyTVC.h"

#import "CHUM-Bridging-Header.h"
#import "CHUM-Swift.h"
#import "HDNotificationView.h"
#import "PAAConversation.h"
#import "PAAMessagerVC.h"
#import "CHMNotificationCenter.h"
#import "Reachability.h"

@import GoogleMaps;

@import AFNetworking;

@interface AppDelegate ()

@property (strong, nonatomic) Reachability *reachability;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //    AIzaSyCrZt4uTh2FkDWrZoGDmbaMl5vP1gCGH04

    [GMSServices provideAPIKey:@"AIzaSyCrZt4uTh2FkDWrZoGDmbaMl5vP1gCGH04"];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];

    [Fabric with:@[ [Crashlytics class] ]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[CHMLocationManager shared] loadLocationSubscibe:nil];

    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo) {
        [[CHMNotificationCenter shared] storeAction:userInfo];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for
    // certain types of temporary interruptions (such as an incoming phone call or SMS message) or
    // when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame
    // rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store
    // enough application state information to restore your application to its current state in case
    // it is terminated later.
    // If your application supports background execution, this method is called instead of
    // applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo
    // many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive.
    // If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also
    // applicationDidEnterBackground:.
}

#pragma mark - push

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[CHMCurrentUserManager shared] setPushToken:[deviceToken description]];
}

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[CHMNotificationCenter shared] showNotificationWithPayload:userInfo];
}

@end
