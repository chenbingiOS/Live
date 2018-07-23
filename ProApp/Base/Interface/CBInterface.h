//
//  CBInterface.h
//  ProApp
//
//  Created by hxbjt on 2018/5/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>
// 域名
//#define purl @"http://47.99.52.31/"
#define purl @"http://fwtv.gttead.cn/"
//#define purl @"http://fengwo.gttead.cn/"
#define h5purl @"http://app.zhibo.gttead.cn/"


//------------------------------------------------------------------
//提现：
//提现(有绑定银行卡)：
#define H5_draw_money           h5purl@"draw_money.html"
//绑定银行卡(没有绑定银行卡)：
#define H5_card                 h5purl@"card.html"
//提现记录：
#define H5_draw_money_history   h5purl@"draw_money_history.html"
//设置-我的银行卡：
//我的银行卡：
#define H5_card_preson          h5purl@"card_preson.html"
//更换银行卡：
#define H5_card_change          h5purl@"card_change.html"
//实名认证：
#define H5_certification        h5purl@"certification.html"
//用户服务协议：
#define H5_protocol             h5purl@"protocol.html"
//公会：
//选择加入公会类型：
#define H5_index                h5purl@"index.html"
//工会列表：
#define H5_sociaty              h5purl@"sociaty.html"
//工会加入：
#define H5_enter_edit           h5purl@"enter_edit.html"
//个人入驻：
#define H5_enter_sociaty        h5purl@"enter_sociaty.html"
// 加入守护
#define H5_add_guard            h5purl@"add_guard.html"
// 加入Vip
#define H5_add_vip              h5purl@"add_vip.html"
// 个人中心-守护列表
#define H5_mine_guard           h5purl@"mine_guard.html"
// 关于我们
#define urlH5AboutUs            h5purl@"download.html"
// 网页分享直播
#define urlH5Share              h5purl@"share.html"
// 网页分享小视频
#define urlH5Sharevideo         h5purl@"share_video.html"
// 邀请明细
#define urlH5share_history      h5purl@"share_history.html"

//------------------------------------------------------------------
// 直播模块
// 在线直播列表
#define urlGetLive              purl@"Api/Anchor/getLive"
// 关注主播
#define urlAddAttention         purl@"Api/Anchor/addAttention"
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
// 获取Banner图
#define urlGetBanner            purl@"Api/HomePage/getBanner"
// 获取直播间在线用户列表
#define urlGetLiveRoomOnlineUserList purl@"Api/Anchor/getLiveRoomOnlineUserList"
// 直播间点赞
#define urlAddLike              purl@"Api/Anchor/add_like"
// 获取守护列表
#define urlGetGuardRankList     purl@"Api/Anchor/guard_rank_list"
// 获取某个用户贡献币列表
#define urlReceiveCoin          purl@"Api/Gift/receive_coin"
// 礼物gif图片
#define urlGetGiftOneList       purl@"Api/Gift/getGiftOneList"
// 本场贡献
#define urlThisContribute       purl@"Api/Anchor/thisContribute"
// 本场礼物记录
#define urlThisGift             purl@"Api/Anchor/thisGift"

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
// 获取我的所有仓库礼物
#define urlGetMyWareHouseList   purl@"Api/Gift/getMyWareHouseList"
//------------------------------------------------------------------
// VIP/钻石模块
// 获取钻石充值套餐详情
#define urlGetRechargePackage   purl@"Api/Anchor/get_recharge_package"
//------------------------------------------------------------------




@interface CBInterface : NSObject


@end


// 主页直播列表
#define urlGetHot       purl@"?service=Home.getHot"
// 获取基本配置信息
#define urlGetBaseInfo  purl@"?service=User.getBaseInfo&uid=%@&token=%@&version_ios=%@"

#define getAD @"http://live.9158.com/Living/GetAD"
#define getHostLive @"http://live.9158.com/Fans/GetHotLive?page=%ld"
