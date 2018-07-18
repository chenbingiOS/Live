//
//  messagelisviews.m
//  iphoneLive
//
//  Created by zqm on 16/8/3.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "messagelisviews.h"
@interface messagelisviews ()<EMChatManagerDelegate,EMClientDelegate>

@end

@implementation messagelisviews

-(instancetype)init{
    
    self = [super init];
    if (self) {
            [self huan];
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    }
    return self;
}
-(void)huan{
    //用户名uid
    //密码
    [[EMClient sharedClient] loginWithUsername:[CBLiveUserConfig getHXuid] password:[CBLiveUserConfig getHXpwd] completion:^(NSString *aUsername, EMError *aError) {
        
        NSLog(@"messagelisviews--%@",aError.errorDescription);
        
    }];
}
@end
