//
//  CBMyVideoVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBMyVideoVC.h"
#import "CBMyVideoCell.h"
#import "CBRefreshGifHeader.h"
#import "CBShortVideoVO.h"
#import "CBVerticalFlowLayout.h"

@interface CBMyVideoVC () <CBVerticalFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cellDataAry;
@property (nonatomic, assign) NSUInteger currentPage;    /** 当前页 */

@end

static NSString * const CBMyVideoCellID = @"CBMyVideoCellID";

@implementation CBMyVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的视频";
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.collectionView];
    
    self.currentPage = 1;
    self.collectionView.mj_header = [CBRefreshGifHeader headerWithRefreshingBlock:^{
        [self reloadAllData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self httpGetCurrentUserVideos];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)reloadAllData {
    self.currentPage = 1;
    self.cellDataAry = [NSMutableArray array];
    [self httpGetCurrentUserVideos];
}

// 获取数据
- (void)httpGetCurrentUserVideos {
    
    [self.collectionView ly_startLoading];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = urlGetCurrentUserVideos;
    NSDictionary *param = @{ @"token": [CBLiveUserConfig getOwnToken],
                             @"page": @(self.currentPage) };
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *resultList = [NSArray modelArrayWithClass:[CBShortVideoVO class] json:data];
            if (resultList.count < 20 && self.currentPage > 1) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                self.currentPage--;
            } else {
                [self.cellDataAry addObjectsFromArray:resultList];
                [self.collectionView reloadData];
            }
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.collectionView ly_endLoading];
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.currentPage--;
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBMyVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CBMyVideoCellID forIndexPath:indexPath];
    cell.video = self.cellDataAry[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    CBAppLiveVOCollectionViewController *liveVc = [[CBAppLiveVOCollectionViewController alloc] init];
    //    NSMutableArray *array = [NSMutableArray array];
    //    for (ALinUser *user in self.anchors) {
    //        CBAppLiveVO *live = [[CBAppLiveVO alloc] init];
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

- (CGFloat)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    return itemWidth * 22 / 18;
}

- (NSInteger)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (UIEdgeInsets)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return  UIEdgeInsetsMake(12, 8, 8, 8);
}

- (CGFloat)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView {
    return 8;
}

- (CGFloat)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 8;
}

#pragma mark - layz
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        
        CBVerticalFlowLayout *layout = [[CBVerticalFlowLayout alloc] initWithDelegate:self];
        self.collectionView.collectionViewLayout = layout;
        
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CBMyVideoCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CBMyVideoCellID];
        
        _collectionView.ly_emptyView = [CBEmptyView diyEmptyActionViewWithTarget:self action:@selector(reloadAllData)];
    }
    return _collectionView;
}

- (NSMutableArray *)cellDataAry {
    if (!_cellDataAry) {
        _cellDataAry = [NSMutableArray array];
    }
    return _cellDataAry;
}
@end
