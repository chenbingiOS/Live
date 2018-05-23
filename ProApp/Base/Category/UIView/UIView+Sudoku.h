//
//  UIView+Sudoku.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Sudoku)

- (void)sudokuView:(NSArray <UIView *> *)views;

- (void)sudokuView:(NSArray <UIView *> *)views
      totalColumns:(NSInteger)totalColumns;

- (void)sudokuView:(NSArray <UIView *> *)views
      totalColumns:(NSInteger)totalColumns
cellWidthAndHeight:(CGFloat)cellWidthAndHeight;

- (void)sudokuView:(NSArray <UIView *> *)views
      totalColumns:(NSInteger)totalColumns
         cellWidth:(CGFloat)cellWidth
        cellHeight:(CGFloat)cellHeight;

- (void)sudokuView:(NSArray <UIView *> *)views
      totalColumns:(NSInteger)totalColumns
         cellWidth:(CGFloat)cellWidth
        cellHeight:(CGFloat)cellHeight
         cellSpace:(CGFloat)cellSpace;

@end
