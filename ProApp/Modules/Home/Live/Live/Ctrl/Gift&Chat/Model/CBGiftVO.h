//
//  CBGiftVO.h
//  ProApp
//
//  Created by hxbjt on 2018/6/25.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBGiftVO : NSObject

@property (nonatomic, strong) NSString *giftid;         ///< id    字符串(string)
@property (nonatomic, strong) NSString *giftname;       ///< 礼物名    字符串(string)
@property (nonatomic, strong) NSString *needcoin;       ///< 礼物价格    字符串(string)
@property (nonatomic, strong) NSString *gifticon;       ///< 礼物图片    字符串(string)
@property (nonatomic, strong) NSString *continuous;     ///< 是否连送    字符串(string)        默认1是，0否
@property (nonatomic, strong) NSString *gifttype;       ///< 礼物类型    字符串(string)        礼物类型，默认0普通礼物，1贵族礼物，2幸运礼物，3其他礼物
@property (nonatomic, strong) NSString *giftswf;        ///< 礼物动画    字符串(string)
@property (nonatomic, strong) NSString *giftlevel;      ///< 礼物等级    字符串(string)        礼物等级，1专属1级，2专属2级，3专属3级

@property (nonatomic, getter=isSelected) BOOL selected; ///< 是否选中

@end
