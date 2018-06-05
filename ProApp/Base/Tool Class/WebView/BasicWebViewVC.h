//
//  BasicWebViewVC.h
//  LYLWKWebView
//
//  Created by Rainy on 2018/5/7.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBWKWebView.h"

@interface BasicWebViewVC : UIViewController

@property (nonatomic, strong) CBWKWebView *webViewManager;
- (void)webViewloadRequestWithURLString:(NSString *)URLSting;

@end
