//
//  CBInterface.h
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用户协议
#define urlH5Policy         @"http://app.zhibo.gttead.cn/protocol.html"
// 关于我们
#define urlH5AboutUs        @"http://zhibo.gttead.cn"
// 加入公会
#define urlH5Guild          @"http://app.zhibo.gttead.cn/index.html"
// 实名认证
#define urlH5PresonCer      @"http://app.zhibo.gttead.cn/certification.html"
// 网页分享
#define urlH5Share          @"http://dl.zhibo.gttead.cn/index.html"

// 域名
#define purl @"http://fengwo.gttead.cn/"
//------------------------------------------------------------------
// 直播模块
// 在线直播列表
#define urlGetLive              purl@"Api/Anchor/getLive"
// 关注主播
// 实名认证
// 获取守护套餐详情
// 开始直播接口
#define urlStartLive            purl@"Api/Anchor/startLive"
// 推流成功回调接口
#define urlStartLivePushCallback purl@"Api/Anchor/startLivePushCallback"
// 关闭直播接口
#define urlStopLive             purl@"Api/Anchor/stopLive"
// 进入直播间接口
#define urlEnterLiveRoom        purl@"Api/Anchor/enterLiveRoom"
// 离开直播间接口
#define urlExitLiveRoom         purl@"Api/Anchor/exitLiveRoom"
// 获取直播间在线用户列表
#define urlGetLiveRoomOnlineUserList purl@"Api/Anchor/getLiveRoomOnlineUserList"
// 获取守护列表
#define urlGetGuardRankList     purl@"Api/Anchor/guard_rank_list"

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
// 用户登录第三方
#define urlSendOauthUserInfo    purl@"Api/User/sendOauthUserInfo"
// 添加黑名单
#define urlGetGuardPrices       purl@"Api/Anchor/get_guard_prices"
// 我的黑名单列表
#define urlBlacklist            purl@"Api/user/blacklist"
// 查看用户信息 查看某个主播或用户的主页信息
#define urlAnchorGetUserInfo    purl@"Api/Anchor/getUserInfo"
//------------------------------------------------------------------
// 短视频模块
// 获取上传token
#define urlGetUploadToken       purl@"Api/ShortVideo/getUploadToken"
// 获取当前用户视频列表
#define urlGetCurrentUserVideos purl@"Api/ShortVideo/getCurrentUserVideos"
// 获取全部视频列表
#define urlGetVideos            purl@"Api/ShortVideo/getVideos"
// 获取关注的视频列表
#define urlGetFavoriteUserVideos purl@"Api/ShortVideo/getFavoriteUserVideos"
// 单个视频信息查询
#define urlGetVideo             purl@"Api/ShortVideo/getVideo"
// 视频点赞接口
#define urlLikeVideo            purl@"Api/ShortVideo/likeVideo"
// 获取点赞人列表
#define urlGetLikeUsers         purl@"Api/ShortVideo/getLikeUsers"
// 视频观看回调接口
#define urlViewVideo            purl@"Api/ShortVideo/viewVideo"
// 视频评论接口
#define urlCommentVideo         purl@"Api/ShortVideo/commentVideo"
// 获取视频评论列表
#define urlGetComments          purl@"Api/ShortVideo/getComments"
// 视频评论的点赞功能
#define urlLikeComment          purl@"Api/ShortVideo/likeComment"
// 视频分享回调接口
#define urlShareVideo           purl@"Api/ShortVideo/shareVideo"
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
//------------------------------------------------------------------
// 七牛直播接口
// 主播推流地址获取
#define urlGetPushAddress       purl@"Api/qiniu/getPushAddress"
// 观众获取主播的拉流地址
#define urlGetPullAddress       purl@"Api/qiniu/getPullAddress"
// 七牛连麦 创建房间
#define urlCreateRoom           purl@"Api/qiniu/createRoom"
// 主播端操作查看连麦房间信息
#define urlGetRoom              purl@"Api/qiniu/getRoom"
// 删除房间 主播端操作
#define urlDeleteRoom           purl@"Api/qiniu/deleteRoom"
// 主播端操作查看连麦房间人数
#define urlGetRoomUsers         purl@"Api/qiniu/getRoomUsers"
// 主播端操作踢出连麦房间指定人员
#define urlDeleteRoomUser       purl@"Api/qiniu/deleteRoomUser"
// 获取连麦Token
#define urlRoomToken            purl@"Api/qiniu/roomToken"
//------------------------------------------------------------------
// 礼物/蜂窝币模块
#define urlGetGiftList          purl@"Api/Gift/getGiftList"
// 赠送礼物接口
#define urlSendGiftToAnchor     purl@"Api/Gift/sendGiftToAnchor"
// 仓库礼物列表
#define urlGetWareHouseList     purl@"Api/Gift/getWareHouseList"
//------------------------------------------------------------------
// VIP/钻石模块
// 获取钻石充值套餐详情
#define urlGetRechargePackage   purl@"Api/Anchor/get_recharge_package"
//------------------------------------------------------------------




@interface CBInterface : NSObject

/*!
 * @abstract 获取推流 URL
 *
 * @param roomName 房间名
 *
 * @discussion 若不需要登录，可直接注销方法内部代码，替换成 handler(nil, @"推流 URL") 即可
 */
+ (void)getPublishAddrWithRoomname:(NSString *)roomName completed:(void (^)(NSError *error, NSString *urlString))handler;
/*!
 * @abstract 获取播放 URL
 *
 * @param roomName 房间名
 *
 * @discussion 若不需要登录，可直接注销方法内部代码，替换成 handler(@"播放 URL") 即可
 */
+ (void)getPlayAddrWithRoomname:(NSString *)roomName completed:(void (^)(NSString *playUrl))handler;
/*!
 * @abstract 连麦 roomToken
 *
 * @param roomName 房间名
 *
 * @param userID 连麦用户名
 *
 * @discussion 若不需要登录，可直接注销方法内部代码，替换成 handler(nil, @"连麦 token") 即可
 */
+ (void)getRTCTokenWithRoomToken:(NSString *)roomName userID:(NSString *)userID completed:(void (^)(NSError *error, NSString *token))handler;


@end


// 主页直播列表
#define urlGetHot       purl@"?service=Home.getHot"
// 获取基本配置信息
#define urlGetBaseInfo  purl@"?service=User.getBaseInfo&uid=%@&token=%@&version_ios=%@"

#define getAD @"http://live.9158.com/Living/GetAD"
#define getHostLive @"http://live.9158.com/Fans/GetHotLive?page=%ld"
