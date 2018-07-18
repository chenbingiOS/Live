//
//  CBRechargeView.m
//  ProApp
//
//  Created by hxbjt on 2018/7/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBRechargeView.h"
#import "CBRechargeViewCell.h"
#import "CBRechargeVO.h"
#import "CBVerticalFlowLayout.h"
#import "IAPManager.h"

@interface CBRechargeView () <UICollectionViewDelegate, UICollectionViewDataSource, CBVerticalFlowLayoutDelegate>

@property (weak, nonatomic) IBOutlet CBVerticalFlowLayout *verticalFlowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (nonatomic, strong) NSArray <CBRechargeVO *> *cellDataAry;
@property (nonatomic, copy) NSString *productID;

@end

@implementation CBRechargeView

- (IBAction)actionTopUpBtn:(id)sender {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.productID = @"3";
    [[IAPManager shareIAPManager] requestProductID:self.productID success:^(NSString *productID, NSData *receiptData) {
        [MBProgressHUD hideHUDForView:self animated:YES];
#warning 后续逻辑还未考虑
    } failure:^(IAPPaymentTransactionFailState state, NSString *failDesc) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        [MBProgressHUD showAutoMessage:failDesc];
    } finish:^{
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}



- (void)httpGetInfo {
    NSString *url = urlGetRechargePackage;
    NSDictionary *param = @{@"token":[CBLiveUserConfig getOwnToken]};
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        self.cellDataAry = [NSArray modelArrayWithClass:[CBRechargeVO class] json:responseObject[@"data"][@"details"]];
        CBRechargeVO *vo = [self.cellDataAry firstObject];
        vo.select = YES;
        self.productID = vo.ID;
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failure:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}

- (void)setCellDataAry:(NSArray *)cellDataAry {
    _cellDataAry = cellDataAry;

    self.collection.dataSource = self;
    self.collection.delegate = self;
    [self.collection registerNib:[UINib nibWithNibName:@"CBRechargeViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CBRechargeViewCell"];
    [self.collection reloadData];
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellDataAry.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {    
    CBRechargeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CBRechargeViewCell" forIndexPath:indexPath];
    cell.rechargeVO = self.cellDataAry[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (CBRechargeVO *rvo in self.cellDataAry) {
        rvo.select = NO;
    }
    CBRechargeVO *vo = self.cellDataAry[indexPath.row];
    vo.select = YES;
    self.productID = vo.ID;
    [collectionView reloadData];
}

#pragma mark - CBVerticalFlowLayoutDelegate

- (CGFloat)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    return itemWidth * 70/105;
}

- (NSInteger)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView{
    return 3;
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

@end

@implementation CBRechargePopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置参数 (否则用默认值)
        self.popType = PopTypeMove;
        self.moveAppearCenterY = kScreenHeight - self.height/2;
        self.moveAppearDirection = MoveAppearDirectionFromBottom;
        self.moveDisappearDirection = MoveDisappearDirectionToBottom;
        self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.animateDuration = 0.35;
        self.radius = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.rechargeView];

    }
    return self;
}

- (CBRechargeView *)rechargeView {
    if (!_rechargeView) {
        _rechargeView = [CBRechargeView viewFromXib];
        _rechargeView.frame = CGRectMake(0, 0, kScreenWidth, 295);
        [_rechargeView httpGetInfo];
    }
    return _rechargeView;
}

@end


