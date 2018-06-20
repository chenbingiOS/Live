//
//  CBAnchorInfoVO.h
//  ProApp
//
//  Created by hxbjt on 2018/6/20.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBLiveUser;

@interface CBAnchorInfoVO : NSObject

@property (nonatomic, strong) CBLiveUser *user;
@property (nonatomic, copy) NSArray <CBLiveUser *> *guard;
@property (nonatomic, copy) NSArray <CBLiveUser *> *gong;

@end
