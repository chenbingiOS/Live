//
//  CBFillInfoWebVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/5.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBFillInfoWebVC.h"
#import "WebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>

@interface CBFillInfoWebVC () <WKNavigationDelegate>
@property WebViewJavascriptBridge* bridge;
@end

@implementation CBFillInfoWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [self.bridge setWebViewDelegate:self];
    @weakify(self);
    [self.bridge registerHandler:@"realNameCallBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSDictionary *dictData = data;
        NSNumber *code = dictData[@"code"];
        if ([code isEqualToNumber:@200]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            NSString *descrp = dictData[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        responseCallback(data);
    }];
    NSString *url = [urlH5PresonCer stringByAppendingFormat:@"?token=%@", [CBLiveUserConfig getOwnToken]];
    [self webViewloadRequestWithURLString:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
