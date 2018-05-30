//
//  CBInterface.h
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//


//#define purl @"http://api.et4p.top/api/public/"
//#define h5url @"http://api.et4p.top"
//
//// 用户协议
//#define urlPolicy       h5url@"/index.php?g=portal&m=page&a=index&id=4"
//// 获取验证码
//#define urlGetCode      purl@"?service=Login.getCode"
//// 用户注册
//#define urlUserReg      purl@"?service=Login.userReg"
//// 用户登录
//#define urlUserLogin    purl@"/?service=Login.userLogin"
//// 用户登录第三方
//#define urlUserLoginByThird purl@"/?service=Login.userLoginByThird"
//// 主页直播列表
//#define urlGetHot       purl@"?service=Home.getHot"
//// 获取基本配置信息
//#define urlGetBaseInfo  purl@"?service=User.getBaseInfo&uid=%@&token=%@&version_ios=%@"
////
//#define getAD @"http://live.9158.com/Living/GetAD"
//#define getHostLive @"http://live.9158.com/Fans/GetHotLive?page=%ld"

#import <Foundation/Foundation.h>

// 域名
#define purl @"http://fengwo.gttead.cn/"
#define h5url @"http://api.et4p.top"

// 用户协议
#define urlPolicy       h5url@"/index.php?g=portal&m=page&a=index&id=4"
// 获取验证码
#define urlGetCode      purl@"Api/User/get_phone_varcode"
// 用户注册
#define urlUserReg      purl@"Api/User/register"
// 用户登录
#define urlUserLogin    purl@"Api/User/login"
// 用户忘记密码
#define urlUserForget   purl@"Api/User/retrievePassword"
// 用户登录第三方
#define urlUserLoginByThird purl@"/?service=Login.userLoginByThird"
// 主页直播列表
#define urlGetHot       purl@"?service=Home.getHot"
// 获取基本配置信息
#define urlGetBaseInfo  purl@"?service=User.getBaseInfo&uid=%@&token=%@&version_ios=%@"
//
#define getAD @"http://live.9158.com/Living/GetAD"
#define getHostLive @"http://live.9158.com/Fans/GetHotLive?page=%ld"

@interface CBInterface : NSObject

@end
