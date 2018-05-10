//
//  UIView+Sudoku.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "UIView+Sudoku.h"

@implementation UIView (Sudoku)

- (void)sudokuView:(NSArray <UIView *> *)views {
    [self sudokuView:views totalColumns:3 cellWidth:50 cellHeight:50 cellSpace:0];
}

- (void)sudokuView:(NSArray <UIView *> *)views
      totalColumns:(NSInteger)totalColumns {
    [self sudokuView:views totalColumns:totalColumns cellWidth:50 cellHeight:50 cellSpace:0];
}

- (void)sudokuView:(NSArray <UIView *> *)views
      totalColumns:(NSInteger)totalColumns
cellWidthAndHeight:(CGFloat)cellWidthAndHeight {
    [self sudokuView:views totalColumns:totalColumns cellWidth:cellWidthAndHeight cellHeight:cellWidthAndHeight cellSpace:0];
}

- (void)sudokuView:(NSArray <UIView *> *)views
      totalColumns:(NSInteger)totalColumns
         cellWidth:(CGFloat)cellWidth
        cellHeight:(CGFloat)cellHeight {
    [self sudokuView:views totalColumns:totalColumns cellWidth:cellWidth cellHeight:cellHeight cellSpace:0];
}

- (void)sudokuView:(NSArray <UIView *> *)views
      totalColumns:(NSInteger)totalColumns
         cellWidth:(CGFloat)cellWidth
        cellHeight:(CGFloat)cellHeight
         cellSpace:(CGFloat)cellSpace {
    // 总列数
    CGFloat cellW = cellWidth;
    CGFloat cellH = cellHeight;
    // 左右间隙
    CGFloat margin = (self.frame.size.width - totalColumns * cellW) / (totalColumns + 1);
    // 上下间隙
    CGFloat space = cellSpace > 0 ? cellSpace : margin;
    // 根据格子个数创建对应的框框
    for(NSInteger index = 0; index< views.count; index++) {
        UIView *cellView = views[index];
        // 计算 行号 和 列号
        NSInteger row = index / totalColumns;
        NSInteger col = index % totalColumns;
        //根据行号和列号来确定 子控件的坐标
        CGFloat cellX = margin + col * (cellW + margin);
        CGFloat cellY = row * (cellH + space);
        cellView.frame = CGRectMake(cellX, cellY, cellW, cellH);
        // 添加到view 中
        [self addSubview:cellView];
    }
}

@end
