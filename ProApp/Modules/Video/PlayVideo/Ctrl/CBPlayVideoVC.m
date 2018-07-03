//
//  CBPlayVideoVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBPlayVideoVC.h"
#import "CBShortVideoVO.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "CBPlayVideoInfoVC.h"

@interface CBPlayVideoVC ()

@property (nonatomic, assign) BOOL isLookFirstLive; ///< 进入第一个直播间
@property (nonatomic, strong) UIView *roomView;                 ///< 房间UI
@property (nonatomic, strong) CBPlayVideoInfoVC *videoInfoVC;   ///< 聊天系统

@end

@implementation CBPlayVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLookFirstLive = YES;
}

- (void)_UI_LeaveChatRoom {
    NSLog(@"离开聊天室");
    [self.videoInfoVC leaveVideoRoom];
    
    self.roomView = nil;
    [self.view removeAllSubviews];
}

- (void)_UI_Join_Room {
    NSLog(@"加入聊天室");
    [self.view addSubview:self.roomView];
    @weakify(self);
    [self addChildViewController:self.videoInfoVC];
    [self.roomView addSubview:self.videoInfoVC.view];
    [self.videoInfoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.roomView);
    }];
    
    // 加入聊天
    self.videoInfoVC.shortVideoVO = self.video;
    [self.videoInfoVC joinVideoRoom];
}

- (void)firstJoinLiveRoom {
    if (self.isLookFirstLive) {
        self.isLookFirstLive = NO;
    } else {
        [self _UI_LeaveChatRoom];
    }
}

- (void)firstJoinLiveChatRoom {
    [self _UI_Join_Room];
}

#pragma mark - layz

- (UIView *)roomView {
    if (!_roomView) {
        _roomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _roomView;
}

- (CBPlayVideoInfoVC *)videoInfoVC {
    if (!_videoInfoVC) {
        _videoInfoVC = [CBPlayVideoInfoVC new];
    }
    return _videoInfoVC;
}

#pragma mark - Set
- (void)setVideo:(CBShortVideoVO *)video {
    _video = video;
    self.url = [NSURL URLWithString:video.href];
}


@end
