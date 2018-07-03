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

    self.currentPage = 1;
    self.tableView.mj_header = [CBRefreshGifHeader headerWithRefreshingBlock:^{
        [self reloadAllData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self httpLive];
    }];
    
    self.tableView.ly_emptyView = [CBEmptyView diyEmptyActionViewWithTarget:self action:@selector(reloadAllData)];
}

- (void)reloadAllData {
    self.currentPage = 1;
    self.lives = [NSMutableArray array];
    [self httpLive];
}

- (void)httpLive {
    [self.tableView ly_startLoading];
    NSString *url = urlGetLive;
    NSDictionary *param = @{@"page":@(self.currentPage),
                            @"token":[CBLiveUserConfig getOwnToken],
                            @"type":@1};
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSArray *resultList = [NSArray modelArrayWithClass:[CBAppLiveVO class] json:responseObject[@"data"]];
            if (resultList.count < 20 && self.currentPage > 1) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.currentPage--;
            } else {
                [self.lives addObjectsFromArray:resultList];
                [self.tableView reloadData];
            }
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.currentPage--;
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
    CBLiveVC *liveVC = [[CBLiveVC alloc] initWithLives:self.lives currentIndex:indexPath.row];
    [self.navigationController pushViewController:liveVC animated:YES];
}

#pragma mark - layz
- (NSMutableArray *)lives {
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}

@end
