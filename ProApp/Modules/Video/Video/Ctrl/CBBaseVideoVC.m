//
//  CBBaseVideoVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/24.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBBaseVideoVC.h"
#import "CBAttentionCell.h"
#import "CBRefreshGifHeader.h"
#import "CBAppLiveVO.h"
#import "CBVerticalFlowLayout.h"
#import "CBShortVideoVO.h"
#import "CBShortVideoVC.h"
#import "CBLiveVC.h"
#import "CBVideoScrollVC.h"

@interface CBBaseVideoVC () <CBVerticalFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cellDataAry;
@property (nonatomic, assign) NSUInteger currentPage;

@end

static NSString * const reuseIdentifier = @"CBAttentionCell";

@implementation CBBaseVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupUI {
    [self.view addSubview:self.collectionView];
    self.currentPage = 1;
    self.collectionView.mj_header = [CBRefreshGifHeader headerWithRefreshingBlock:^{
        [self reloadAllData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self httpGetVideos];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)httpGetVideos {
    [self.collectionView ly_startLoading];
    NSString *url = self.url;
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
        [self.collectionView ly_endLoading];
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.currentPage--;
    }];
}

- (void)reloadAllData {
    self.currentPage = 1;
    self.cellDataAry = [NSMutableArray array];
    [self httpGetVideos];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBAttentionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.video = self.cellDataAry[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 跳转播放器
    CBVideoScrollVC *liveVC = [[CBVideoScrollVC alloc] initWithLives:self.cellDataAry currentIndex:indexPath.row];
    [self.navigationController pushViewController:liveVC animated:YES];
}


#pragma mark - CBVerticalFlowLayoutDelegate

- (CGFloat)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    return itemWidth * 236 / 170;
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

- (void)setUrl:(NSString *)url {
    _url = url;
    [self setupUI];
}
@end
