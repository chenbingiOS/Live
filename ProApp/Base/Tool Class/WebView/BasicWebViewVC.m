//
//  BasicWebViewVC.m
//  LYLWKWebView
//
//  Created by Rainy on 2018/5/7.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import "BasicWebViewVC.h"

@interface BasicWebViewVC () <WKNavigationDelegate>

@end

@implementation BasicWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)webViewloadRequestWithURLString:(NSString *)URLSting {
    [self.webViewManager.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLSting]]];
}

#pragma mark - <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    //"webViewDidStartLoad"
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //"webViewDidFinishLoad"
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    //"webViewDidFailLoad"
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    //"webViewWillLoadData"
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    //"webViewWillAuthentication"
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling , nil);
}

#pragma mark - lazy
-(CBWKWebView *)webViewManager {
    if (!_webViewManager) {        
        _webViewManager = [[CBWKWebView alloc] initWithFrame:self.view.bounds];
        _webViewManager.webView.navigationDelegate = self;
        [self.view addSubview:_webViewManager];
    }
    return _webViewManager;
}

@end
