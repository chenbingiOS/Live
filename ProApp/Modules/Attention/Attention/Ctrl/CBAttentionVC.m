//
//  CBAttentionVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBAttentionVC.h"
#import "ALinUser.h"
#import "CBAttentionCell.h"
#import "ALinHomeFlowLayout.h"
#import "ALinRefreshGifHeader.h"
#import "ALinLiveCollectionViewController.h"
#import "ALinLive.h"

@interface CBAttentionVC ()

@property (nonatomic, strong) NSMutableArray *anchors;   /** 最新主播列表 */
@property (nonatomic, assign) NSUInteger currentPage;    /** 当前页 */
@property (nonatomic, strong) NSTimer *timer;            /** NSTimer */

@end

@implementation CBAttentionVC

static NSString * const reuseIdentifier = @"CBAttentionCell";

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat wh = (kScreenWidth - 4) / 2.0;
    layout.itemSize = CGSizeMake(wh , wh);
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 1;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 首先自动刷新一次
    [self autoRefresh];
    // 然后开启每一分钟自动更新
    _timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(autoRefresh) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注";
    [self setup_collectionView];
}

- (void)setup_collectionView {
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CBAttentionCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.currentPage = 1;
    self.collectionView.mj_header = [ALinRefreshGifHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        self.anchors = [NSMutableArray array];
        [self getAnchorsList];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getAnchorsList];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)autoRefresh {
    [self.collectionView.mj_header beginRefreshing];
    NSLog(@"刷新最新主播界面");
}

// 获取数据
- (void)getAnchorsList {
    [[ALinNetworkTool shareTool] GET:[NSString stringWithFormat:@"http://live.9158.com/Room/GetNewRoomOnline?page=%ld", self.currentPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        NSString *statuMsg = responseObject[@"msg"];
        if ([statuMsg isEqualToString:@"fail"]) { // 数据已经加载完毕, 没有更多数据了
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            [self showHint:@"暂时没有更多最新数据"];
            // 恢复当前页
            self.currentPage--;
        } else {
            [responseObject[@"data"][@"list"] writeToFile:@"/Users/apple/Desktop/user.plist" atomically:YES];
            NSArray *result = [ALinUser mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (result.count) {
                [self.anchors addObjectsFromArray:result];
                [self.collectionView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.currentPage--;
        [self showHint:@"网络异常"];
    }];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.anchors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBAttentionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.user = self.anchors[indexPath.item];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALinLiveCollectionViewController *liveVc = [[ALinLiveCollectionViewController alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    for (ALinUser *user in self.anchors) {
        ALinLive *live = [[ALinLive alloc] init];
        live.bigpic = user.photo;
        live.myname = user.nickname;
        live.smallpic = user.photo;
        live.gps = user.position;
        live.useridx = user.useridx;
        live.allnum = arc4random_uniform(2000);
        live.flv = user.flv;
        [array addObject:live];
    }
    liveVc.lives = array;
    liveVc.currentIndex = indexPath.item;
    [self presentViewController:liveVc animated:YES completion:nil];
}

#pragma mark - layz
- (NSMutableArray *)anchors {
    if (!_anchors) {
        _anchors = [NSMutableArray array];
    }
    return _anchors;
}

@end
