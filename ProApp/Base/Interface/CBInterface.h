//
//  CBInterface.h
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

// 主页直播列表
#define urlGetHot       purl@"?service=Home.getHot"
// 获取基本配置信息
#define urlGetBaseInfo  purl@"?service=User.getBaseInfo&uid=%@&token=%@&version_ios=%@"
//
#define getAD @"http://live.9158.com/Living/GetAD"
#define getHostLive @"http://live.9158.com/Fans/GetHotLive?page=%ld"

// 用户协议
#define urlH5Policy         @"http://protocol.gttead.cn"
// 关于我们
#define urlH5AboutUs        @"http://zhibo.gttead.cn"
// 分享网页
#define urlH5Share          @"http://dl.zhibo.gttead.cn"
// 加入公会
#define urlH5Guild          @"http://app.zhibo.gttead.cn"
// 实名认证
#define urlH5PresonCer      @"http://app.zhibo.gttead.cn/certification.html"

// 域名
#define purl @"http://fengwo.gttead.cn/"
//------------------------------------------------------------------
// 用户操作
// 用户注册
#define urlUserReg              purl@"Api/User/register"
// 用户登录
#define urlUserLogin            purl@"Api/User/login"
// 获取验证码
#define urlGetCode              purl@"Api/User/get_phone_varcode"
// 用户忘记密码
#define urlUserForget           purl@"Api/User/retrievePassword"
// 退出登陆
#define urlOutlogin             purl@"Api/User/outlogin"
// 密码重置
#define rulRetrievePassword     purl@"Api/User/retrievePassword"
//------------------------------------------------------------------
// 短视频模块



//------------------------------------------------------------------
// 我的
// 获取我的信息
#define urlGetUserInfo          purl@"Api/User/get_userinfo0"
// 我的关注
#define urlGetAttentionList     purl@"Api/Anchor/getUserAttentionList"
// 我的关注
#define urlGetUserFansList      purl@"Api/Anchor/getUserFansList"
// 修改个人资料
#define urlChangeUserinfo       purl@"Api/UserInfo/change_userinfo"
// 意见反馈
#define urlSubmitFeedBack       purl@"Api/UserInfo/submitFeedback"


// 用户登录第三方
#define urlUserLoginByThird     purl@"/?service=Login.userLoginByThird"

// 获取全部视频列表
#define urlGetVideos            purl@"Api/ShortVideo/getVideos"













@interface CBInterface : NSObject

@end
