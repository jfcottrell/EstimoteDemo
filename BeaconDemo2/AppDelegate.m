//
//  AppDelegate.m
//  BeaconDemo2
//
//  Created by CottrellMACW7u on 2/7/15.
//  Copyright (c) 2015 CottrellMACW7u. All rights reserved.
//

#import "AppDelegate.h"
#import <ESTBeaconManager.h>
#import <ESTConfig.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"ESTAppDelegate: APP ID and APP TOKEN are required to connect to your beacons and make Estimote API calls.");
    [ESTConfig setupAppID:@"johns-test-app" andAppToken:@"7d9e5f2705e78087ef8b1d91b1e638aa"];
    
    // Estimote Analytics allows you to log activity related to monitoring mechanism.
    // At the current stage it is possible to log all enter/exit events when monitoring
    // Particular beacons (Proximity UUID, Major, Minor values needs to be provided).
    
    NSLog(@"ESTAppDelegate: Analytics are turned OFF by defaults. You can enable them changing flag");
    [ESTConfig enableAnalytics:NO];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
