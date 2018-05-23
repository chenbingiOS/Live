//
//  CBBaseVideoVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBBaseVideoVC.h"
#import "ALinUser.h"
#import "CBAttentionCell.h"
//#import "ALinRefreshGifHeader.h"
//#import "ALinLiveCollectionViewController.h"
#import "ALinLive.h"
#import "CBVerticalFlowLayout.h"

@interface CBBaseVideoVC () <CBVerticalFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *anchors;   /** 最新主播列表 */
@property (nonatomic, assign) NSUInteger currentPage;    /** 当前页 */

@end

static NSString * const reuseIdentifier = @"CBAttentionCell";

@implementation CBBaseVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注";
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.collectionView];
    
    self.currentPage = 1;
//    self.collectionView.mj_header = [ALinRefreshGifHeader headerWithRefreshingBlock:^{
//        self.currentPage = 1;
//        self.anchors = [NSMutableArray array];
//        [self getAnchorsList];
//    }];
//    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.currentPage++;
//        [self getAnchorsList];
//    }];
//    [self.collectionView.mj_header beginRefreshing];

}

- (void)autoRefresh {
//    [self.collectionView.mj_header beginRefreshing];
//    NSLog(@"刷新最新主播界面");
}

// 获取数据
- (void)getAnchorsList {
//    [[ALinNetworkTool shareTool] GET:[NSString stringWithFormat:@"http://live.9158.com/Room/GetNewRoomOnline?page=%ld", self.currentPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [self.collectionView.mj_header endRefreshing];
//        [self.collectionView.mj_footer endRefreshing];
//        NSString *statuMsg = responseObject[@"msg"];
//        if ([statuMsg isEqualToString:@"fail"]) { // 数据已经加载完毕, 没有更多数据了
//            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
//            [self showHint:@"暂时没有更多最新数据"];
//            // 恢复当前页
//            self.currentPage--;
//        } else {
//            [responseObject[@"data"][@"list"] writeToFile:@"/Users/apple/Desktop/user.plist" atomically:YES];
//            NSArray *result = [ALinUser mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
//            if (result.count) {
//                [self.anchors addObjectsFromArray:result];
//                [self.collectionView reloadData];
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self.collectionView.mj_header endRefreshing];
//        [self.collectionView.mj_footer endRefreshing];
//        self.currentPage--;
//        [self showHint:@"网络异常"];
//    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.anchors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBAttentionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.user = self.anchors[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    ALinLiveCollectionViewController *liveVc = [[ALinLiveCollectionViewController alloc] init];
//    NSMutableArray *array = [NSMutableArray array];
//    for (ALinUser *user in self.anchors) {
//        ALinLive *live = [[ALinLive alloc] init];
//        live.bigpic = user.photo;
//        live.myname = user.nickname;
//        live.smallpic = user.photo;
//        live.gps = user.position;
//        live.useridx = user.useridx;
//        live.allnum = arc4random_uniform(2000);
//        live.flv = user.flv;
//        [array addObject:live];
//    }
//    liveVc.lives = array;
//    liveVc.currentIndex = indexPath.item;
//    [self presentViewController:liveVc animated:YES completion:nil];
}


#pragma mark - CBVerticalFlowLayoutDelegate
/**.
 * 设置cell的高度
 @param indexPath 索引
 @param itemWidth 宽度
 */
- (CGFloat)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    return itemWidth * 236 / 170;
}

// 需要显示的列数, 默认3
- (NSInteger)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

#pragma mark - layz
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        
        CBVerticalFlowLayout *layout = [[CBVerticalFlowLayout alloc]initWithDelegate:self];
        self.collectionView.collectionViewLayout = layout;
        
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];

        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CBAttentionCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}
- (NSMutableArray *)anchors {
    if (!_anchors) {
        _anchors = [NSMutableArray array];
    }
    return _anchors;
}

@end
