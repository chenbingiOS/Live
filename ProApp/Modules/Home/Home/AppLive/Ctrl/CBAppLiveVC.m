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
#import "CBAppLiveCell.h"
#import "CBRefreshGifHeader.h"
// Model
#import "CBAppADVO.h"
#import "CBAppLiveVO.h"


@interface CBAppLiveVC () <TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

@property (nonatomic, strong) TYCyclePagerView *cyclePagerView;     ///< 广告UI
@property (nonatomic, strong) TYPageControl *pageControl;           ///< 指示器UI
@property (nonatomic, strong) NSMutableArray *lives;                ///< 直播数据
@property (nonatomic, strong) NSArray <CBAppADVO *> *appADs;        ///< 广告数据
@property (nonatomic, assign) NSUInteger currentPage;               ///< 当前页

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
    
    self.tableView.backgroundColor = [UIColor bgColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGFloat height = kScreenWidth / 2;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    [headerView addSubview:self.cyclePagerView];
    [headerView addSubview:self.pageControl];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.mj_header = [CBRefreshGifHeader headerWithRefreshingBlock:^{
        self.lives = [NSMutableArray array];
        self.currentPage = 1;
        // 获取顶部的广告
        [self httpAD];
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

- (void)httpAD {
    NSString *url = getAD;
    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        NSArray *result = responseObject[@"data"];
        self.appADs = [NSArray modelArrayWithClass:[CBAppADVO class] json:result];
        self.pageControl.numberOfPages = self.appADs.count;
        [self.cyclePagerView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showAutoMessage:@"网络异常"];
    }];
}

- (void)httpLive {
    NSString *url = [NSString stringWithFormat:getHostLive, self.currentPage];
    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSArray *listAry = [NSArray modelArrayWithClass:[CBAppLiveVO class] json:responseObject[@"data"][@"list"]];
        [self.lives addObjectsFromArray:listAry];
        [self.tableView reloadData];
        
        if (listAry.count == 0) {
            [MBProgressHUD showAutoMessage:@"暂时没有更多最新数据"];
            // 恢复当前页
            self.currentPage--;
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.currentPage--;
        [MBProgressHUD showAutoMessage:@"网络异常"];
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
    return self.appADs.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    CBAppADCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:RIDCBAppADCell forIndex:index];
    cell.appAdVO = self.appADs[index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc] init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*0.884, CGRectGetHeight(pageView.frame)*0.92);
    layout.itemSpacing = 1;
    layout.itemHorizontalCenter = YES;
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.pageControl.currentPage = toIndex;
//    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}

#pragma mark - layz
- (NSMutableArray *)lives {
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}

- (NSArray<CBAppADVO *> *)appADs {
    if (!_appADs) {
        _appADs = [NSArray new];
    }
    return _appADs;
}

- (TYCyclePagerView *)cyclePagerView {
    if (!_cyclePagerView) {
        CGFloat height = kScreenWidth / 2;
        _cyclePagerView = [[TYCyclePagerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
        _cyclePagerView.backgroundColor = [UIColor bgColor];
        _cyclePagerView.dataSource = self;
        _cyclePagerView.delegate = self;
        
        _cyclePagerView.autoScrollInterval = 4;
        _cyclePagerView.isInfiniteLoop = YES;
        
        // registerClass or registerNib
        [_cyclePagerView registerNib:[UINib nibWithNibName:@"CBAppADCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:RIDCBAppADCell];
    }
    return _cyclePagerView;
}

- (TYPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[TYPageControl alloc] initWithFrame:CGRectMake(0, kScreenWidth/2-35, kScreenWidth, 26)];
        _pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
    }
    return _pageControl;
}

@end
