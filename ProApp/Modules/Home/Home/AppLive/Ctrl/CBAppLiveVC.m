//
//  CBAppLiveVC.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "CBAppLiveVC.h"
#import "ALinLive.h"
#import "ALinRefreshGifHeader.h"
#import "CBAppLiveCell.h"
#import "ALinTopAD.h"
#import "ALinHomeADCell.h"
#import "ALinLiveCollectionViewController.h"

#import "CBLiveVC.h"
#import "CBNVC.h"

@interface CBAppLiveVC ()

@property(nonatomic, assign) NSUInteger currentPage;    /** 当前页 */
@property(nonatomic, strong) NSMutableArray *lives; /** 直播 */
@property(nonatomic, strong) NSArray *topADS;   /** 广告 */

@end

static NSString *ADReuseIdentifier = @"ALinHomeADCell";
static NSString *reuseIdentifier = @"CBAppLiveCell";

@implementation CBAppLiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup_tableView];
}

- (void)setup_tableView {
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ALinHomeADCell class] forCellReuseIdentifier:ADReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CBAppLiveCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:
     reuseIdentifier];
    
    self.currentPage = 1;
    self.tableView.mj_header = [ALinRefreshGifHeader headerWithRefreshingBlock:^{
        self.lives = [NSMutableArray array];
        self.currentPage = 1;
        // 获取顶部的广告
        [self getTopAD];
        [self getHotLiveList];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getHotLiveList];
    }];
}

- (void)getTopAD
{
    [[ALinNetworkTool shareTool] GET:@"http://live.9158.com/Living/GetAD" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *result = responseObject[@"data"];
        if ([self isNotEmpty:result]) {
            self.topADS = [ALinTopAD mj_objectArrayWithKeyValuesArray:result];
            [self.tableView reloadData];
        }else{
            [self showHint:@"网络异常"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showHint:@"网络异常"];
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
    return self.lives.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    }
    return 410;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ALinHomeADCell *cell = [tableView dequeueReusableCellWithIdentifier:ADReuseIdentifier];
        if (self.topADS.count) {
            cell.topADs = self.topADS;
            [cell setImageClickBlock:^(ALinTopAD *topAD) {
                if (topAD.link.length) {
//                    ALinWebViewController *web = [[ALinWebViewController alloc] initWithUrlStr:topAD.link];
//                    web.navigationItem.title = topAD.title;
//                    [self.navigationController pushViewController:web animated:YES];
                }
            }];
        }
        return cell;
    }
    // 直播格子
    CBAppLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.live = self.lives[indexPath.row-1];
    return cell;
}

#pragma mark - TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBLiveVC *liveVC = [CBLiveVC new];
    liveVC.lives = self.lives;
    liveVC.currentIndex = indexPath.row-1;
    CBNVC *nvc = [[CBNVC alloc] initWithRootViewController:liveVC];
    [self presentViewController:nvc animated:YES completion:nil];
    
//    ALinLiveCollectionViewController *liveVc = [[ALinLiveCollectionViewController alloc] init];
//    liveVc.lives = self.lives;
//    liveVc.currentIndex = indexPath.row-1;
//    [self presentViewController:liveVc animated:YES completion:nil];
}

#pragma mark - layz
- (NSMutableArray *)lives {
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}

@end
