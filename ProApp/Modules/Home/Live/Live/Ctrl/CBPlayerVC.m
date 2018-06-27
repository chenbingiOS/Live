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

@interface CBPlayerVC () <PLPlayerDelegate>

@property (nonatomic, strong) PLPlayer      *player;
@property (nonatomic, assign) BOOL isDisapper;

@end

@implementation CBPlayerVC

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
    [self setupPlayer];
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
    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    
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
//    [self.playButton hide];
//    [self.view showFullLoading];
}

- (void)hideWaiting {
//    [self.view hideFullLoading];
    if (PLPlayerStatusPlaying != self.player.status) {
//        [self.playButton show];
    }
}

- (void)firstJoinLiveChatRoom {
    NSLog(@"子类未实现");
}

#pragma mark - PLPlayerDelegate
- (void)playerWillBeginBackgroundTask:(PLPlayer *)player {
}

- (void)playerWillEndBackgroundTask:(PLPlayer *)player {
}

- (void)player:(PLPlayer *)player statusDidChange:(PLPlayerStatus)state
{    
    if (self.isDisapper) {
        [self.player stop];
        [self hideWaiting];
        return;
    }
    
    if (state == PLPlayerStatusPlaying ||
        state == PLPlayerStatusPaused ||
        state == PLPlayerStatusStopped ||
        state == PLPlayerStatusError ||
        state == PLPlayerStatusUnknow ||
        state == PLPlayerStatusCompleted) {
        [self hideWaiting];
    } else if (state == PLPlayerStatusPreparing ||
               state == PLPlayerStatusReady ||
               state == PLPlayerStatusCaching) {
        [self showWaiting];
    } else if (state == PLPlayerStateAutoReconnecting) {
        [self showWaiting];
    }
    
    switch (state) {
        case PLPlayerStatusUnknow:
            {
                NSLog(@"PLPlayerStatusUnknow");
            }
            break;
        case PLPlayerStatusPreparing:
            {
                NSLog(@"PLPlayerStatusPreparing");
            }
            break;
        case PLPlayerStatusReady:
            {
                NSLog(@"PLPlayerStatusReady");
            }
            break;
        case PLPlayerStatusOpen:
            {
                NSLog(@"PLPlayerStatusOpen");
            }
            break;
        case PLPlayerStatusCaching:
            {
                NSLog(@"PLPlayerStatusCaching");
            }
            break;
        case PLPlayerStatusPlaying:
            {
                NSLog(@"PLPlayerStatusPlaying");
            }
            break;
        case PLPlayerStatusPaused:
            {
                NSLog(@"PLPlayerStatusPaused");
            }
            break;
        case PLPlayerStatusStopped:
            {
                NSLog(@"PLPlayerStatusStopped");
            }
            break;
        case PLPlayerStatusError:
            {
                NSLog(@"PLPlayerStatusError");
            }
            break;
        case PLPlayerStateAutoReconnecting:
            {
                NSLog(@"PLPlayerStateAutoReconnecting");
            }
            break;
        case PLPlayerStatusCompleted:
            {
                NSLog(@"PLPlayerStatusCompleted");
            }
            break;
    }
}

- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error
{
    [self hideWaiting];
    NSString *info = [NSString stringWithFormat:@"发生错误,error = %@, code = %ld", error.description, (long)error.code];
    NSLog(@"%@",info);
//    [self.view showTip:info];
}

- (void)player:(nonnull PLPlayer *)player willRenderFrame:(nullable CVPixelBufferRef)frame pts:(int64_t)pts sarNumerator:(int)sarNumerator sarDenominator:(int)sarDenominator {
}

- (AudioBufferList *)player:(PLPlayer *)player willAudioRenderBuffer:(AudioBufferList *)audioBufferList asbd:(AudioStreamBasicDescription)audioStreamDescription pts:(int64_t)pts sampleFormat:(PLPlayerAVSampleFormat)sampleFormat{
    return audioBufferList;
}

- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType {
    if (PLPlayerFirstRenderTypeVideo == firstRenderType) {
    }
}

- (void)player:(nonnull PLPlayer *)player SEIData:(nullable NSData *)SEIData {
    
}

- (void)player:(PLPlayer *)player codecError:(NSError *)error {
    NSString *info = [NSString stringWithFormat:@"播放发生错误,error = %@, code = %ld", error.description, (long)error.code];
    NSLog(@"%@",info);
//    [self.view showTip:info];
    [self hideWaiting];
}

- (void)player:(PLPlayer *)player loadedTimeRange:(CMTime)timeRange {
    
}

- (void)setUrl:(NSURL *)url {
    if ([_url.absoluteString isEqualToString:url.absoluteString]) return;
    _url = url;
    
    if (self.player) {
        [self.player stop];
//        [self.player.playerView removeAllSubviews];
        [self.player.playerView removeFromSuperview];
//        self.player = nil;
        [self setupPlayer];
        [self.player play];
        
        [self firstJoinLiveChatRoom];
    }
}

@end
