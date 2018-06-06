//
//  CBRealNameVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBRealNameVC.h"
#import "CBFillInfoWebVC.h"

@interface CBRealNameVC ()

@property (weak, nonatomic) IBOutlet UIView *notYetRealNameView;        ///< 未实名认证
@property (weak, nonatomic) IBOutlet UIView *inTheAuthenticationView;   ///< 实名认证中
@property (weak, nonatomic) IBOutlet UIView *alreadyRealNameView;       ///< 已经实名认证


@end

@implementation CBRealNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.notYetRealNameView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startCertification:(id)sender {
    CBFillInfoWebVC *vc = [CBFillInfoWebVC new];
    vc.title = @"实名认证";
    NSString *url = [urlH5PresonCer stringByAppendingFormat:@"?token=%@", [CBLiveUserConfig getOwnToken]];
    [vc webViewloadRequestWithURLString:url];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
