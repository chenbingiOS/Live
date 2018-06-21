//
//  CBPlayerVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBPlayerVC.h"
#import "CBRoomView.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "UIButton+Animate.h"

@interface CBPlayerVC () <PLPlayerDelegate>

@property (nonatomic, strong) PLPlayer      *player;
@property (nonatomic, strong) UIImage       *thumbImage;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, assign) BOOL isDisapper;

@end

@implementation CBPlayerVC

- (void)viewDidDisappear:(BOOL)animated {
    self.isDisapper = YES;
    [self.player stop];
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isDisapper = NO;
    if (![self.player isPlaying]) {
        [self.player play];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPlayer];
    [self setupThumbImage];
}

- (void)setupThumbImage {
    [self.view addSubview:self.thumbImageView];
    [self.thumbImageView addSubview:self.effectView];

    if (self.thumbImage) {
        self.thumbImageView.image = self.thumbImage;
    }
    if (self.thumbImageURL) {
        [self.thumbImageView sd_setImageWithURL:self.thumbImageURL placeholderImage:self.thumbImageView.image];
    }
}

- (void)setupPlayer {
    NSLog(@"播放地址: %@", _url.absoluteString);
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
    NSString *urlString = _url.absoluteString.lowercaseString;
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
//    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    
    self.player = [PLPlayer playerWithURL:_url option:option];
    self.player.playerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.player.playerView.backgroundColor = [UIColor clearColor];
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFill;
    self.player.delegate = self;
    self.player.loopPlay = YES;
    
    [self.view addSubview:self.player.playerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showWaiting {
}

- (void)hideWaiting {
}

- (void)joinChatRoom {
    NSLog(@"子类未实现");
}

- (void)leaveChatRoom {
    NSLog(@"子类未实现");
}

#pragma mark - PLPlayerDelegate

/** 告知代理对象 PLPlayer 即将开始进入后台播放任务 */
- (void)playerWillBeginBackgroundTask:(nonnull PLPlayer *)player {}

/** 告知代理对象 PLPlayer 即将结束后台播放状态任务  */
- (void)playerWillEndBackgroundTask:(nonnull PLPlayer *)player {}

/** 告知代理对象播放器状态变更  */
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    if (self.isDisapper) {
        [self.player stop];
        [self hideWaiting];
        [self leaveChatRoom];
        return;
    }
    
    if (state == PLPlayerStatusPaused ||
        state == PLPlayerStatusError ||
        state == PLPlayerStatusUnknow ||
        state == PLPlayerStatusCompleted) {
        [self hideWaiting];
    } else if (state == PLPlayerStatusPlaying) {
        [self joinChatRoom];
    } else if (state == PLPlayerStatusStopped) {
        [self leaveChatRoom];
    } else if (state == PLPlayerStatusPreparing ||
               state == PLPlayerStatusReady ||
               state == PLPlayerStatusCaching) {
        [self showWaiting];
    } else if (state == PLPlayerStateAutoReconnecting) {
        [self showWaiting];
    }
}

/** 告知代理对象播放器因错误停止播放 */
- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    [self hideWaiting];
    NSString *info = [NSString stringWithFormat:@"发生错误,error = %@, code = %ld", error.description, (long)error.code];
    [MBProgressHUD showAutoMessage:info];
}

/** 点播已缓冲区域 */
- (void)player:(nonnull PLPlayer *)player loadedTimeRange:(CMTime)timeRange {}

/** 回调将要渲染的帧数据 该功能只支持直播 */
- (void)player:(nonnull PLPlayer *)player willRenderFrame:(nullable CVPixelBufferRef)frame pts:(int64_t)pts sarNumerator:(int)sarNumerator sarDenominator:(int)sarDenominator {}

/** 回调音频数据 */
- (AudioBufferList *)player:(PLPlayer *)player willAudioRenderBuffer:(AudioBufferList *)audioBufferList asbd:(AudioStreamBasicDescription)audioStreamDescription pts:(int64_t)pts sampleFormat:(PLPlayerAVSampleFormat)sampleFormat{
    return audioBufferList;
}

/** 回调 SEI 数据 */
- (void)player:(nonnull PLPlayer *)player SEIData:(nullable NSData *)SEIData {}

/** 音视频渲染首帧回调通知  */
- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType {
    if (PLPlayerFirstRenderTypeVideo == firstRenderType) {
        self.thumbImageView.hidden = YES;
    }
}

/** 视频宽高数据回调通知 */
- (void)player:(nonnull PLPlayer *)player width:(int)width height:(int)height {}

/** seekTo 完成的回调通知 */
- (void)player:(nonnull PLPlayer *)player seekToCompleted:(BOOL)isCompleted {
    
}

- (void)player:(nonnull PLPlayer *)player codecError:(nonnull NSError *)error {
    NSString *info = [NSString stringWithFormat:@"播放发生错误,error = %@, code = %ld", error.description, (long)error.code];
    [MBProgressHUD showAutoMessage:info];
    
    [self hideWaiting];
}

#pragma mark - layz
- (UIImageView *)thumbImageView {
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _thumbImageView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _effectView;
}

#pragma mark - Set
- (void)setThumbImage:(UIImage *)thumbImage {
    _thumbImage = thumbImage;
    self.thumbImageView.image = thumbImage;
}

- (void)setThumbImageURL:(NSURL *)thumbImageURL {
    _thumbImageURL = thumbImageURL;
    [self.thumbImageView sd_setImageWithURL:thumbImageURL placeholderImage:[UIImage imageNamed:@"placeholder_empty_375"]];
}

- (void)setUrl:(NSURL *)url {
    if ([_url.absoluteString isEqualToString:url.absoluteString]) return;
    _url = url;
    
    if ([self.player isPlaying]) {
        [self.player stop];
        [self setupPlayer];
        [self.player play];
    }
}

@end
