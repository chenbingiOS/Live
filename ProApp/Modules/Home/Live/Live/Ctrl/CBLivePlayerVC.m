//
//  CBLivePlayerVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLivePlayerVC.h"
#import "ALinLive.h"
#import "CBRoomView.h"
#import <PLPlayerKit/PLPlayerKit.h>

@interface CBLivePlayerVC ()

@property (nonatomic, strong) CBRoomView *roomView;

@end

@implementation CBLivePlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupRoom {
    [self.view addSubview:self.roomView];
}

#pragma mark - 重写父类方法
- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType {
    if (PLPlayerFirstRenderTypeVideo == firstRenderType) {
        self.thumbImageView.hidden = YES;
        [self setupRoom];
    }
}

#pragma mark - layz
- (CBRoomView *)roomView {
    if (!_roomView) {
        _roomView = [[CBRoomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _roomView;
}

#pragma mark - Set 
- (void)setLive:(ALinLive *)live {
    _live = live;
    self.url = [NSURL URLWithString:live.flv];
    self.thumbImageURL = [NSURL URLWithString:live.bigpic];
}

@end
 
