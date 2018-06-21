//
//  CBLiveGuardianListView.m
//  EaseMobLiveDemo
//
//  Created by EaseMob on 16/7/15.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import "CBLiveGuardianListView.h"
#import "CBOccupantsCountView.h"
#import "CBLiveCastView.h"
#import "CBAppLiveVO.h"

#define kCollectionIdentifier @"collectionCell"

@interface CBLiveGuardianCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *headerImage;

@end

@implementation CBLiveGuardianCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _headerImage = [[UIImageView alloc] init];
        _headerImage.image = [UIImage imageNamed:@"placeholder_head"];
        _headerImage.frame = CGRectMake(0, 0, 30, 30);
        _headerImage.layer.cornerRadius = 15;
        _headerImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_headerImage];
    }
    return self;
}

@end

@interface CBLiveGuardianListView () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    EasePublishModel *_model;
}
// 个人信息
@property (nonatomic, strong) CBAppLiveVO *room;
@property (nonatomic, copy)   NSString *chatRoomId;     ///< 聊天室ID

// 贡献榜单
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CBLiveCastView *liveCastView;
@property (nonatomic, strong) NSMutableArray <CBAppLiveVO *> *dataArray;

// 总人数
@property (nonatomic, strong) CBOccupantsCountView *occupantsCountView;
@property (nonatomic, assign) NSInteger occupantsCount;
@property (nonatomic, assign) NSUInteger currentPage;   ///< 当前页

@end

@implementation CBLiveGuardianListView

- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO*)room {
    self = [super initWithFrame:frame];
    if (self) {
        _room = room;
        [self addSubview:self.liveCastView];
        [self addSubview:self.occupantsCountView];
        [self addSubview:self.collectionView];
        _currentPage = 1;
    }
    return self;
}

- (void)httpGetGuardRankList {
    NSString *url = urlGetGuardRankList;
    NSDictionary *param = @{@"host_id": self.room.ID,
                            @"token": [CBLiveUserConfig getOwnToken],
                            @"page": @(self.currentPage)};
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            NSArray *resultList = [NSArray modelArrayWithClass:[CBAppLiveVO class] json:responseObject[@"data"]];
            if (resultList.count < 20 && self.currentPage > 1) {
                self.currentPage--;
            } else {
                self.dataArray = resultList.copy;
                [self.collectionView reloadData];
            }
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - getter

- (NSMutableArray*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView*)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        CGFloat left = _liveCastView.right + 5;
        CGFloat width = 100;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(left, 10, width, 30) collectionViewLayout:flowLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [_collectionView registerClass:[CBLiveGuardianCell class] forCellWithReuseIdentifier:kCollectionIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), 0);
        _collectionView.pagingEnabled = NO;
        _collectionView.userInteractionEnabled = YES;
    }
    return _collectionView;
}

- (CBLiveCastView*)liveCastView {
    if (!_liveCastView) {
        _liveCastView = [[CBLiveCastView alloc] initWithFrame:CGRectMake(10, 10, 118, 30.f) room:_room];
    }
    return _liveCastView;
}

- (CBOccupantsCountView *)occupantsCountView {
    if (!_occupantsCountView) {
        _occupantsCountView = [[CBOccupantsCountView alloc] initWithFrame:CGRectMake(self.width - 70, 10, 60, 30) room:_room];
        [_occupantsCountView _UI_reload];
    }
    return _occupantsCountView;
}

- (void)setDelegate:(id<CBActionLiveDelegate>)delegate {
    _delegate = delegate;
    self.liveCastView.delegate = delegate;
    self.occupantsCountView.delegate = delegate;
}

// 加载守护人员信息详细信息
- (void)loadHeaderListWithChatroomId:(NSString*)chatroomId {
    self.dataArray = [NSMutableArray array];
    [self httpGetGuardRankList];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CBLiveGuardianCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionIdentifier forIndexPath:indexPath];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row].avatar] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview = headerView;
        
    }
    if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        reusableview = footerview;
    }
    return reusableview;
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(30, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(actionTapShowOnlineUserListOrContributionList)]) {
//                [self.delegate actionTapShowOnlineUserListOrContributionList];
//            }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
