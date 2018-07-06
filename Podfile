
#pod 'Masonry'     ,'1.1.0'              #布局
#pod 'IQKeyboardManager'     ,'5.0.4'    #键盘遮挡
#pod 'FDFullscreenPopGesture' ,'1.1'     #全局侧滑返回
#pod 'DZNEmptyDataSet'    ,'1.8.1'       #空数据展示模板
#pod 'MJExtension'   ,'3.0.13'           #JSON Model转换
#pod 'MGSwipeTableCell'  ,'1.6.1'        #左滑更多
#pod 'MZTimerLabel'      ,'0.5.4'        #定时器
#pod 'AFNetworking'      ,'3.1.0'        #网络请求
#pod 'BaiduMapKit'       ,'3.4.2'        #百度地图SDK
#pod 'XHLaunchAd'        ,'3.8.0'        #开屏广告实现
#pod 'SDCycleScrollView'  ,'1.64'        #无限轮播图
#pod 'PYSearch'          ,'0.8.5'        #搜索控制器替代原生
#pod 'AliPay'            ,'2.1.2'        #支付宝支付SDK
#pod 'ReactiveCocoa'     ,'2.5'          #函数响应式编程框架RAC  适合于MVVM框架
##以下SDK是在其他比如环信等SDK已经引入故未添加
##   pod 'MBProgressHUD'          #提示框
##   pod 'MJRefresh'              #刷新
##   pod 'SDWebImage'             #图片加载
#
##ShareSDK分享
#pod 'ShareSDK3' ,'4.0.1'                                 # 主模块(必须)
#pod 'MOBFoundation' ,'3.0.2'                             # Mob 公共库(必须)
#pod 'ShareSDK3/ShareSDKUI' ,'4.0.1'                       # UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
#pod 'ShareSDK3/ShareSDKPlatforms/QQ' ,'4.0.1'             # 平台SDK模块-QQ
#pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo' ,'4.0.1'      # 平台SDK模块-新浪微博
#pod 'ShareSDK3/ShareSDKPlatforms/WeChat' ,'4.0.1'        # 平台SDK模块-微信
#pod 'ShareSDK3/ShareSDKPlatforms/Copy' ,'4.0.1'          # 平台SDK模块-复制链接
#
##集成环信SDK
#pod 'HyphenateLite' ,'3.3.2'   #环信直播会用到
#pod 'Hyphenate' ,'3.3.2'
##集成环信EaseUI
#pod 'EaseUI', :git => 'https://github.com/easemob/easeui-ios-hyphenate-cocoapods.git', :tag => '3.3.2'
# 输入框
#pod 'JVFloatLabeledTextField'

platform :ios, '9.0'

def pods
    
# 网络
pod 'AFNetworking'
##########################################################
# 图片
#pod 'SDWebImage'
# UI框架
pod 'YYKit'
# 按钮文字和图片位置
pod 'LXMButtonImagePosition'
# 智能键盘
#pod 'IQKeyboardManager'
# 圆角处理
pod 'ZYCornerRadius'
# 提示
#pod 'MBProgressHUD'
# 表格数据为空时界面UI
pod 'LYEmptyView'

# 轮播图
pod 'TYCyclePagerView'
# 下拉刷新
#pod 'MJRefresh'
# 布局
pod 'Masonry'
# APP检测更新、提醒应用评价、前往App Store给予好评
pod 'ZWAppStore'
# 网页和原生交互
pod 'WebViewJavascriptBridge'
# 文本提示框
pod 'UITextView+Placeholder'
# 添加空间block
pod 'BlocksKit'
##########################################################
# 直播工具
pod 'PLPlayerKit'                           # 播放
pod 'PLShortVideoKit/ex-libMuseProcessor'	# 短视频
pod 'PLRTCStreamingKit'						# 连麦
# 第三方登录
pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
pod 'ShareSDK3/ShareSDKPlatforms/QQ'
pod 'ShareSDK3/ShareSDKPlatforms/Twitter'
pod 'ShareSDK3/ShareSDKPlatforms/Facebook'
pod 'WeiXinPay'
# 环信
pod 'HyphenateLite'
pod 'EaseUILite', :git => 'https://github.com/easemob/easeui-ios-hyphenate-cocoapods.git'
# 极光推送
pod 'JPush'
# 腾讯bug管理
pod 'Bugly'

end

target 'ProApp' do
    pods
end
