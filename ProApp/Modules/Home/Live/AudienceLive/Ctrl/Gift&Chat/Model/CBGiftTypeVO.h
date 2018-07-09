//
//  CBGiftTypeVO.h
//  ProApp
//
//  Created by hxbjt on 2018/6/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBGiftVO;
@interface CBGiftTypeVO : NSObject

@property (nonatomic, copy) NSArray <CBGiftVO *> *putong;
@property (nonatomic, copy) NSArray <CBGiftVO *> *guizu;
@property (nonatomic, copy) NSArray <CBGiftVO *> *xingyun;
@property (nonatomic, copy) NSArray <CBGiftVO *> *changku;

@end
