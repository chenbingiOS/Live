//
//  CBBlackListVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/26.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBBlackListVC.h"
#import "CBWatchCell.h"
#import "CBAttentionVO.h"

@interface CBBlackListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <CBAttentionVO *> *cellDataAry;

@end

static NSString *const FansCellID = @"FansCellID";

@implementation CBBlackListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑名单";
    [self setupUI];
    [self httpBlackList];
}

- (void)httpBlackList {
    [self.tableView ly_startLoading];
    NSString *url = urlBlacklist;
    NSDictionary *param = @{@"token":[CBLiveUserConfig getOwnToken]};
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            self.cellDataAry = [NSArray modelArrayWithClass:[CBAttentionVO class] json:data].mutableCopy;
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    }];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [CBRefreshGifHeader headerWithRefreshingBlock:^{
        [self httpBlackList];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBWatchCell *cell = [tableView dequeueReusableCellWithIdentifier:FansCellID];
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

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat height = kScreenHeight - SafeAreaTopHeight - 30;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, height) style:UITableViewStylePlain];
        _tableView.rowHeight = 70;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor bgColor];
        
        [_tableView registerNib:[UINib nibWithNibName:@"CBWatchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:FansCellID];
        _tableView.ly_emptyView = [CBEmptyView diyEmptyActionViewWithTarget:self action:@selector(httpBlackList)];
    }
    return _tableView;
}

@end
