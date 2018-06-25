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
#import "CBShortVideoRoomView.h"

@interface CBPlayVideoVC () 

@property (nonatomic, strong) CBShortVideoRoomView *roomView;

@end

@implementation CBPlayVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupRoom {
    [self.view addSubview:self.roomView];
}

#pragma mark - 重写父类方法
- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType {
    if (PLPlayerFirstRenderTypeVideo == firstRenderType) {
//        [self setupRoom];
    }
}

#pragma mark - layz
- (CBShortVideoRoomView *)roomView {
    if (!_roomView) {
        _roomView = [[CBShortVideoRoomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _roomView;
}

#pragma mark - Set
- (void)setVideo:(CBShortVideoVO *)video {
    _video = video;
    self.url = [NSURL URLWithString:video.href];
}


@end
