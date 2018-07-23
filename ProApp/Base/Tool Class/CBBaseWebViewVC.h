//
//  CBBaseWebViewVC.h
//  ProApp
//
//  Created by hxbjt on 2018/6/6.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>

@interface CBBaseWebViewVC : UIViewController

@property (nonatomic, strong) WKWebView *wkWebView;
- (void)resetWebViewFrame:(CGRect)frame;
- (void)webViewloadRequestWithURLString:(NSString *)URLSting;
- (void)backViewCtrl;
- (void)deleteWebCache;

@end
