//
//  CBBaseWebViewVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/6.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBBaseWebViewVC.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>

static void *XFWkwebBrowserContext = &XFWkwebBrowserContext;

@interface CBBaseWebViewVC ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UINavigationControllerDelegate,UINavigationBarDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
//设置加载进度条
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) CGFloat progress;
//保存的网址链接
@property (nonatomic, copy) NSString *URLString;
//保存请求链接
@property (nonatomic) NSMutableArray* snapShotsArray;
//返回按钮
@property (nonatomic) UIBarButtonItem* customBackBarItem;
//关闭按钮
@property (nonatomic) UIBarButtonItem* closeButtonItem;

@end

@implementation CBBaseWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor bgColor];
    
    //添加到主控制器上
    [self.view addSubview:self.wkWebView];

    //添加进度条
    [self.view insertSubview:self.progressView aboveSubview:self.wkWebView];
    
    //添加右边刷新按钮
    UIBarButtonItem *roadLoad = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(roadLoadClicked)];
    self.navigationItem.rightBarButtonItem = roadLoad;
}

- (void)roadLoadClicked{
    [self.wkWebView reload];
}

- (void)customBackItemClicked{
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    } else {
        [self backViewCtrl];
    }
}

- (void)closeItemClicked{
    [self backViewCtrl];
}

- (void)backViewCtrl {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewloadRequestWithURLString:(NSString *)URLSting {
    self.URLString = URLSting;
//    NSURLRequest * Request_zsj = [NSURLRequest requestWithURL:[NSURL URLWithString:URLSting] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLRequest *Request_zsj = [NSURLRequest requestWithURL:[NSURL URLWithString:URLSting]];
    //加载网页
    [self.wkWebView loadRequest:Request_zsj];
}

#pragma mark ================ 自定义返回/关闭按钮 ================

- (void)updateNavigationItems{
    if (self.wkWebView.canGoBack) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -6.5;
        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.customBackBarItem,self.closeButtonItem] animated:NO];
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
    }
}

//请求链接处理
- (void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    //    NSLog(@"push with request %@",request);
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        NSLog(@"about blank!! return");
        return;
    }
    //如果url一样就不进行push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    UIView* currentSnapShotView = [self.wkWebView snapshotViewAfterScreenUpdates:YES];
    [self.snapShotsArray addObject:@{@"request":request,@"snapShotView":currentSnapShotView}];
}

#pragma mark ================ WKNavigationDelegate ================

//这个是网页加载完成，导航的变化
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    /*
     主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
     */
    // 获取加载网页的标题
    self.title = self.wkWebView.title;    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateNavigationItems];
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
}

//内容返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{}

//服务器请求跳转的时候调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{}

//服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //    NSString* orderInfo = [[AlipaySDK defaultService]fetchOrderInfoFromH5PayUrl:[navigationAction.request.URL absoluteString]];
    //    if (orderInfo.length > 0) {
    //        [self payWithUrlOrder:orderInfo];
    //    }
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeBackForward: {
            break;
        }
        case WKNavigationTypeReload: {
            break;
        }
        case WKNavigationTypeFormResubmitted: {
            break;
        }
        case WKNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        default: {
            break;
        }
    }
    [self updateNavigationItems];
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 内容加载失败时候调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载超时");
}

//跳转失败的时候调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{}

//进度条
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{}

#pragma mark ================ WKUIDelegate ================

// 获取js 里面的提示
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// js 信息的交流
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 交互。可输入的文本。
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        self.progress = self.wkWebView.estimatedProgress;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark ================ WKScriptMessageHandler ================

//拦截执行网页中的JS方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //服务器固定格式写法 window.webkit.messageHandlers.名字.postMessage(内容);
    //客户端写法 message.name isEqualToString:@"名字"]
    if ([message.name isEqualToString:@"WXPay"]) {
        NSLog(@"%@", message.body);
        //调用微信支付方法
        //        [self WXPayWithParam:message.body];
    }
}

#pragma mark ================ 懒加载 ================

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (self.progressView.alpha == 0) {self.progressView.alpha = 1;}
    [self.progressView setProgress:progress animated:YES];
    if (progress >= 1.0f) {
        [UIView animateWithDuration:0.8 animations:^{
            self.progressView.alpha = 0;
        } completion:^(BOOL finished) {
            self.progressView.progress = 0;
        }];
    }
}

- (NSString *)javascriptOfCSS {
    NSString *css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"var style = document.createElement('style');"];
    [javascript appendString:@"style.type = 'text/css';"];
    [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
    [javascript appendString:@"style.appendChild(cssContent);"];
    [javascript appendString:@"document.body.appendChild(style);"];
    return javascript;
}

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        //设置网页的配置文件
        WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
        //允许视频播放
        Configuration.allowsAirPlayForMediaPlayback = YES;
        // 允许在线播放
        Configuration.allowsInlineMediaPlayback = YES;
        // 允许可以与网页交互，选择视图
        Configuration.selectionGranularity = YES;
        // web内容处理池
        Configuration.processPool = [[WKProcessPool alloc] init];
        
        // 配置
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 13; // 最小字好
        Configuration.preferences = preferences;

        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        WKUserContentController * UserContentController = [[WKUserContentController alloc]init];
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:[self javascriptOfCSS] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [UserContentController addUserScript:noneSelectScript];
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        [UserContentController addScriptMessageHandler:self name:@"WXPay"];
        // 是否支持记忆读取
        Configuration.suppressesIncrementalRendering = YES;
        // 允许用户更改网页的设置
        Configuration.userContentController = UserContentController;
        
        // WebView
        CGFloat height = kScreenHeight - SafeAreaTopHeight;
        if (iPhoneX) height -= SafeAreaBottomHeight;        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height) configuration:Configuration];
        _wkWebView.backgroundColor = [UIColor bgColor];
        _wkWebView.scrollView.bounces = NO;
        // 设置代理
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;        
        //kvo 添加进度监控
        [_wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:XFWkwebBrowserContext];
        //开启手势触摸
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        // 设置 可以前进 和 后退
        //适应你设定的尺寸
        [_wkWebView sizeToFit];
    }
    return _wkWebView;
}

- (UIBarButtonItem*)customBackBarItem{
    if (!_customBackBarItem) {
        UIImage* backItemImage = [[UIImage imageNamed:@"backItemImage"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        UIImage* backItemHlImage = [[UIImage imageNamed:@"backItemImage-hl"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        
        UIButton* backButton = [[UIButton alloc] init];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor backColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[[UIColor backColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _customBackBarItem;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, kScreenWidth, 2);
        // 设置进度条的色彩
        [_progressView setTrackTintColor:[UIColor clearColor]];
        _progressView.progressTintColor = [UIColor blueColor];
    }
    return _progressView;
}

- (UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}

- (NSMutableArray*)snapShotsArray{
    if (!_snapShotsArray) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"WXPay"];
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
}

//注意，观察的移除
- (void)dealloc{
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

@end
