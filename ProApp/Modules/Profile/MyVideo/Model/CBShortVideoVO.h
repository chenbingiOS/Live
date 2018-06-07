//
//  CBShortVideoVO.h
//  ProApp
//
//  Created by hxbjt on 2018/6/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBShortVideoVO : NSObject

@property (nonatomic, copy) NSString *ID;       ///< 视频id    数字(number)
@property (nonatomic, copy) NSString *title;    ///< 视频名称    字符串(string)
@property (nonatomic, copy) NSString *thumb;    ///< 视频封面图片地址    字符串(string)
@property (nonatomic, copy) NSString *href;     ///< 视频地址    字符串(string)
@property (nonatomic, copy) NSString *likes;    ///< 点赞数    数字(number)
@property (nonatomic, copy) NSString *views;    ///< 观看数    数字(number)
@property (nonatomic, copy) NSString *comments; ///< 评论数    数字(number)
@property (nonatomic, copy) NSString *shares;   ///< 分享数    数字(number)
@property (nonatomic, copy) NSString *addtime;  ///< 视频上传时间    数字(number)
@property (nonatomic, copy) NSString *uid;      ///< 视频上传者id    数字(number)

@end
