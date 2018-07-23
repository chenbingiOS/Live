//
//  UIColor+Color.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/8.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "UIColor+Color.h"

@implementation UIColor (Color)

+ (UIColor *)mainColor {
    return UIColorHex(eb51ac);
}

+ (UIColor *)titleSelectColor {
    return [self mainColor];
}

+ (UIColor *)titleNormalColor {
    return UIColorHex(666666);
}

+ (UIColor *)bgColor {
    return UIColorHex(F2F2F2);
}

+ (UIColor *)backColor {
    return UIColorHex(666666);
}

+ (UIColor *)btnSelectColor {
    return UIColorHex(939393);
}

+ (UIColor *)navTitleColor {
    return UIColorHex(444444);
}

+ (UIColor *)shadowColor {
    return UIColorHex(6A6A6A);
}

+ (UIColor *)shortVideoSelectBtnColor {
    return UIColorHex(333333);
}

+ (UIColor *)coinColor {
    return UIColorHex(FFEA00);
}
@end
