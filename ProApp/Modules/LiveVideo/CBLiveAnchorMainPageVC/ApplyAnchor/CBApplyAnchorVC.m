//
//  CBApplyAnchorVC.m
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBApplyAnchorVC.h"

@interface CBApplyAnchorVC ()

@end

@implementation CBApplyAnchorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请成为主播";
    NSString *url = [H5_index stringByAppendingFormat:@"?token=%@", [CBLiveUserConfig getOwnToken]];
    [self webViewloadRequestWithURLString:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backViewCtrl {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
