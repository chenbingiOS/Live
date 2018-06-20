//
//  CBAnchorInfoVO.m
//  ProApp
//
//  Created by hxbjt on 2018/6/20.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBAnchorInfoVO.h"

@implementation CBAnchorInfoVO

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"guard" : [CBLiveUser class],
             @"gong" : [CBLiveUser class]};
}


@end
