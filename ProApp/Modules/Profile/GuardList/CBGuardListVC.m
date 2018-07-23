//
//  CBGuardListVC.m
//  ProApp
//
//  Created by hxbjt on 2018/7/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBGuardListVC.h"

@interface CBGuardListVC ()

@end

@implementation CBGuardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self deleteWebCache];
    NSString *anchorId = [CBLiveUserConfig getOwnID];
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&token=%@", H5_mine_guard, anchorId, [CBLiveUserConfig getOwnToken]];
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
