//
//  CBHorizontalFlowLayout.h
//  ProApp
//
//  Created by 陈冰 on 2018/5/14.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBVerticalFlowLayout.h"


@class CBHorizontalFlowLayout;

@protocol CBHorizontalFlowLayoutDelegate <NSObject>

@required
/**
 *  cell的高度
 *
 *  @param waterflowLayout 哪个布局需要代理返回高度
 *  @param  indexPath          对应的cell, 的indexPath, 但是indexPath.section == 0
 *  @param itemHeight           layout内部计算的高度
 *
 *  @return 需要代理高度对应的cell的高度
 */
- (CGFloat)cb_waterflowLayout:(CBHorizontalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight;
@optional

/**
 *  需要显示的行数, 默认3
 */
- (NSInteger)cb_waterflowLayout:(CBHorizontalFlowLayout *)waterflowLayout linesInCollectionView:(UICollectionView *)collectionView;
/**
 *  列间距, 默认10
 */
- (CGFloat)cb_waterflowLayout:(CBHorizontalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView columnsMarginForItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  行间距, 默认10
 */
- (CGFloat)cb_waterflowLayout:(CBHorizontalFlowLayout *)waterflowLayout linesMarginInCollectionView:(UICollectionView *)collectionView;

/**
 *  距离collectionView四周的间距, 默认{10, 10, 10, 10}
 */
- (UIEdgeInsets)cb_waterflowLayout:(CBHorizontalFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView;

@end

@interface CBHorizontalFlowLayout : UICollectionViewLayout

/**
 *  layout的代理
 */
- (instancetype)initWithDelegate:(id<CBHorizontalFlowLayoutDelegate>)delegate;

+ (instancetype)flowLayoutWithDelegate:(id<CBHorizontalFlowLayoutDelegate>)delegate;

@end
