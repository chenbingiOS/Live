//
//  CBGiftVO.h
//  ProApp
//
//  Created by hxbjt on 2018/6/25.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBGiftVO : NSObject

@property (nonatomic, strong) NSString *giftid;        ///< id    字符串(string)
@property (nonatomic, strong) NSString *giftname;      ///< 礼物名    字符串(string)
@property (nonatomic, strong) NSString *needcoin;      ///< 礼物价格    字符串(string)
@property (nonatomic, strong) NSString *gifticon;      ///< 礼物图片    字符串(string)
@property (nonatomic, strong) NSString *continuous;    ///< 是否连送    字符串(string)        默认1是，0否

@property (nonatomic, getter=isSelected) BOOL selected; ///< 是否选中

@end
