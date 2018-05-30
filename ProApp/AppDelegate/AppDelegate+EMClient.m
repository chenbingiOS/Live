//
//  AppDelegate+EMClient.m
//  ProApp
//
//  Created by hxbjt on 2018/5/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "AppDelegate+EMClient.h"

//环信
//#define IMkey @"1101171020178343#duomi"
#define IMkey @"1172171012115524#fengwotest"

@implementation AppDelegate (EMClient)

- (void)initEMClient {
    NSLog(@"环信 版本号====%@",[[EMClient sharedClient] version]);
    //注册环信 advance1989#yunbaolive
    EMOptions *options = [EMOptions optionsWithAppkey:IMkey];
    [[EMClient sharedClient] initializeSDKWithOptions:options];
}

@end
