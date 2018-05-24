//
//  AppDelegate+ShareSDK.m
//  ProApp
//
//  Created by hxbjt on 2018/5/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "AppDelegate+ShareSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WXApi.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerSharer.h>
#import <Twitter/Twitter.h>

//QQ
#define QQAppKey @"aed9b0303e3ed1e27bae87c33761161d"
#define QQAppId @"100371282"
//wechat
#define WechatAppId @"wx44687471d25cf978"
#define WechatAppSecret @"339df8e031c3b8006cc89f1d0e717ee7"
//facebook
#define FacebookApiKey @""
#define FacebookAppSecret @""
//twitter
#define TwitterKey @""
#define TwitterSecret @""
#define TwitterRedirectUri @""

@implementation AppDelegate (ShareSDK)

- (void)initThirdPlatform {
    NSArray *platform = @[
                          @(SSDKPlatformTypeSinaWeibo),
                          @(SSDKPlatformTypeMail),
                          @(SSDKPlatformTypeSMS),
                          @(SSDKPlatformTypeCopy),
                          @(SSDKPlatformTypeWechat),
                          @(SSDKPlatformTypeQQ),
                          @(SSDKPlatformTypeRenren),
                          @(SSDKPlatformTypeFacebook),
                          @(SSDKPlatformTypeTwitter),
                          @(SSDKPlatformTypeGooglePlus)
                          ];
    [ShareSDK registerActivePlatforms:platform onImport:^(SSDKPlatformType platformType) {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                break;
            case SSDKPlatformTypeFacebook:
                [ShareSDKConnector connectFacebookMessenger:[FBSDKMessengerSharer class]];
                break;
            case SSDKPlatformTypeFacebookMessenger:
                [ShareSDKConnector connectFacebookMessenger:[FBSDKMessengerSharer class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeTwitter:
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:WechatAppId appSecret:WechatAppSecret];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:QQAppId appKey:QQAppKey authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeFacebook:
                [appInfo SSDKSetupFacebookByApiKey:FacebookApiKey appSecret:FacebookAppSecret authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeTwitter:
                [appInfo SSDKSetupTwitterByConsumerKey:TwitterKey consumerSecret:TwitterSecret redirectUri:TwitterRedirectUri];
                break;
            default:
                break;
        }
    }];
    
    //facebook审核中
    //685742891599488
    //64fa770a8992d8ce053421eac31e6180
}

@end
