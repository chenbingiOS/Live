//
//  CBLiveAnchorMainPageVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/6.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveAnchorMainPageVC.h"

#import "PLModelPanelGenerator.h"
#import "PLStreamingSessionConstructor.h"
#import "PLPermissionRequestor.h"
#import "PLPanelDelegateGenerator.h"
#import <PLRTCStreamingKit/PLRTCStreamingKit.h>
#import <Masonry/Masonry.h>
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>

#import "CBLiveAnchorBeginView.h"
#import "CBImagePickerTool.h"
#import "UILabel+ShadowText.h"
#import "EaseChatView.h"
#import "CBAppLiveVO.h"
#import "EaseLiveHeaderListView.h"
#import "EaseProfileLiveView.h"
#import "EaseEndLiveView.h"
#import "EaseHeartFlyView.h"
#import "EaseAdminView.h"
#import "CBStopLiveVO.h"
#import "CBLiveChatViewVC.h"
#import "CBLiveGiftViewVC.h"

#import "FUManager.h"
#import <FUAPIDemoBar/FUAPIDemoBar.h>
#import "FUItemsView.h"
#import "FULiveModel.h"

@interface CBLiveAnchorMainPageVC ()
<
PLMediaStreamingSessionDelegate,
PLPanelDelegateGeneratorDelegate,
FUAPIDemoBarDelegate,
FUItemsViewDelegate
>

//--------------------------------------------
// 配置直播
@property (nonatomic, strong) NSURL *streamURL;
@property (nonatomic, strong) CBLiveAnchorBeginView *beginLiveView;           ///< 开始直播前的UI
@property (nonatomic, strong) CBAppLiveVO *liveVO;                      ///< 直播信息对象
@property (nonatomic, strong) UIImage *coverImage;
//--------------------------------------------
// 直播开始
@property (nonatomic, strong) UIView *roomView;                         ///< 房间UI
@property (nonatomic, strong) UIScrollView *scrollView;                 ///< 实现左滑清空数据
@property (nonatomic, strong) UIView *leftView;                         ///< 左边控件容器
@property (nonatomic, strong) UIView *rightView;                        ///< 右边控件容器
@property (nonatomic, strong) UIImageView *topGradientView;             ///< 上部渐变
@property (nonatomic, strong) UIImageView *bottomGradientView;          ///< 下部渐变
@property (nonatomic, strong) UILabel *roomCodeLabel;                   ///< 房间号
@property (nonatomic, strong) EaseEndLiveView *endLiveView;             ///< 结束直播
@property (nonatomic, strong) CBLiveChatViewVC *liveChatView;           ///< 聊天系统
//--------------------------------------------
/**     FaceUnity       **/
@property (strong, nonatomic) UIButton *barBtn;
@property (nonatomic, strong) FUAPIDemoBar *demoBar;
@property (strong, nonatomic) UIButton *itemsViewBtn;
@property (nonatomic, strong) FUItemsView *itemsView;
/**     FaceUnity       **/
//--------------------------------------------
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGR;      ///< 点击手势
@property (nonatomic, strong) UIWindow *subWindow;
@property (nonatomic, strong) CBStopLiveVO *stopLiveVO;                 ///< 停止直播对象

@end

@implementation CBLiveAnchorMainPageVC {
    // 直播流需要的配置工具
    PLMediaStreamingSession *_streamingSession;
    PLModelPanelGenerator *_modelPanelGenerator;
    PLPanelDelegateGenerator *_panelDelegateGenerator;
    PLStreamingSessionConstructor *_sessionConstructor;
}

// 设置摄像头
- (void)_step_1_CameraSetting {
    _sessionConstructor = [[PLStreamingSessionConstructor alloc] init];
    _streamingSession = [_sessionConstructor streamingSession];
    
    _streamingSession.delegate = self;
    PLPermissionRequestor *permission = [[PLPermissionRequestor alloc] init];
    permission.noPermission = ^{};
    permission.permissionGranted = ^{
        UIView *previewView = self->_streamingSession.previewView;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cameraPreviewView insertSubview:previewView atIndex:0];
            [previewView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.and.right.equalTo(self.cameraPreviewView);
            }];
        });
    };
    [permission checkAndRequestPermission];
}

// 直播配置
- (void)_step_2_PLSetting {
    _panelDelegateGenerator = [[PLPanelDelegateGenerator alloc] initWithMediaStreamingSession:_streamingSession];
    [_panelDelegateGenerator generate];
    _panelDelegateGenerator.delegate = self;    
    _modelPanelGenerator = [[PLModelPanelGenerator alloc] initWithMediaStreamingSession:_streamingSession panelDelegateGenerator:_panelDelegateGenerator];
    self.panelModels = [_modelPanelGenerator generate];
}

// 开始推流
- (void)_step_3_PushStream {
    if (!_streamingSession.isStreamingRunning) {
        [_streamingSession startStreamingWithPushURL:_streamURL feedback:^(PLStreamStartStateFeedback feedback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (PLStreamStartStateSuccess == feedback) {
                    // 成功直播推流
                    [self httpStartLivePushCallback];                    
                    [UIApplication sharedApplication].idleTimerDisabled = YES;
                }
            });
        }];
    }
}

#pragma mark - life

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)dealloc {
    [_streamingSession destroy];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    /**     -----  FaceUnity  ----     **/
    [[FUManager shareManager] destoryItems];
    /**     -----  FaceUnity  ----     **/
    
    NSLog(@"dealloc: %@", [[self class] description]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    self.coverImage = [UIImage imageNamed:@"live_empty"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeLive) name:@"KNotificationCloseLiveVC" object:nil];
    
    [self _step_1_CameraSetting];
    [self _step_2_PLSetting];
    
    [self _UI_beginLiveBefore];
    [self _setup_FaceUnity];
}

#pragma mark - UI
// 直播前的UI
- (void)_UI_beginLiveBefore {
    [self.view addSubview:self.beginLiveView];
    @weakify(self);
    // 关闭按钮
    [self.beginLiveView.closeBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    // 摄像头颠倒
    [self.beginLiveView.cameraBackBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self actionChangeCamera];
    }];
    // 美颜
    [self.beginLiveView.beautyBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self actionFaceUnityBeautyFaceBtn:sender];
    }];
    // 道具
    [self.beginLiveView.propsBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self actionFaceUnityStickersBtn:sender];
    }];
    // 修改封面
    [self.beginLiveView.changeCoverBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        CBImagePickerTool *tool = [CBImagePickerTool new];
        tool.finishBlock = ^(CBImagePickerTool *imagePickerTool, NSDictionary *mediaInfo) {
            self.coverImage = mediaInfo.editedImage;
        };
        [tool showFromView:self.view];
    }];
    // 开发按钮触发
    [self.beginLiveView.beginLiveBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self httpGetPushAddress:sender];
    }];
    
    // 封面
    self.beginLiveView.coverImageView.image = self.coverImage;
}

// 加入聊天室
- (void)_UI_Join_Room {
    NSLog(@"加入聊天室");
    
    [self.view addSubview:self.roomView];
    [self.roomView addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftView];
    [self.scrollView addSubview:self.rightView];
    [self.leftView addSubview:self.roomCodeLabel];
    [self.rightView addSubview:self.topGradientView];
    [self.rightView addSubview:self.bottomGradientView];
    
    @weakify(self);
    [self addChildViewController:self.liveChatView];
    [self.rightView addSubview:self.liveChatView.view];
    [self.liveChatView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.rightView);
    }];
    
    // 加入聊天
    self.liveChatView.liveVO = self.liveVO;
    [self.liveChatView joinChatRoom];
}

// 离开聊天室
- (void)_UI_LeaveChatRoom {
    NSLog(@"离开聊天室");
    [self.liveChatView leaveChatRoom];
    
    self.liveChatView = nil;
    self.bottomGradientView = nil;
    self.topGradientView = nil;
    self.roomCodeLabel = nil;
    self.rightView = nil;
    self.leftView = nil;
    self.scrollView = nil;
    self.roomView = nil;
    [self.view removeAllSubviews];
}

// 直播中UI
- (void)_UI_startLive {
    
    [self _UI_Join_Room];
    
    // 加载数据
    [self _reloadData_UpadteRoomCode];
}

// 成功开播后需要关闭开始播放UI
- (void)_UI_closeBeginLiveView {
    [UIView animateWithDuration:0.35 animations:^{
        self.beginLiveView.hidden = YES;
    } completion:^(BOOL finished) {
        [self.beginLiveView removeFromSuperview];
        self.beginLiveView = nil;
        [self _UI_startLive];
    }];
}

// 关闭直播后显示结束详情视图
- (void)_UI_stopLiveEndView {
    // 显示直播详情
    [self.endLiveView setAudience:self.stopLiveVO.online_num];
    [self.view addSubview:self.endLiveView];
    [self.view bringSubviewToFront:self.endLiveView];
    
    
    
    
    self.roomView.hidden = YES;
    [self.roomView removeAllSubviews];
    [self.roomView removeFromSuperview];
    self.roomView = nil;
}

#pragma mark - Data
// 刷新数据
- (void)_reloadData_UpadteRoomCode {
    [self.roomCodeLabel shadowWtihText:[NSString stringWithFormat:@"房间号: %@", self.liveVO.room_id]];
}

#pragma mark - http
// 获取一个直播地址
- (void)httpGetPushAddress:(UIButton *)btn {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (self.beginLiveView.titleTextField.text.length == 0) {
        [MBProgressHUD showAutoMessage:@"填写主题吸引观众"];
        return ;
    }
    
    NSString *url = urlStartLive;
    NSDictionary *param = @{
                            @"token":[CBLiveUserConfig getOwnToken],
                            @"title": self.beginLiveView.titleTextField.text,
                            };
    UIImage *uploadImage = self.coverImage;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [PPNetworkHelper uploadImagesWithURL:url parameters:param name:@"photo" images:@[uploadImage] fileNames:nil imageScale:0.5 imageType:@"jpeg" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        @strongify(self);
        NSNumber *code = responseObject[@"code"];
        if ([code isEqualToNumber:@200]) {
            self.liveVO = [CBAppLiveVO modelWithDictionary:responseObject[@"data"]];
            self.liveVO.ID = [CBLiveUserConfig getOwnID];
            self.streamURL = [NSURL URLWithString:self.liveVO.push_rtmp];
            [self _step_3_PushStream];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else if ([code isEqualToNumber:@511]) {
            [self httpStopLive:btn];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showAutoMessage:@"直播失败"];
    }];
}

// 成功推流后告诉后台开始直播
- (void)httpStartLivePushCallback {
    NSString *url = urlStartLivePushCallback;
    NSDictionary *param = @{ @"token":[CBLiveUserConfig getOwnToken],
                             @"action": @"push" };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        NSNumber *code = responseObject[@"code"];
        if ([code isEqualToNumber:@200]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _UI_closeBeginLiveView];
            });            
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

// 如果非正常推出直播，重新直播前，告诉后台停止直播
- (void)httpStopLive:(UIButton *)btn {
    NSString *url = urlStopLive;
    NSDictionary *param = @{ @"token":[CBLiveUserConfig getOwnToken]};
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        NSNumber *code = responseObject[@"code"];
        if ([code isEqualToNumber:@200]) {
            [self httpGetPushAddress:btn];
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showAutoMessage:@"停止直播失败"];
    }];
}

// 正常关闭，告诉后台停止直播
- (void)httpCloseLive {
    NSString *url = urlStopLive;
    NSDictionary *param = @{ @"token":[CBLiveUserConfig getOwnToken]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        NSNumber *code = responseObject[@"code"];
        if ([code isEqualToNumber:@200]) {
            // 先停止直播流
            [self actionStopPushStream];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.stopLiveVO = [CBStopLiveVO modelWithJSON:responseObject[@"data"]];
            [self _UI_stopLiveEndView];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showAutoMessage:@"停止直播失败"];
    }];
}

#pragma mark - Set
// 设置封面图片
- (void)setCoverImage:(UIImage *)coverImage {
    _coverImage = coverImage;
    self.beginLiveView.coverImageView.image = _coverImage;
}

#pragma mark - Action

// 摄像头旋转
- (void)actionChangeCamera {
    [_streamingSession toggleCamera];
    /**     -------- FaceUnity --------       **/
    [[FUManager shareManager] onCameraChange];
    /**     -------- FaceUnity --------       **/
}

// 退出播放
- (void)closeLive{
    // 关闭直播
    [self httpCloseLive];
}

// 直播流停止
- (void)actionStopPushStream {
    // 退出播放
    [_streamingSession stopStreaming];
}

#pragma mark - lazy

- (CBLiveAnchorBeginView *)beginLiveView {
    if (!_beginLiveView) {
        _beginLiveView = [CBLiveAnchorBeginView viewFromXib];
        _beginLiveView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _beginLiveView;
}

- (UIView *)roomView {
    if (!_roomView) {
        _roomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _roomView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight);
        _scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _leftView.backgroundColor = [UIColor clearColor];
    }
    return _leftView;
}

- (UILabel *)roomCodeLabel {
    if (!_roomCodeLabel) {
        _roomCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 100, 30)];
        _roomCodeLabel.textColor = [UIColor whiteColor];
        _roomCodeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _roomCodeLabel;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        _rightView.backgroundColor = [UIColor clearColor];
    }
    return _rightView;
}

- (UIImageView *)topGradientView {
    if (!_topGradientView) {
        _topGradientView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
        _topGradientView.image = [UIImage imageNamed:@"topGradient"];
    }
    return _topGradientView;
}

- (UIView *)bottomGradientView {
    if (!_bottomGradientView) {
        _bottomGradientView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-205, kScreenWidth, 205)];
        _bottomGradientView.image = [UIImage imageNamed:@"bottomGradient"];
    }
    return _bottomGradientView;
}

- (UIWindow*)subWindow {
    if (!_subWindow) {
        _subWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 290.f)];
    }
    return _subWindow;
}

- (CBLiveChatViewVC *)liveChatView {
    if (!_liveChatView) {
        _liveChatView = [CBLiveChatViewVC new];
    }
    return _liveChatView;
}

- (EaseEndLiveView*)endLiveView {
    if (_endLiveView == nil) {
        _endLiveView = [[EaseEndLiveView alloc] initWithUsername:[EMClient sharedClient].currentUsername audience:@"265381人看过"];
        _endLiveView.delegate = self;
    }
    return _endLiveView;
}

#pragma mark - FaceUnity
#pragma mark - 隐藏工具栏
// 关闭键盘
// 因此FaceUnity工具条
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    if (self.demoBar.alpha == 1) {
        self.demoBar.alpha = 1.0 ;
        [UIView animateWithDuration:0.5 animations:^{
            self.demoBar.transform = CGAffineTransformIdentity;
            self.demoBar.alpha = 0.0 ;
        } completion:^(BOOL finished) {
            self.barBtn.hidden = NO;
            self.beginLiveView.btnBoxView.hidden = NO;
            self.beginLiveView.toolBoxView.hidden = NO;
        }];
    }
    else if (self.itemsView.alpha == 1) {
        self.itemsView.alpha = 1.0 ;
        [UIView animateWithDuration:0.5 animations:^{
            self.itemsView.transform = CGAffineTransformIdentity;
            self.itemsView.alpha = 0.0 ;
        } completion:^(BOOL finished) {
            self.itemsViewBtn.hidden = NO;
            self.beginLiveView.btnBoxView.hidden = NO;
            self.beginLiveView.toolBoxView.hidden = NO;
        }];
    }
}
// FUSDK 美颜
- (void)actionFaceUnityBeautyFaceBtn:(UIButton *)sender {
    self.beginLiveView.btnBoxView.hidden = YES;
    self.beginLiveView.toolBoxView.hidden = YES;
    self.demoBar.alpha = 0.0 ;
    [UIView animateWithDuration:0.5 animations:^{
        self.demoBar.transform = CGAffineTransformMakeTranslation(0, -self.demoBar.frame.size.height-34);
        self.demoBar.alpha = 1.0 ;
    }];
}

// 贴纸
- (void)actionFaceUnityStickersBtn:(UIButton *)sender {
    self.beginLiveView.btnBoxView.hidden = YES;
    self.beginLiveView.toolBoxView.hidden = YES;
    self.itemsView.alpha = 0.0 ;
    [UIView animateWithDuration:0.5 animations:^{
        self.itemsView.transform = CGAffineTransformMakeTranslation(0, -self.itemsView.frame.size.height-34);
        self.itemsView.alpha = 1.0 ;
    }];
}


// 初始化FaceUnity
- (void)_setup_FaceUnity {
    /**     -------- FaceUnity --------       **/
    [[FUManager shareManager] loadItems];
    [self.view addSubview:self.demoBar];
    [self.view addSubview:self.itemsView];
    /**     -------- FaceUnity --------       **/
}

/**     -------- FaceUnity --------       **/

- (FUItemsView *)itemsView {
    if (!_itemsView) {
        _itemsView = [FUItemsView viewFromXib];
        _itemsView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 60);
        
        FULiveModel *liveModel = [FUManager shareManager].dataSource[1];
        _itemsView.itemsArray = liveModel.items;
        //        NSString *selectItem = liveModel.items.count > 0 ? liveModel.items[0] : @"noitem" ;
        _itemsView.selectedItem = @"noitem" ;
        //        [[FUManager shareManager] loadItem:selectItem];
        
        _itemsView.delegate = self;
    }
    return _itemsView;
}

- (FUAPIDemoBar *)demoBar {
    if (!_demoBar) {
        
        _demoBar = [[FUAPIDemoBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 164)];
        _demoBar.top = kScreenHeight;
        
        _demoBar.itemsDataSource = [FUManager shareManager].filtersDataSource;
        _demoBar.selectedItem = [FUManager shareManager].selectedItem ;
        
        _demoBar.filtersDataSource = [FUManager shareManager].filtersDataSource ;
        _demoBar.beautyFiltersDataSource = [FUManager shareManager].beautyFiltersDataSource ;
        _demoBar.filtersCHName = [FUManager shareManager].filtersCHName ;
        _demoBar.selectedFilter = [FUManager shareManager].selectedFilter ;
        [_demoBar setFilterLevel:[FUManager shareManager].selectedFilterLevel forFilter:[FUManager shareManager].selectedFilter] ;
        
        _demoBar.skinDetectEnable = [FUManager shareManager].skinDetectEnable;
        _demoBar.blurShape = [FUManager shareManager].blurShape ;
        _demoBar.blurLevel = [FUManager shareManager].blurLevel ;
        _demoBar.whiteLevel = [FUManager shareManager].whiteLevel ;
        _demoBar.redLevel = [FUManager shareManager].redLevel;
        _demoBar.eyelightingLevel = [FUManager shareManager].eyelightingLevel ;
        _demoBar.beautyToothLevel = [FUManager shareManager].beautyToothLevel ;
        _demoBar.faceShape = [FUManager shareManager].faceShape ;
        
        _demoBar.enlargingLevel = [FUManager shareManager].enlargingLevel ;
        _demoBar.thinningLevel = [FUManager shareManager].thinningLevel ;
        _demoBar.enlargingLevel_new = [FUManager shareManager].enlargingLevel_new ;
        _demoBar.thinningLevel_new = [FUManager shareManager].thinningLevel_new ;
        _demoBar.jewLevel = [FUManager shareManager].jewLevel ;
        _demoBar.foreheadLevel = [FUManager shareManager].foreheadLevel ;
        _demoBar.noseLevel = [FUManager shareManager].noseLevel ;
        _demoBar.mouthLevel = [FUManager shareManager].mouthLevel ;
        
        _demoBar.delegate = self;
    }
    return _demoBar ;
}

/**      FUAPIDemoBarDelegate       **/

- (void)demoBarDidSelectedItem:(NSString *)itemName {
    
    [[FUManager shareManager] loadItem:itemName];
}

- (void)itemsViewDidSelectedItem:(NSString *)itenName {
    [[FUManager shareManager] loadItem:itenName];
    [self.itemsView stopAnimation];
}

- (void)demoBarBeautyParamChanged {
    
    [FUManager shareManager].skinDetectEnable = _demoBar.skinDetectEnable;
    [FUManager shareManager].blurShape = _demoBar.blurShape;
    [FUManager shareManager].blurLevel = _demoBar.blurLevel ;
    [FUManager shareManager].whiteLevel = _demoBar.whiteLevel;
    [FUManager shareManager].redLevel = _demoBar.redLevel;
    [FUManager shareManager].eyelightingLevel = _demoBar.eyelightingLevel;
    [FUManager shareManager].beautyToothLevel = _demoBar.beautyToothLevel;
    [FUManager shareManager].faceShape = _demoBar.faceShape;
    [FUManager shareManager].enlargingLevel = _demoBar.enlargingLevel;
    [FUManager shareManager].thinningLevel = _demoBar.thinningLevel;
    [FUManager shareManager].enlargingLevel_new = _demoBar.enlargingLevel_new;
    [FUManager shareManager].thinningLevel_new = _demoBar.thinningLevel_new;
    [FUManager shareManager].jewLevel = _demoBar.jewLevel;
    [FUManager shareManager].foreheadLevel = _demoBar.foreheadLevel;
    [FUManager shareManager].noseLevel = _demoBar.noseLevel;
    [FUManager shareManager].mouthLevel = _demoBar.mouthLevel;
    
    [FUManager shareManager].selectedFilter = _demoBar.selectedFilter ;
    [FUManager shareManager].selectedFilterLevel = _demoBar.selectedFilterLevel;
}

#pragma mark - PLPanelDelegateGeneratorDelegate
- (void)panelDelegateGenerator:(PLPanelDelegateGenerator *)panelDelegateGenerator cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    /**     -----  FaceUnity  ----     **/
    [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
    /**     -----  FaceUnity  ----     **/
}

@end
