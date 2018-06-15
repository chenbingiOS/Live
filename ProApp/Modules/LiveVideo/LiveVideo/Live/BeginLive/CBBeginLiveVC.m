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

@interface CBBeginLiveVC ()
<
PLMediaStreamingSessionDelegate,
PLPanelDelegateGeneratorDelegate,
EaseChatViewDelegate,
EMChatroomManagerDelegate,
EMClientDelegate,
EaseLiveHeaderListViewDelegate
>

//--------------------------------------------
// 配置直播
@property (nonatomic, strong) NSURL *streamURL;
@property (nonatomic, strong) CBBeginLiveView *beginLiveView;
@property (nonatomic, strong) CBAppLiveVO *liveVO;
//--------------------------------------------
// 直播开始
@property (nonatomic, strong) UIView *roomView;                 ///< 房间UI
@property (nonatomic, strong) UIScrollView *scrollView;         ///< 实现左滑清空数据
@property (nonatomic, strong) UIView *leftView;                 ///< 左边控件容器
@property (nonatomic, strong) UIView *rightView;                ///< 右边控件容器
@property (nonatomic, strong) UIImageView *topGradientView;     ///< 上部渐变
@property (nonatomic, strong) UIImageView *bottomGradientView;  ///< 下部渐变
@property (nonatomic, strong) UILabel *roomCodeLabel;           ///< 房间号
@property (nonatomic, strong) EaseLiveHeaderListView *headerListView; ///< 顶部人员
@property (nonatomic, strong) EaseChatView *chatview;           ///< 底部聊天
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGR;
@property (nonatomic, strong) UIWindow *subWindow;
//--------------------------------------------
@property (nonatomic, strong) UIButton *closeButton;            ///< 关闭按钮

@end

@implementation CBBeginLiveVC {
    // 直播流需要的配置工具
    PLMediaStreamingSession *_streamingSession;
    PLModelPanelGenerator *_modelPanelGenerator;
    PLPanelDelegateGenerator *_panelDelegateGenerator;
    PLStreamingSessionConstructor *_sessionConstructor;
}

- (void)dealloc {
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient] removeDelegate:self];
    
    _chatview.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_streamingSession destroy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    
    [self _prepareForCameraSetting];
    [self setup_beginLive_UI];
    
    _panelDelegateGenerator = [[PLPanelDelegateGenerator alloc] initWithMediaStreamingSession:_streamingSession];
    [_panelDelegateGenerator generate];
    _panelDelegateGenerator.delegate = self;
    
    _modelPanelGenerator = [[PLModelPanelGenerator alloc] initWithMediaStreamingSession:_streamingSession panelDelegateGenerator:_panelDelegateGenerator];
    self.panelModels = [_modelPanelGenerator generate];
}

- (void)setup_beginLive_UI {
    [self.view addSubview:self.beginLiveView];
    @weakify(self);
    [self.beginLiveView.closeBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.beginLiveView.cameraBackBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self _pressedChangeCameraButton:sender];
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
    [self.beginLiveView.beginLiveBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self httpGetPushAddress:sender];
    }];
}

// 成功开播后需要关闭开始播放UI
- (void)liveUIReload {
    [UIView animateWithDuration:0.35 animations:^{
        self.beginLiveView.hidden = YES;
    } completion:^(BOOL finished) {
        [self.beginLiveView removeFromSuperview];
        self.beginLiveView = nil;
        [self setup_Living_UI];
    }];
}

// 直播中UI
- (void)setup_Living_UI {
    
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
    
    @weakify(self);
    [self.chatview joinChatroomWithIsCount:NO completion:^(BOOL success) {
        @strongify(self);
        if (success) {
            [self.headerListView loadHeaderListWithChatroomId:self.liveVO.leancloud_room];
        }
    }];

    
    // 加载数据
    [self loadData_LivingData];
}

- (void)loadData_LivingData {
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
            [self _pressedStartButton];
            [self liveUIReload];
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
        [MBProgressHUD showAutoMessage:@"直播失败"];
    }];
}

// 告诉后台停止直播
- (void)httpCloseLive {
    NSString *url = urlStopLive;
    NSDictionary *param = @{ @"token":[CBLiveUserConfig getOwnToken]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSNumber *code = responseObject[@"code"];
        if ([code isEqualToNumber:@200]) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showAutoMessage:@"直播失败"];
    }];
}

#pragma mark - Action
// 关闭键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - override

- (void)setupForDismissKeyboard {
    self.singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    [self.chatview endEditing:YES];
}


// 设置封面图片
- (void)setCoverImage:(UIImage *)coverImage {
    _coverImage = coverImage;
    self.beginLiveView.coverImageView.image = _coverImage;
}

// 设置摄像头
- (void)_prepareForCameraSetting {
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

// 开始推流
- (void)_pressedStartButton {
    if (!_streamingSession.isStreamingRunning) {
        [_streamingSession startStreamingWithPushURL:_streamURL feedback:^(PLStreamStartStateFeedback feedback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (PLStreamStartStateSuccess == feedback) {
                    // 成功直播推流
                    [self httpStartLivePushCallback];
                }
            });
        }];
    }
}

// 摄像头旋转
- (void)_pressedChangeCameraButton:(UIButton *)button {
    [_streamingSession toggleCamera];
}

// 退出播放
- (void)closeAction: (UIButton *) button {
    // 退出播放
    [_streamingSession stopStreaming];
    // 关闭直播
    [self httpCloseLive];
    // 关闭聊天
    [self closeChat];
}

#pragma mark - EaseChatViewDelegate

- (void)easeChatViewDidChangeFrameToHeight:(CGFloat)toHeight {
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

#pragma mark - Chat
- (void)closeChat {
    @weakify(self);
    dispatch_block_t block = ^{
        [self.chatview leaveChatroomWithIsCount:NO completion:^(BOOL success) {
            @strongify(self);
            if (success) {
//                [[EMClient sharedClient].chatManager deleteConversation:_room.chatroomId isDeleteMessages:YES completion:NULL];
            } else {
                [self showHint:@"退出聊天室失败"];
            }
//            if (self.videoView)
//            {
//                [self.videoView removeFromSuperview];
//            }
//            self.videoView = nil;
//            self.closeBtn.enabled = YES;
            
            [UIApplication sharedApplication].idleTimerDisabled = NO;
//            [self removeNoti];
//            [self dismissViewControllerAnimated:YES completion:^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshList object:@(YES)];
//            }];
        }];
    };
    
//    [[EaseHttpManager sharedInstance] modifyLiveRoomStatusWithRoomId:self.le_room.roomId status:EaseLiveSessionCompleted completion:^(BOOL success) {
//        @strongify(self);
//        if (!success) {
//            [weakSelf showHint:@"更新失败"];
//        }
//        block();
//    }];
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

- (EaseChatView*)chatview {
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
        _headerListView = [[EaseLiveHeaderListView alloc] initWithFrame:frame room:_liveVO];
        _headerListView.delegate = self;
    }
    return _headerListView;
}

@end
