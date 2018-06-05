//
//  CBFillInfoWebVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/5.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBFillInfoWebVC.h"
#import "WebViewJavascriptBridge.h"

@interface CBFillInfoWebVC ()

@property (nonatomic, strong) WebViewJavascriptBridge* bridge;

@end

@implementation CBFillInfoWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webViewManager.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
