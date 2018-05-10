//
//  CBLiveVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveVC.h"
#import "ALinLive.h"
//#import <IJKMediaFramework/IJKMediaFramework.h>
#import "CBPlayerScrollView.h"
#import "CBLiveRoomVC.h"
#import "AppDelegate.h"
#import <PLPlayerKit/PLPlayerKit.h>

@interface CBLiveVC () <CBPlayerScrollViewDelegate, PLPlayerDelegate>

@property (nonatomic, strong) PLPlayer *player;
@property (nonatomic, assign) BOOL isDisapper;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) CBPlayerScrollView * playerScrollView;    ///< 播放器界面--上下滑动切换播放
@property (nonatomic, strong) CBLiveRoomVC *liveRoomVC;

@end

@implementation CBLiveVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.view addSubview:self.closeButton];
    [self.view insertSubview:self.closeButton atIndex:999];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isDisapper = NO;
    if (![self.player isPlaying]) {
        [self.player play];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    self.isDisapper = YES;
    [self.player stop];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.live = self.lives[self.currentIndex];
    [self initUI];
    [self initPlayer];
}

- (void)initUI {
    [self.playerScrollView updateForLives:self.lives.mutableCopy withCurrentIndex:self.currentIndex];
    self.playerScrollView.playerDelegate = self;
    [self.view addSubview:self.playerScrollView];
}

- (void)initPlayer {
    // 初始化一个播放器
    NSURL *url = [NSURL URLWithString:self.live.flv];
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
    NSString *urlString = url.absoluteString.lowercaseString;
    if ([urlString containsString:@"mp4"]) {
        format = kPLPLAY_FORMAT_MP4;
    } else if ([urlString hasPrefix:@"rtmp:"]) {
        format = kPLPLAY_FORMAT_FLV;
    } else if ([urlString containsString:@".mp3"]) {
        format = kPLPLAY_FORMAT_MP3;
    } else if ([urlString containsString:@".m3u8"]) {
        format = kPLPLAY_FORMAT_M3U8;
        
    }
    [option setOptionValue:@(format) forKey:PLPlayerOptionKeyVideoPreferFormat];
    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    
    self.player = [PLPlayer playerWithURL:url option:option];
    self.player.playerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    self.player.playerView.backgroundColor = [UIColor clearColor];
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    self.player.delegate = self;
    self.player.loopPlay = YES;

    self.view.autoresizesSubviews = YES;
    [self.playerScrollView addSubview:self.player.playerView];
    [self addLiveRoomViewToView:self.playerScrollView WithLive:self.live];
}

// 切换一个视频播放器
- (void)reloadPlayerWithLive:(ALinLive *)live {

    [self.liveRoomVC.view removeFromSuperview];
    if (self.player) {
        [self.player stop];
        NSURL *url = [NSURL URLWithString:live.flv];
        [self.player playWithURL:url sameSource:YES];
        [self.player play];
    }
    
    [self addLiveRoomViewToView:self.playerScrollView WithLive:live];
}

- (void)addLiveRoomViewToView:(UIView *)view WithLive:(ALinLive *)live {
//    [self addChildViewController:self.liveRoomVC];
//    self.liveRoomVC.view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
//    [view addSubview:self.liveRoomVC.view];
//    self.liveRoomVC.live = live;
}

- (void)showWaiting {
//    [self.playButton hide];
//    [self.view showFullLoading];
//    [self.view bringSubviewToFront:self.closeButton];
}

- (void)hideWaiting {
//    [self.view hideFullLoading];
    if (PLPlayerStatusPlaying != self.player.status) {
//        [self.playButton show];
    }
}

#pragma mark PlayerScrollViewDelegate
- (void)playerScrollView:(CBPlayerScrollView *)playerScrollView currentPlayerIndex:(NSInteger)index {
    NSLog(@"current index from delegate:%ld  %s",(long)index,__FUNCTION__);
    if (self.currentIndex == index) {
        return;
    } else {
        [self reloadPlayerWithLive:self.lives[index]];
        self.currentIndex = index;
    }
}

#pragma mark - PLPlayerDelegate
//
//- (void)playerWillBeginBackgroundTask:(PLPlayer *)player {
//}
//
//- (void)playerWillEndBackgroundTask:(PLPlayer *)player {
//}

//- (void)player:(PLPlayer *)player statusDidChange:(PLPlayerStatus)state
//{
//    if (self.isDisapper) {
//        [self.player stop];
//        [self hideWaiting];
//        return;
//    }
//
//    if (state == PLPlayerStatusPlaying ||
//        state == PLPlayerStatusPaused ||
//        state == PLPlayerStatusStopped ||
//        state == PLPlayerStatusError ||
//        state == PLPlayerStatusUnknow ||
//        state == PLPlayerStatusCompleted) {
//        [self hideWaiting];
//    } else if (state == PLPlayerStatusPreparing ||
//               state == PLPlayerStatusReady ||
//               state == PLPlayerStatusCaching) {
//        [self showWaiting];
//    } else if (state == PLPlayerStateAutoReconnecting) {
//        [self showWaiting];
//    }
//}

//- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error
//{
//    [self hideWaiting];
//    NSString *info = [NSString stringWithFormat:@"发生错误,error = %@, code = %ld", error.description, (long)error.code];
////    [self.view showTip:info];
//}
//
//- (void)player:(nonnull PLPlayer *)player willRenderFrame:(nullable CVPixelBufferRef)frame pts:(int64_t)pts sarNumerator:(int)sarNumerator sarDenominator:(int)sarDenominator {
//}
//
//- (AudioBufferList *)player:(PLPlayer *)player willAudioRenderBuffer:(AudioBufferList *)audioBufferList asbd:(AudioStreamBasicDescription)audioStreamDescription pts:(int64_t)pts sampleFormat:(PLPlayerAVSampleFormat)sampleFormat{
//    return audioBufferList;
//}
//
//- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType {
//    if (PLPlayerFirstRenderTypeVideo == firstRenderType) {
////        self.thumbImageView.hidden = YES;
//    }
//}
//
//- (void)player:(nonnull PLPlayer *)player SEIData:(nullable NSData *)SEIData {
//
//}
//
//- (void)player:(PLPlayer *)player codecError:(NSError *)error {
//
//    NSString *info = [NSString stringWithFormat:@"播放发生错误,error = %@, code = %ld", error.description, (long)error.code];
////    [self.view showTip:info];
//    [self hideWaiting];
//}
//
//- (void)player:(PLPlayer *)player loadedTimeRange:(CMTimeRange)timeRange {}

#pragma mark - Action
- (void)closeAction: (UIButton *) button {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        [self.player stop];
        [self.closeButton removeFromSuperview];
    }];
}

#pragma mark - layz
- (CBPlayerScrollView *)playerScrollView {
    if (!_playerScrollView) {
        _playerScrollView = [[CBPlayerScrollView alloc] initWithFrame:self.view.frame];
        _playerScrollView.playerDelegate = self;
        _playerScrollView.index = self.currentIndex;
    }
    return _playerScrollView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(kScreenWidth - 60, kScreenHeight - 60, 60, 60);
        [_closeButton setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (CBLiveRoomVC *)liveRoomVC {
    if (!_liveRoomVC) {
        _liveRoomVC = [[CBLiveRoomVC alloc] init];
    }
    return _liveRoomVC;
}

@end
