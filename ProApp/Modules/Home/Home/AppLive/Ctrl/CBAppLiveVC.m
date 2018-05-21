//
//  CBAppLiveVC.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

// VC
#import "CBAppLiveVC.h"
#import "CBLiveVC.h"
#import "CBNVC.h"
// View
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "CBAppADCell.h"

#import "ALinLive.h"
#import "ALinRefreshGifHeader.h"
#import "CBAppLiveCell.h"
#import "ALinTopAD.h"
#import "ALinLiveCollectionViewController.h"


@interface CBAppLiveVC () <TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (nonatomic, strong) TYCyclePagerView *cyclePagerView;   ///< 广告UI
@property (nonatomic, strong) NSMutableArray *lives;    ///< 直播数据
@property (nonatomic, strong) NSArray *topADS;          ///< 广告数据
@property (nonatomic, assign) NSUInteger currentPage;   ///< 当前页

@end

static NSString *RIDCBAppLiveCell = @"RIDCBAppLiveCell";
static NSString *RIDCBAppADCell = @"RIDCBAppADCell";

@implementation CBAppLiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CBAppLiveCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:RIDCBAppLiveCell];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGFloat height = kScreenWidth * 9 / 16;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    [headerView addSubview:self.cyclePagerView];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc] init];
        
    self.currentPage = 1;
    self.tableView.mj_header = [ALinRefreshGifHeader headerWithRefreshingBlock:^{
        self.lives = [NSMutableArray array];
        self.currentPage = 1;
        // 获取顶部的广告
        [self httpAD];
        [self httpLive];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self httpLive];
    }];
    
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
}

- (void)httpAD {
    [PPNetworkHelper GET:@"http://live.9158.com/Living/GetAD" parameters:nil success:^(id responseObject) {
        NSArray *result = responseObject[@"data"];
                if ([self isNotEmpty:result]) {
                    self.topADS = [ALinTopAD mj_objectArrayWithKeyValuesArray:result];
                    [self.tableView reloadData];
                }else{
                    [self showHint:@"网络异常"];
                }
    } failure:^(NSError *error) {
        
    }];
//    [[ALinNetworkTool shareTool] GET:@"http://live.9158.com/Living/GetAD" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self showHint:@"网络异常"];
//    }];
}

- (void)httpLive
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lives.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenWidth+5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 直播格子
    CBAppLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:RIDCBAppLiveCell];
    cell.live = self.lives[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 跳转直播播放器
    CBLiveVC *liveVC = [[CBLiveVC alloc] initWithTransitionStyle:(UIPageViewControllerTransitionStyleScroll) navigationOrientation:(UIPageViewControllerNavigationOrientationVertical) options:@{UIPageViewControllerOptionInterPageSpacingKey:@(0)}];
    liveVC.lives = self.lives;
    liveVC.currentIndex = indexPath.row;
    CBNVC *nvc = [[CBNVC alloc] initWithRootViewController:liveVC];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - TYCyclePagerViewDelegate
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.topADS.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    CBAppADCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:RIDCBAppADCell forIndex:index];
//    cell.backgroundColor = _datas[index];
//    cell.label.text = [NSString stringWithFormat:@"index->%ld",index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*0.8, CGRectGetHeight(pageView.frame)*0.8);
    layout.itemSpacing = 15;
    //layout.minimumAlpha = 0.3;
//    layout.itemHorizontalCenter = _horCenterSwitch.isOn;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
//    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}

#pragma mark - layz
- (NSMutableArray *)lives {
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}

- (TYCyclePagerView *)cyclePagerView {
    if (!_cyclePagerView) {
        _cyclePagerView = [[TYCyclePagerView alloc]init];
        _cyclePagerView.layer.borderWidth = 1;
        _cyclePagerView.isInfiniteLoop = YES;
        _cyclePagerView.autoScrollInterval = 3.0;
        _cyclePagerView.dataSource = self;
        _cyclePagerView.delegate = self;
        // registerClass or registerNib
        [_cyclePagerView registerClass:[CBAppADCell class] forCellWithReuseIdentifier:@"cellId"];
    }
    return _cyclePagerView;
}


@end
