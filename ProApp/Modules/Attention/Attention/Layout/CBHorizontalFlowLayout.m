//
//  CBHorizontalFlowLayout.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/14.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBHorizontalFlowLayout.h"

#define ZJXX(x) floorf(x)
#define ZJXS(s) ceilf(s)

static const NSInteger      cb_Lines = 3;
static const CGFloat        cb_XMargin = 10;
static const CGFloat        cb_YMargin = 10;
static const UIEdgeInsets   cb_EdgeInsets = {10, 10, 10, 10};


@interface CBHorizontalFlowLayout()
/** 所有的cell的attrbts */
@property (nonatomic, strong) NSMutableArray *cb_AtrbsArray;

/** 每一列的最后的高度 */
@property (nonatomic, strong) NSMutableArray *cb_LinesWidthArray;

- (NSInteger)lines;

- (CGFloat)xMarginAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)yMargin;

- (UIEdgeInsets)edgeInsets;
@end

@implementation CBHorizontalFlowLayout

/**
 *  刷新布局的时候回重新调用
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    //如果重新刷新就需要移除之前存储的高度
    [self.cb_LinesWidthArray removeAllObjects];
    
    //复赋值以顶部的高度, 并且根据列数
    for (NSInteger i = 0; i < self.lines; i++) {
        
        [self.cb_LinesWidthArray addObject:@(self.edgeInsets.left)];
    }
    
    // 移除以前计算的cells的attrbs
    [self.cb_AtrbsArray removeAllObjects];
    
    // 并且重新计算, 每个cell对应的atrbs, 保存到数组
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++)
    {
        [self.cb_AtrbsArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    
    
    
}


/**
 *在这里边所处每个cell对应的位置和大小
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *atrbs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat h = 1.0 * (self.collectionView.frame.size.height - self.edgeInsets.top - self.edgeInsets.bottom - self.yMargin * (self.lines - 1)) / self.lines;
    
    h = ZJXX(h);
    
    // 宽度由外界决定, 外界必须实现这个方法
    CGFloat w = [self.delegate cb_waterflowLayout:self collectionView:self.collectionView widthForItemAtIndexPath:indexPath itemHeight:h];
    
    // 拿到最后的高度最小的那一列, 假设第0列最小
    NSInteger indexLine = 0;
    CGFloat minLineW = [self.cb_LinesWidthArray[indexLine] doubleValue];
    
    for (NSInteger i = 1; i < self.cb_LinesWidthArray.count; i++)
    {
        CGFloat lineW = [self.cb_LinesWidthArray[i] doubleValue];
        if(minLineW > lineW)
        {
            minLineW = lineW;
            indexLine = i;
        }
    }
    
    
    CGFloat x = [self xMarginAtIndexPath:indexPath] + minLineW;
    
    if (minLineW == self.edgeInsets.left) {
        x = self.edgeInsets.left;
    }
    
    CGFloat y = self.edgeInsets.top + (self.yMargin + h) * indexLine;
    
    // 赋值frame
    atrbs.frame = CGRectMake(x, y, w, h);
    
    // 覆盖添加完后那一列;的最新宽度
    self.cb_LinesWidthArray[indexLine] = @(CGRectGetMaxX(atrbs.frame));
    
    return atrbs;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.cb_AtrbsArray;
}


- (CGSize)collectionViewContentSize
{
    __block CGFloat maxColW = [self.cb_LinesWidthArray[0] doubleValue];
    
    [self.cb_LinesWidthArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (maxColW < [obj doubleValue]) {
            maxColW = [obj doubleValue];
        }
        
    }];
    
    return CGSizeMake(maxColW + self.edgeInsets.right, self.collectionView.frame.size.height);
}


- (NSMutableArray *)cb_AtrbsArray
{
    if(!_cb_AtrbsArray)
    {
        _cb_AtrbsArray = [NSMutableArray array];
    }
    return _cb_AtrbsArray;
}

- (NSMutableArray *)cb_LinesWidthArray
{
    if(_cb_LinesWidthArray == nil)
    {
        _cb_LinesWidthArray = [NSMutableArray array];
    }
    return _cb_LinesWidthArray;
}

- (NSInteger)lines
{
    if([self.delegate respondsToSelector:@selector(cb_waterflowLayout:linesInCollectionView:)])
    {
        return [self.delegate cb_waterflowLayout:self linesInCollectionView:self.collectionView];
    }
    else
    {
        return cb_Lines;
    }
}

- (CGFloat)xMarginAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(cb_waterflowLayout:collectionView:columnsMarginForItemAtIndexPath:)])
    {
        return [self.delegate cb_waterflowLayout:self collectionView:self.collectionView columnsMarginForItemAtIndexPath:indexPath];
    }
    else
    {
        return cb_XMargin;
    }
}

- (CGFloat)yMargin
{
    if([self.delegate respondsToSelector:@selector(cb_waterflowLayout:linesMarginInCollectionView:)])
    {
        return [self.delegate cb_waterflowLayout:self linesMarginInCollectionView:self.collectionView];
    }else
    {
        return cb_YMargin;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if([self.delegate respondsToSelector:@selector(cb_waterflowLayout:edgeInsetsInCollectionView:)])
    {
        return [self.delegate cb_waterflowLayout:self edgeInsetsInCollectionView:self.collectionView];
    }
    else
    {
        return cb_EdgeInsets;
    }
}

- (id<CBHorizontalFlowLayoutDelegate>)delegate
{
    return (id<CBHorizontalFlowLayoutDelegate>)self.collectionView.dataSource;
}

- (instancetype)initWithDelegate:(id<CBHorizontalFlowLayoutDelegate>)delegate
{
    if (self = [super init]) {
        
    }
    return self;
}


+ (instancetype)flowLayoutWithDelegate:(id<CBHorizontalFlowLayoutDelegate>)delegate
{
    return [[self alloc] initWithDelegate:delegate];
}



@end
