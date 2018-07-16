//
//  CBShareView.m
//  ProApp
//
//  Created by hxbjt on 2018/6/12.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@implementation CBShareView

- (IBAction)actionShareBtn:(UIButton *)sender {
    if (sender.tag == 11) {
        [self shareByPlatforms:SSDKPlatformTypeWechat];
    } else if (sender.tag == 22) {
        [self shareByPlatforms:SSDKPlatformTypeSinaWeibo];
    } else if (sender.tag == 33) {
        [self shareByPlatforms:SSDKPlatformTypeQQ];
    } else if (sender.tag == 44) {
        [self shareByPlatforms:SSDKPlatformSubTypeWechatTimeline];
    }
    if (self.clickBtnBlock) {
        self.clickBtnBlock();
    }
}

- (void)shareByPlatforms:(SSDKPlatformType)platformType {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    SSDKContentType contentType = SSDKContentTypeAuto;
    NSString *url = [urlH5Share stringByAppendingFormat:@"?id=%@&shareId=%@", self.shareContentId, [CBLiveUserConfig getOwnID]];
    NSURL *paramURL = [NSURL URLWithString:url];
    if (platformType == SSDKPlatformTypeSinaWeibo) {
        contentType = SSDKContentTypeImage;
    }

    //创建分享参数
    [shareParams SSDKSetupShareParamsByText:[CBLiveUserConfig myProfile].user_nicename images:[CBLiveUserConfig myProfile].avatar url:paramURL title:@"分享" type:contentType];

    //进行分享
    [ShareSDK share:platformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateBegin: break;
             case SSDKResponseStateSuccess: [MBProgressHUD showAutoMessage:@"分享成功"]; break;
             case SSDKResponseStateFail: [MBProgressHUD showAutoMessage:@"分享失败"]; break;
             case SSDKResponseStateCancel: [MBProgressHUD showAutoMessage:@"分享失败"]; break;
             case SSDKResponseStateBeginUPLoad: break;
         }
     }];
}

@end

@implementation CBSharePopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置参数 (否则用默认值)
        self.popType = PopTypeMove;
        self.moveAppearCenterY = kScreenHeight - self.height/2;
        self.moveAppearDirection = MoveAppearDirectionFromBottom;
        self.moveDisappearDirection = MoveDisappearDirectionToBottom;
        self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.animateDuration = 0.35;
        self.radius = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.shareView];
        
        @weakify(self);
        [self.shareView.closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            [self hide];
        }];
        self.shareView.clickBtnBlock = ^{
            @strongify(self);
            [self hide];
        };
    }
    return self;
}

- (CBShareView *)shareView {
    if (!_shareView) {
        _shareView = [CBShareView viewFromXib];
        _shareView.frame = CGRectMake(0, 0, kScreenWidth, 180);
    }
    return _shareView;
}

@end
