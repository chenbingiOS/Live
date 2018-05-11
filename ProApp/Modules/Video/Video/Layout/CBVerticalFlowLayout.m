//
//  CBVerticalFlowLayout.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/11.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBVerticalFlowLayout.h"

#define ZJXX(x) floorf(x)
#define ZJXS(s) ceilf(s)

static const NSInteger cb_Columns_ = 3;
static const CGFloat cb_XMargin_ = 10;
static const CGFloat cb_YMargin_ = 10;
static const UIEdgeInsets cb_EdgeInsets_ = {10, 10, 10, 10};

@interface CBVerticalFlowLayout()
/** 所有的cell的attrbts */
@property (nonatomic, strong) NSMutableArray *cb_AtrbsArray;

/** 每一列的最后的高度 */
@property (nonatomic, strong) NSMutableArray *cb_ColumnsHeightArray;

- (NSInteger)columns;
- (CGFloat)xMargin;
- (CGFloat)yMarginAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)edgeInsets;

@end

@implementation CBVerticalFlowLayout

/**
 *  刷新布局的时候回重新调用
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    //如果重新刷新就需要移除之前存储的高度
    [self.cb_ColumnsHeightArray removeAllObjects];
    
    //复赋值以顶部的高度, 并且根据列数
    for (NSInteger i = 0; i < self.columns; i++) {
        [self.cb_ColumnsHeightArray addObject:@(self.edgeInsets.top)];
    }
    
    // 移除以前计算的cells的attrbs
    [self.cb_AtrbsArray removeAllObjects];
    
    // 并且重新计算, 每个cell对应的atrbs, 保存到数组
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        [self.cb_AtrbsArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
}

/**
 *在这里边所处每个cell对应的位置和大小
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *atrbs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat w = 1.0 * (self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right - self.xMargin * (self.columns - 1)) / self.columns;
    w = ZJXX(w);
    
    // 高度由外界决定, 外界必须实现这个方法
    CGFloat h = [self.delegate cb_waterflowLayout:self collectionView:self.collectionView heightForItemAtIndexPath:indexPath itemWidth:w];
    // 拿到最后的高度最小的那一列, 假设第0列最小
    NSInteger indexCol = 0;
    CGFloat minColH = [self.cb_ColumnsHeightArray[indexCol] doubleValue];
    for (NSInteger i = 1; i < self.cb_ColumnsHeightArray.count; i++){
        CGFloat colH = [self.cb_ColumnsHeightArray[i] doubleValue];
        if(minColH > colH) {
            minColH = colH;
            indexCol = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + (self.xMargin + w) * indexCol;
    CGFloat y = minColH + [self yMarginAtIndexPath:indexPath];
    // 是第一行
    if (minColH == self.edgeInsets.top) {
        y = self.edgeInsets.top;
    }
    // 赋值frame
    atrbs.frame = CGRectMake(x, y, w, h);
    // 覆盖添加完后那一列;的最新高度
    self.cb_ColumnsHeightArray[indexCol] = @(CGRectGetMaxY(atrbs.frame));
    
    return atrbs;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.cb_AtrbsArray;
}

- (CGSize)collectionViewContentSize {
    CGFloat maxColH = [self.cb_ColumnsHeightArray.firstObject doubleValue];
    for (NSInteger i = 1; i<self.cb_ColumnsHeightArray.count; i++) {
        CGFloat colH = [self.cb_ColumnsHeightArray[i] doubleValue];
        if (maxColH<colH) {
            maxColH = colH;
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, maxColH + self.edgeInsets.bottom);
}

- (NSInteger)columns {
    if ([self.delegate respondsToSelector:@selector(cb_waterflowLayout:columnsInCollectionView:)]) {
        return [self.delegate cb_waterflowLayout:self columnsInCollectionView:self.collectionView];
    } else {
        return cb_Columns_;
    }
}

- (CGFloat)xMargin {
    if ([self.delegate respondsToSelector:@selector(cb_waterflowLayout:columnsMarginInCollectionView:)]) {
        return [self.delegate cb_waterflowLayout:self columnsMarginInCollectionView:self.collectionView];
    } else {
        return cb_XMargin_;
    }
}

- (CGFloat)yMarginAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(cb_waterflowLayout:collectionView:linesMarginForItemAtIndexPath:)]) {
        return [self.delegate cb_waterflowLayout:self collectionView:self.collectionView linesMarginForItemAtIndexPath:indexPath];
    } else {
        return cb_YMargin_;
    }
}

- (id<CBVerticalFlowLayoutDelegate>)delegate {
    return (id<CBVerticalFlowLayoutDelegate>)self.collectionView.dataSource;
}

- (UIEdgeInsets) edgeInsets {
    if([self.delegate respondsToSelector:@selector(cb_waterflowLayout:edgeInsetsInCollectionView:)]) {
        return [self.delegate cb_waterflowLayout:self edgeInsetsInCollectionView:self.collectionView];
    } else {
        return cb_EdgeInsets_;
    }
}

- (instancetype)initWithDelegate:(id<CBVerticalFlowLayoutDelegate>)delegate {
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)flowLayoutWithDelegate:(id<CBVerticalFlowLayoutDelegate>)delegate {
    return [[self alloc]initWithDelegate:delegate];
}

- (NSMutableArray *)cb_ColumnsHeightArray {
    if (!_cb_ColumnsHeightArray) {
        _cb_ColumnsHeightArray = [NSMutableArray array];
    }
    return _cb_ColumnsHeightArray;
}

- (NSMutableArray *)cb_AtrbsArray {
    if (!_cb_AtrbsArray) {
        _cb_AtrbsArray = [NSMutableArray array];
    }
    return _cb_AtrbsArray;
}

@end
