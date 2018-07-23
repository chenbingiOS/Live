//
//  CBJoinVipVC.m
//  ProApp
//
//  Created by hxbjt on 2018/7/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBJoinVipVC.h"
#import "WebViewJavascriptBridge.h"

@interface CBJoinVipVC ()
@property WebViewJavascriptBridge* bridge;
@end

@implementation CBJoinVipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self deleteWebCache];
    self.title = @"加入Vip";
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [self.bridge setWebViewDelegate:self];
    @weakify(self);
    [self.bridge registerHandler:@"openVipCallBack" handler:^(id data, WVJBResponseCallback responseCallback) {
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
    NSString *anchorId = [CBLiveUserConfig getOwnID];
    NSString *url = [H5_add_vip stringByAppendingFormat:@"?id=%@&token=%@", anchorId, [CBLiveUserConfig getOwnToken]];
    [self webViewloadRequestWithURLString:url];
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
