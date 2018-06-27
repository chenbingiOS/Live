//
//  CBLiveVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLiveVC.h"
#import "ALinLive.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "CBPlayerScrollView.h"
#import "CBLiveRoomVC.h"
#import "AppDelegate.h"

@interface CBLiveVC () <CBPlayerScrollViewDelegate>

@property (atomic, retain) id<IJKMediaPlayback> player;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) CBPlayerScrollView * playerScrollView;    ///< 播放器界面--上下滑动切换播放
@property (nonatomic, strong) CBLiveRoomVC *liveRoomVC;

@end

@implementation CBLiveVC

- (void)dealloc {
    NSLog(@"CBLiveVC dealloc");
    
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
    [self removeMovieNotificationObservers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self installMovieNotificationObservers];
    if (![self.player isPlaying]) {
        [self.player prepareToPlay];    ///< 播放器准备播放第一个
    }
        
    [self.view addSubview:self.closeButton];
    [self.view insertSubview:self.closeButton atIndex:999];
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

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
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    // 初始化一个播放器
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];    
    self.player = [[IJKFFMoviePlayerController alloc]initWithContentURLString:self.live.flv withOptions:options];
    self.player.view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    self.player.shouldAutoplay = YES;
    self.view.autoresizesSubviews = YES;
    [self.playerScrollView addSubview:self.player.view];
    [self addLiveRoomViewToView:self.playerScrollView WithLive:self.live];
}

- (void)reloadPlayerWithLive:(ALinLive *)live {
    // 播放页面关闭
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    [self.player.view removeFromSuperview];
    [self.liveRoomVC.view removeFromSuperview];
    
    // 刷新下一个播放器
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc]initWithContentURLString:live.flv withOptions:options];
    self.player = player;
    self.player.view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    self.player.shouldAutoplay = YES;
    // register live's notification
    [self installMovieNotificationObservers];
    [self.player prepareToPlay];
    [self.playerScrollView addSubview:self.player.view];
    [self addLiveRoomViewToView:self.playerScrollView WithLive:live];
}

- (void)addLiveRoomViewToView:(UIView *)view WithLive:(ALinLive *)live {
    [self addChildViewController:self.liveRoomVC];
    self.liveRoomVC.view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    [view addSubview:self.liveRoomVC.view];
    self.liveRoomVC.live = live;
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

#pragma mark - Action

- (void)closeAction: (UIButton *) button {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        [self.player shutdown]; ///< 播放器关闭
        [self removeMovieNotificationObservers];
        [self.closeButton removeFromSuperview];
    }];
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Notification
#pragma mark player staff
- (void)loadStateDidChange:(NSNotification*)notification {
//    MPMovieLoadStateUnknown        = 0,
//    MPMovieLoadStatePlayable       = 1 << 0,
//    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
//    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    IJKMPMovieLoadState loadState = _player.loadState;
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
//    MPMovieFinishReasonPlaybackEnded,
//    MPMovieFinishReasonPlaybackError,
//    MPMovieFinishReasonUserExited
    NSInteger reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", (int)reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", (int)reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", (int)reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", (int)reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
//    MPMoviePlaybackStateStopped,
//    MPMoviePlaybackStatePlaying,
//    MPMoviePlaybackStatePaused,
//    MPMoviePlaybackStateInterrupted,
//    MPMoviePlaybackStateSeekingForward,
//    MPMoviePlaybackStateSeekingBackward
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark Install Movie Notifications
/* Register observers for the various movie object notifications. */
-( void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaIsPreparedToPlayDidChange:) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}

#pragma mark Remove Movie Notification Handlers
/* Remove the movie notification observers from the movie object. */
- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
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
