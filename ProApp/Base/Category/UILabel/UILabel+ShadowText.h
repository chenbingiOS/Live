//
//  UILabel+ShadowText.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/26.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ShadowText)

- (void)shadowWtihText:(NSString *)text;
- (void)shadowWtihText:(NSString *)text shadowBlurRadius:(CGFloat)shadowBlurRadius shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset;

    
@end
