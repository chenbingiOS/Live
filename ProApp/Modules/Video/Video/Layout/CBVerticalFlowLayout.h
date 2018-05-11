//
//  CBVerticalFlowLayout.h
//  ProApp
//
//  Created by 陈冰 on 2018/5/11.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBVerticalFlowLayout;

@protocol CBVerticalFlowLayoutDelegate <NSObject>

@optional

/**
 * 需要显示的列数, 默认3
 
 @param waterflowLayout CBVerticalFlowLayout
 @param collectionView collectionView
 @return 列数
 */
- (NSInteger)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView;

/**
 * 列间距, 默认10
 
 @param waterflowLayout CBVerticalFlowLayout
 @param collectionView collectionView
 @return 列间距
 */
- (CGFloat)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView;

/**
 * 行间距, 默认10
 
 @param waterflowLayout CBVerticalFlowLayout
 @param collectionView collectionView
 @return 行间距
 */
- (CGFloat)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 距离collectionView四周的间距, 默认{20, 10, 10, 10}
 
 @param waterflowLayout CBVerticalFlowLayout
 @param collectionView collectionView
 @return  UIEdgeInsets
 */
- (UIEdgeInsets)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView;

@required
/**
 *  要求实现
 *
 *  @param waterflowLayout 哪个布局需要代理返回高度
 *  @param  indexPath          对应的cell, 的indexPath, 但是indexPath.section == 0
 *  @param itemWidth           layout内部计算的宽度
 *
 *  @return 需要代理高度对应的cell的高度
 */
- (CGFloat)cb_waterflowLayout:(CBVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@end

@interface CBVerticalFlowLayout : UICollectionViewLayout

/**
 *  layout的代理
 */
- (instancetype)initWithDelegate:(id<CBVerticalFlowLayoutDelegate>)delegate;

+ (instancetype)flowLayoutWithDelegate:(id<CBVerticalFlowLayoutDelegate>)delegate;

@end
