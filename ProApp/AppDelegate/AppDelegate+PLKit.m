//
//  AppDelegate+PLKit.m
//  ProApp
//
//  Created by hxbjt on 2018/5/25.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "AppDelegate+PLKit.h"

@implementation AppDelegate (PLKit)

- (void)initPLKit {
    // 短视频
    [PLShortVideoKitEnv initEnv];
    [PLShortVideoKitEnv setLogLevel:PLShortVideoLogLevelDebug];
    [PLShortVideoKitEnv enableFileLogging];
    
    // 直播
    [PLStreamingEnv initEnv];
    [PLStreamingEnv setLogLevel:PLStreamLogLevelDebug];
    [PLStreamingEnv enableFileLogging];    
    NSLog(@"version is %@", [PLMediaStreamingSession versionInfo]);
    
    // TuSDK mark - 初始化 TuSDK
    [TuSDK setLogLevel:lsqLogLevelDEBUG]; // 可选: 设置日志输出级别 (默认不输出)
    [TuSDK initSdkWithAppKey:@"3ad4ee3da6c0b41c-03-bshmr1"];
}

@end
