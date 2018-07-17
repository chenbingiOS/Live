//
//  CBRechargeVO.h
//  ProApp
//
//  Created by hxbjt on 2018/7/17.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBRechargeVO : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *money_num;       ///< 人民币
@property (nonatomic, strong) NSString *diamond_num;    ///< 钻石 数量
@property (nonatomic, assign) BOOL select;

@end
