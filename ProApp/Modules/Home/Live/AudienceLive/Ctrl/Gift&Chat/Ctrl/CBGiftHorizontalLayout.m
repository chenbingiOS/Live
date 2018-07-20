//
//  CBGiftHorizontalLayout.m
//  ProApp
//
//  Created by hxbjt on 2018/7/20.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBGiftHorizontalLayout.h"

@interface CBGiftHorizontalLayout()
/** 存放cell全部布局属性 */
@property(nonatomic,strong) NSMutableArray *cellAttributesArray;

@end

@implementation CBGiftHorizontalLayout

- (NSMutableArray *)cellAttributesArray{
    if (!_cellAttributesArray) {
        _cellAttributesArray = [NSMutableArray array];
    }
    return _cellAttributesArray;
}

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat itemW = kScreenWidth/4.0-0.25;
    CGFloat itemH = 95;
    self.itemSize = CGSizeMake(kScreenWidth/4-0.25, 95);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 刷新后清除所有已布局的属性 重新获取
    [self.cellAttributesArray removeAllObjects];
    
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attibute = [self layoutAttributesForItemAtIndexPath:indexPath];
        NSInteger page = i / 8;//第几页
        NSInteger row = i % 4 + page*4;//第几列
        NSInteger col = i / 4 - page*2;//第几行
        attibute.frame = CGRectMake(row*itemW, col*itemH, itemW, itemH);
        [self.cellAttributesArray addObject:attibute];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.cellAttributesArray;
}

- (CGSize)collectionViewContentSize {
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger page = cellCount / 8 + 1;
    return CGSizeMake(kScreenWidth*page, 0);
}


@end
