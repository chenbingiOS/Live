
//
//  CBMyAttentionVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBMyAttentionVC.h"
#import "CBWatchCell.h"
#import "CBAttentionVO.h"

@interface CBMyAttentionVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <CBAttentionVO *> *cellDataAry;

@end

static NSString *const WatchCellIdentifier = @"WatchCellIdentifier";

@implementation CBMyAttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    [self setupUI];
    [self httpAttentionList];
}

- (void)httpAttentionList {
    NSString *url = urlGetAttentionList;
    NSDictionary *param = @{@"token":[CBLiveUserConfig getOwnToken],
                            @"id":[CBLiveUserConfig getOwnID]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSNumber *code = [responseObject valueForKey:@"code"];
        //        NSString *descrp = [responseObject valueForKey:@"descrp"];
        //        [MBProgressHUD showAutoMessage:descrp];
        if ([code isEqualToNumber:@200]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            self.cellDataAry = [NSArray modelArrayWithClass:[CBAttentionVO class] json:data].mutableCopy;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)setupUI {
    @weakify(self);
    self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"placeholder_head" titleStr:@"暂无数据" detailStr:@"" btnTitleStr:@"点击重新加载" btnClickBlock:^{
        @strongify(self);
        [self httpAttentionList];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBWatchCell *cell = [tableView dequeueReusableCellWithIdentifier:WatchCellIdentifier];
    [cell loadData:self.cellDataAry[indexPath.row]];
    return cell;
}

#pragma mark - layz
- (NSMutableArray *)cellDataAry {
    if (!_cellDataAry) {
        _cellDataAry = [NSMutableArray new];
    }
    return _cellDataAry;
}

@end
