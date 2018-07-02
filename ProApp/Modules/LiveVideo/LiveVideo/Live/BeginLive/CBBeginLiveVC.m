//
//  CBBeginLiveVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/6.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBBeginLiveVC.h"

#import "PLModelPanelGenerator.h"
#import "PLStreamingSessionConstructor.h"
#import "PLPermissionRequestor.h"
#import "PLPanelDelegateGenerator.h"
#import <PLRTCStreamingKit/PLRTCStreamingKit.h>
#import <Masonry/Masonry.h>
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>

#import "CBBeginLiveView.h"
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

@interface CBBeginLiveVC ()
<
PLMediaStreamingSessionDelegate,
PLPanelDelegateGeneratorDelegate,
EaseChatViewDelegate,
EMChatroomManagerDelegate,
EMClientDelegate,
TapBackgroundViewDelegate,
EaseProfileLiveViewDelegate
>

//--------------------------------------------
// 配置直播
@property (nonatomic, strong) NSURL *streamURL;
@property (nonatomic, strong) CBBeginLiveView *beginLiveView;           ///< 开始直播前的UI
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
@property (nonatomic, strong) EaseLiveHeaderListView *headerListView;   ///< 顶部人员
@property (nonatomic, strong) EaseChatView *chatview;                   ///< 底部聊天
@property (nonatomic, strong) EaseEndLiveView *endLiveView;             ///< 结束直播
//--------------------------------------------
// 关闭UI
@property (nonatomic, strong) UIButton *closeButton;                    ///< 关闭按钮
//--------------------------------------------
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGR;      ///< 点击手势
@property (nonatomic, strong) UIWindow *subWindow;
@property (nonatomic, strong) CBStopLiveVO *stopLiveVO;                 ///< 停止直播对象

@end

@implementation CBBeginLiveVC {
    // 直播流需要的配置工具
    PLMediaStreamingSession *_streamingSession;
    PLModelPanelGenerator *_modelPanelGenerator;
    PLPanelDelegateGenerator *_panelDelegateGenerator;
    PLStreamingSessionConstructor *_sessionConstructor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarHidden:YES animated:animated];
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

- (void)dealloc {
    [_streamingSession destroy];
    
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient] removeDelegate:self];
    _chatview.delegate = nil;
    _chatview = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_streamingSession destroy];
    
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient] removeDelegate:self];
    _chatview.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    self.coverImage = [UIImage imageNamed:@"live_empty"];
    
    [self _step_1_CameraSetting];
    [self _step_2_PLSetting];
    
    [self _UI_beginLiveBefore];
}

#pragma mark - UI
// 直播前的UI
- (void)_UI_beginLiveBefore {
    [self.view addSubview:self.beginLiveView];
    @weakify(self);
    [self.beginLiveView.closeBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.beginLiveView.cameraBackBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self actionChangeCamera];
    }];
    [self.beginLiveView.beautyBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
    }];
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

// 直播中UI
- (void)_UI_startLive {
    
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    [self.view addSubview:self.roomView];
    [self.roomView addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftView];
    [self.scrollView addSubview:self.rightView];
    [self.leftView addSubview:self.roomCodeLabel];
    [self.rightView addSubview:self.topGradientView];
    [self.rightView addSubview:self.bottomGradientView];
    [self.rightView addSubview:self.headerListView];
    [self.rightView addSubview:self.chatview];
    
    [self.view addSubview:self.closeButton];
    [self setupForDismissKeyboard];
    
    // 聊天加入房间
    @weakify(self);
    [self.chatview joinChatroomWithIsCount:NO completion:^(BOOL success) {
        @strongify(self);
        if (success) {
//            [self.headerListView loadHeaderListWithChatroomId:self.liveVO.leancloud_room];
        }
    }];
    
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

// 关闭直播后关闭Window
- (void)_UI_closeSubWindow {
    [self.subWindow resignKeyWindow];
    [UIView animateWithDuration:0.3 animations:^{
        self.subWindow.top = kScreenHeight;
    } completion:^(BOOL finished) {
        self.subWindow.hidden = YES;
        [self.view.window makeKeyAndVisible];
    }];
}

// 关闭直播后显示结束详情视图
- (void)_UI_stopLiveEndView {
    // 显示直播详情
    [self.endLiveView setAudience:self.stopLiveVO.online_num];
    [self.view addSubview:self.endLiveView];
    [self.view bringSubviewToFront:self.endLiveView];
    
    self.closeButton.hidden = YES;
    [self.closeButton removeFromSuperview];
    self.closeButton = nil;
    
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
            self.streamURL = [NSURL URLWithString:self.liveVO.push_rtmp];
            [self _step_3_PushStream];
            [self _UI_closeBeginLiveView];
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
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        NSNumber *code = responseObject[@"code"];
        if ([code isEqualToNumber:@200]) {
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
    } failure:^(NSError *error) {
        
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

#pragma mark - lazy

- (CBBeginLiveView *)beginLiveView {
    if (!_beginLiveView) {
        _beginLiveView = [CBBeginLiveView viewFromXib];
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

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = kScreenHeight-60;
        if (iPhoneX) y -= 35;
        _closeButton.frame = CGRectMake(kScreenWidth - 60, y, 60, 60);
        [_closeButton setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIWindow*)subWindow {
    if (!_subWindow) {
        _subWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 290.f)];
    }
    return _subWindow;
}

- (EaseChatView *)chatview {
    if (!_chatview) {
        CGFloat y = kScreenHeight - 200 - SafeAreaBottomHeight;
        CGRect frame = CGRectMake(0, y, kScreenWidth, 200);
        _chatview = [[EaseChatView alloc] initWithFrame:frame room:_liveVO isPublish:NO];
        _chatview.delegate = self;
    }
    return _chatview;
}

- (EaseLiveHeaderListView*)headerListView {
    if (!_headerListView) {
        CGFloat y = SafeAreaTopHeight - 40 ;
        CGRect frame = CGRectMake(0, y, kScreenWidth, 30);
//        _headerListView = [[EaseLiveHeaderListView alloc] initWithFrame:frame room:_liveVO];
        _headerListView.delegate = self;
    }
    return _headerListView;
}

- (EaseEndLiveView*)endLiveView {
    if (_endLiveView == nil) {
        _endLiveView = [[EaseEndLiveView alloc] initWithUsername:[EMClient sharedClient].currentUsername audience:@"265381人看过"];
        _endLiveView.delegate = self;
    }
    return _endLiveView;
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
}

// 退出播放
- (void)closeAction: (UIButton *) button {
    // 关闭直播
    [self httpCloseLive];
}

// 直播流停止
- (void)actionStopPushStream {
    // 退出播放
    [_streamingSession stopStreaming];
}

//点击屏幕点赞特效
-(void)showTheLoveAction
{
    EaseHeartFlyView* heart = [[EaseHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, 55, 50)];
    [_chatview addSubview:heart];
    CGPoint fountainSource = CGPointMake(kScreenWidth - (20 + 50/2.0), _chatview.height);
    heart.center = fountainSource;
    [heart animateInView:_chatview];
}

#pragma mark - PLPanelDelegateGeneratorDelegate

- (void)panelDelegateGenerator:(PLPanelDelegateGenerator *)panelDelegateGenerator streamDidDisconnectWithError:(NSError *)error {}

- (void)panelDelegateGenerator:(PLPanelDelegateGenerator *)panelDelegateGenerator streamStateDidChange:(PLStreamState)state {}

#pragma mark - EaseLiveHeaderListViewDelegate

- (void)didSelectHeaderWithUsername:(NSString *)username
{
    if ([self.subWindow isKeyWindow]) {
        [self _UI_closeSubWindow];
        return;
    }
    EaseProfileLiveView *profileLiveView = [[EaseProfileLiveView alloc] initWithUsername:username
                                                                              chatroomId:self.liveVO.leancloud_room
                                                                                 isOwner:YES];
    profileLiveView.delegate = self;
    [profileLiveView showFromParentView:self.view];
}

#pragma  mark - TapBackgroundViewDelegate

- (void)didTapBackgroundView:(EaseBaseSubView *)profileView
{
    [profileView removeFromParentView];
}

#pragma mark - EaseEndLiveViewDelegate

// 关闭直播
- (void)didClickEndButton {    
    // 离开聊天室
    [self.chatview leaveChatroomWithIsCount:NO completion:^(BOOL success) {
        if (success) {
            [[EMClient sharedClient].chatManager deleteConversation:self.liveVO.leancloud_room isDeleteMessages:YES completion:NULL];
        } else {
            [MBProgressHUD showAutoMessage:@"退出聊天室失败"];
        }
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        [self removeNoti];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }];
}

// 继续直播
- (void)didClickContinueButton {
    [self _UI_beginLiveBefore];
}

#pragma mark - EaseChatViewDelegate

- (void)easeChatViewDidChangeFrameToHeight:(CGFloat)toHeight
{
    if ([self.subWindow isKeyWindow]) {
        return;
    }
    
    if (toHeight == 200) {
        [self.view removeGestureRecognizer:self.singleTapGR];
    } else {
        [self.view addGestureRecognizer:self.singleTapGR];
    }
    
    if (!self.chatview.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.chatview.frame;
            rect.origin.y = self.view.frame.size.height - toHeight;
            self.chatview.frame = rect;
        }];
    }
}

- (void)didReceivePraiseWithCMDMessage:(EMMessage *)message
{
    [self showTheLoveAction];
}

- (void)didSelectUserWithMessage:(EMMessage *)message
{
    [self.view endEditing:YES];
    EaseProfileLiveView *profileLiveView = [[EaseProfileLiveView alloc] initWithUsername:message.from
                                                                              chatroomId:self.liveVO.leancloud_room
                                                                                 isOwner:YES];
    profileLiveView.profileDelegate = self;
    profileLiveView.delegate = self;
    [profileLiveView showFromParentView:self.view];
}

- (void)didSelectChangeCameraButton
{

}

- (void)didSelectAdminButton:(BOOL)isOwner
{
    EaseAdminView *adminView = [[EaseAdminView alloc] initWithChatroomId:self.liveVO.leancloud_room
                                                                 isOwner:isOwner];
    adminView.delegate = self;
    [adminView showFromParentView:self.view];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - EaseProfileLiveViewDelegate

#pragma mark - EMChatroomManagerDelegate

- (void)userDidJoinChatroom:(EMChatroom *)aChatroom
                       user:(NSString *)aUsername
{
    if ([aChatroom.chatroomId isEqualToString:self.liveVO.leancloud_room]) {
        if (![aChatroom.owner isEqualToString:aUsername]) {
        }
    }
}

- (void)userDidLeaveChatroom:(EMChatroom *)aChatroom
                        user:(NSString *)aUsername
{
    if ([aChatroom.chatroomId isEqualToString:self.liveVO.leancloud_room]) {
        if (![aChatroom.owner isEqualToString:aUsername]) {
        }
    }
}

- (void)chatroomMuteListDidUpdate:(EMChatroom *)aChatroom
                addedMutedMembers:(NSArray *)aMutes
                       muteExpire:(NSInteger)aMuteExpire
{
    if ([aChatroom.chatroomId isEqualToString:self.liveVO.leancloud_room]) {
        NSMutableString *text = [NSMutableString string];
        for (NSString *name in aMutes) {
            [text appendString:name];
        }
        [self showHint:[NSString stringWithFormat:@"禁言成员:%@",text]];
    }
}

- (void)chatroomMuteListDidUpdate:(EMChatroom *)aChatroom
              removedMutedMembers:(NSArray *)aMutes
{
    if ([aChatroom.chatroomId isEqualToString:self.liveVO.leancloud_room]) {
        NSMutableString *text = [NSMutableString string];
        for (NSString *name in aMutes) {
            [text appendString:name];
        }
        [self showHint:[NSString stringWithFormat:@"解除禁言:%@",text]];
    }
}

- (void)chatroomOwnerDidUpdate:(EMChatroom *)aChatroom
                      newOwner:(NSString *)aNewOwner
                      oldOwner:(NSString *)aOldOwner
{
    if ([aChatroom.chatroomId isEqualToString:self.liveVO.leancloud_room]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"聊天室创建者有更新:%@",aChatroom.chatroomId] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"publish.ok", @"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self didClickEndButton];
        }];
        
        [alert addAction:ok];
    }
}

- (void)didDismissFromChatroom:(EMChatroom *)aChatroom
                        reason:(EMChatroomBeKickedReason)aReason
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"被踢出直播聊天室" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    [self didClickEndButton];
}

#pragma mark - EMClientDelegate

- (void)userAccountDidLoginFromOtherDevice
{
    
}

#pragma mark - private

- (void)addNoti
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeNoti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)setBtnStateInSel:(NSInteger)num
{
    if (num == 1) {
        self.chatview.hidden = YES;
        self.headerListView.hidden = YES;
    } else {
        self.chatview.hidden = NO;
        self.headerListView.hidden = NO;
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = endFrame.origin.y;
    
    if ([self.subWindow isKeyWindow]) {
        if (y == kScreenHeight) {
            [UIView animateWithDuration:0.3 animations:^{
                self.subWindow.top = kScreenHeight - 290.f;
                self.subWindow.height = 290.f;
            }];
        } else  {
            [UIView animateWithDuration:0.3 animations:^{
                self.subWindow.top = 0;
                self.subWindow.height = kScreenHeight;
            }];
        }
    }
}

#pragma mark - override

- (void)setupForDismissKeyboard
{
    _singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(tapAnywhereToDismissKeyboard:)];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    [self.chatview endEditing:YES];
}

#pragma mark - Action
// 关闭键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
