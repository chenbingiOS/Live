//
//  CBGuardView.m
//  ProApp
//
//  Created by hxbjt on 2018/7/16.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBGuardView.h"
#import "CBBaseWebViewVC.h"

@interface CBGuardView ()

@property (nonatomic, strong) CBBaseWebViewVC *webView;

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
//        [webVC webViewloadRequestWithURLString:H5_add_guard];
        _webView = webVC;
//        WKWebView *webView = [WKWebView new];
//        webView.frame = _contentView.frame;
//        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:H5_add_guard]]];
//        [_contentView addSubview:webView];
    }
    return _webView;
}

- (void)loadRequestWithAnchorId:(NSString *)anchorId {
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&token=%@", H5_add_guard, anchorId, [CBLiveUserConfig getOwnToken]];
    [self.webView webViewloadRequestWithURLString:url];
}

@end
