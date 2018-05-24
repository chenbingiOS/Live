//
//  CBHotVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

// VC
#import "CBHotVC.h"
#import "CBLiveVC.h"
#import "CBNVC.h"
// View
#import "CBAppLiveCell.h"
#import "CBAppLiveVO.h"
#import "CBRefreshGifHeader.h"

@interface CBHotVC ()

@property(nonatomic, assign) NSUInteger currentPage;    /** 当前页 */
@property(nonatomic, strong) NSMutableArray *lives; /** 直播 */

@end

static NSString *RIDCBAppLiveCell = @"RIDCBAppLiveCell";

@implementation CBHotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CBAppLiveCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:RIDCBAppLiveCell];
    
    self.tableView.backgroundColor = [UIColor bgColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.mj_header = [CBRefreshGifHeader headerWithRefreshingBlock:^{
        self.lives = [NSMutableArray array];
        self.currentPage = 1;
        // 获取顶部的广告
        [self httpLive];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.currentPage = 1;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self httpLive];
    }];
    
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
}

- (void)httpLive {
    NSString *url = [NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld", self.currentPage];
    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
//        NSArray *result = [CBAppLiveVO mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
//        if ([self isNotEmpty:result]) {
//            [self.lives addObjectsFromArray:result];
//            [self.tableView reloadData];
//        }else{
//            [self showHint:@"暂时没有更多最新数据"];
            // 恢复当前页
            self.currentPage--;
//        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.currentPage--;
//        [self showHint:@"网络异常"];
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
    CBAppLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:RIDCBAppLiveCell];
    cell.live = self.lives[indexPath.row];
    return cell;
}

#pragma mark - TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 跳转直播播放器
    CBLiveVC *liveVC = [[CBLiveVC alloc] initWithTransitionStyle:(UIPageViewControllerTransitionStyleScroll) navigationOrientation:(UIPageViewControllerNavigationOrientationVertical) options:@{UIPageViewControllerOptionInterPageSpacingKey:@(0)}];
    liveVC.lives = self.lives;
    liveVC.currentIndex = indexPath.row;
    CBNVC *nvc = [[CBNVC alloc] initWithRootViewController:liveVC];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - layz
- (NSMutableArray *)lives {
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}

@end
