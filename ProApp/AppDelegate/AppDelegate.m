//
//  AppDelegate.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+AppServer.h"
#import "AppDelegate+ShareSDK.h"
#import "AppDelegate+Hyphenate.h"
#import "AppDelegate+PLKit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initThirdPlatform];
    [self initHyphenateSDK];
    [self initWindow];
    [self initRootVC];
    [self initApperance];
    [self initPLKit];

//    [PPNetworkHelper openLog];
//    NSDictionary *param = @{@"token": [CBLiveUserConfig getOwnToken],
//                            @"uid": @"157968",
//                            @"data": @[@"4",@"5",@"6"]
//                            };
//    [PPNetworkHelper POST:@"http://fengwo.gttead.cn/Api/Anchor/add_impress" parameters:param success:^(id responseObject) {
//
//    } failure:^(NSError *error) {
//
//    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
//    [JPUSHService setBadge:0];
    [application setApplicationIconBadgeNumber:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
