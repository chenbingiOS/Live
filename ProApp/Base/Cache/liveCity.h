//
//  liveCity.h
//  iphoneLive
//
//  Created by 王敏欣 on 2016/12/13.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface liveCity : NSObject

@property(nonatomic,  strong)NSString *city;
@property(nonatomic,  strong)NSString *lng;
@property(nonatomic,  strong)NSString *lat;


-(instancetype)initWithDic:(NSDictionary *) dic;
+(instancetype)modelWithDic:(NSDictionary *) dic;

@end
