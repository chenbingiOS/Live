//
//  CBGuardView.m
//  ProApp
//
//  Created by hxbjt on 2018/7/16.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBGuardView.h"
#import "CBBaseWebViewVC.h"
#import "WebViewJavascriptBridge.h"

@interface CBGuardView ()

@property (nonatomic, strong) CBBaseWebViewVC *webView;
@property WebViewJavascriptBridge *bridge;

@end

@implementation CBGuardView

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
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.webView.view];
    }
    return self;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.75)];
    }
    return _contentView;
}

- (CBBaseWebViewVC *)webView {
    if (!_webView) {
        CBBaseWebViewVC *webVC = [CBBaseWebViewVC new];
        webVC.view.frame = _contentView.frame;
        [webVC resetWebViewFrame:_contentView.frame];
        _webView = webVC;
    }
    return _webView;
}

- (void)loadRequestWithAnchorId:(NSString *)anchorId {
    [self.webView deleteWebCache];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView.wkWebView];
    [self.bridge setWebViewDelegate:self];
    @weakify(self);
    [self.bridge registerHandler:@"openGuardCallBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSDictionary *dictData = data;
        NSNumber *code = dictData[@"code"];
        if ([code isEqualToNumber:@200]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hide];
            });
        } else {
            NSString *descrp = dictData[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        responseCallback(data);
    }];
    [self.bridge registerHandler:@"nsfCallBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSDictionary *dictData = data;
        NSNumber *code = dictData[@"code"];
        if ([code isEqualToNumber:@200]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"余额不足");
            });
        } else {
            NSString *descrp = dictData[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        responseCallback(data);
    }];
    
    
    NSString *url = [NSString stringWithFormat:@"%@?userid=%@&token=%@", H5_add_guard, anchorId, [CBLiveUserConfig getOwnToken]];
    [self.webView webViewloadRequestWithURLString:url];
}

@end
