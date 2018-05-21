//
//  CBHotVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBHotVC.h"
#import "ALinLive.h"
#import "ALinRefreshGifHeader.h"
#import "CBAppLiveCell.h"
#import "ALinTopAD.h"

#import "CBLiveVC.h"

@interface CBHotVC ()

@property(nonatomic, assign) NSUInteger currentPage;    /** 当前页 */
@property(nonatomic, strong) NSMutableArray *lives; /** 直播 */

@end

static NSString *ADReuseIdentifier = @"ALinHomeADCell";
static NSString *reuseIdentifier = @"CBAppLiveCell";

@implementation CBHotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup_tableView];
}

- (void)setup_tableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CBAppLiveCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:
     reuseIdentifier];
    
    self.currentPage = 1;
    self.tableView.mj_header = [ALinRefreshGifHeader headerWithRefreshingBlock:^{
        self.lives = [NSMutableArray array];
        self.currentPage = 1;
        [self getHotLiveList];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getHotLiveList];
    }];
}

- (void)getHotLiveList
{
    [[ALinNetworkTool shareTool] GET:[NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld", self.currentPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSArray *result = [ALinLive mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        NSLog(@"%@",[result modelToJSONString]);
        if ([self isNotEmpty:result]) {
            [self.lives addObjectsFromArray:result];
            [self.tableView reloadData];
        }else{
            [self showHint:@"暂时没有更多最新数据"];
            // 恢复当前页
            self.currentPage--;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.currentPage--;
        [self showHint:@"网络异常"];
    }];
    
}

#pragma mark - TableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lives.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 410;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 直播格子
    CBAppLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.live = self.lives[indexPath.row];
    return cell;
}

#pragma mark - TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - layz
- (NSMutableArray *)lives {
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}

@end
