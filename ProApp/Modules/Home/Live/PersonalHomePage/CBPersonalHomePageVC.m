//
//  CBPersonalHomePageVC.m
//  ProApp
//
//  Created by hxbjt on 2018/7/13.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBPersonalHomePageVC.h"
#import "CBPersonalHomePageNavView.h"
#import "CBPersonalHomePageBottomView.h"
#import "CBPersonalHomePageHeadView.h"
#import "CBAttentionCell.h"
#import "CBVerticalFlowLayout.h"
#import "CBVideoScrollVC.h"
#import "CBShortVideoVO.h"

static NSString * const reuseIdentifier = @"CBAttentionCell";
static NSString * const CBPersonalHomePageHeadViewReuseIdentifier = @"CBPersonalHomePageHeadViewReuseIdentifier";


@interface CBPersonalHomePageVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cellDataAry;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) CBPersonalHomePageNavView *navView;
@property (nonatomic, strong) CBPersonalHomePageBottomView *bottomView;
@property (nonatomic, strong) CBPersonalHomePageHeadView *headView;

@end

@implementation CBPersonalHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *url = urlGetVideos;
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


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(kScreenWidth, 180);
        } else {
            return CGSizeMake(kScreenWidth, 108);
        }
    } else {
        return CGSizeMake(kScreenWidth/2-0.5, 245);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CBPersonalHomePageHeadView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CBPersonalHomePageHeadViewReuseIdentifier forIndexPath:indexPath];
            return cell;
        } else {
            CBPersonalHomePageHeadView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CBPersonalHomePageHeadViewReuseIdentifier forIndexPath:indexPath];
            return cell;
        }
    } else {
        CBAttentionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.video = self.cellDataAry[indexPath.row];
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return self.cellDataAry.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 跳转播放器
    CBVideoScrollVC *liveVC = [[CBVideoScrollVC alloc] initWithLives:self.cellDataAry currentIndex:indexPath.row];
    [self.navigationController pushViewController:liveVC animated:YES];
}

#pragma mark - layz

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CBAttentionCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CBPersonalHomePageHeadView class]) bundle:nil] forCellWithReuseIdentifier:CBPersonalHomePageHeadViewReuseIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)cellDataAry {
    if (!_cellDataAry) {
        _cellDataAry = [NSMutableArray array];
    }
    return _cellDataAry;
}

- (CBPersonalHomePageNavView *)navView {
    if (!_navView) {
        _navView = [CBPersonalHomePageNavView viewFromXib];
        _navView.frame = CGRectMake(0, 0, kScreenWidth, SafeAreaTopHeight);
    }
    return _navView;
}

- (CBPersonalHomePageBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [CBPersonalHomePageBottomView viewFromXib];
        CGFloat height = kScreenHeight - SafeAreaBottomHeight - 50 - SafeAreaTopHeight;
        _bottomView.frame = CGRectMake(0, height, kScreenWidth, 50);
    }
    return _bottomView;
}

@end
