//
//  CBLivePlayerVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLivePlayerVC.h"
// Third
#import <PLPlayerKit/PLPlayerKit.h>
// Model
#import "CBAppLiveVO.h"
// View
#import "CBRoomView.h"
// VC
#import "CBLiveChatViewVC.h"
// Category
#import "UILabel+ShadowText.h"

@interface CBLivePlayerVC ()

@property (nonatomic, assign) BOOL isLookFirstLive; ///< 进入第一个直播间
@property (nonatomic, strong) UIView *roomView;                 ///< 房间UI
@property (nonatomic, strong) UIScrollView *scrollView;         ///< 实现左滑清空数据
@property (nonatomic, strong) UIView *leftView;                 ///< 左边控件容器
@property (nonatomic, strong) UIView *rightView;                ///< 右边控件容器
@property (nonatomic, strong) UIImageView *topGradientView;     ///< 上部渐变
@property (nonatomic, strong) UIImageView *bottomGradientView;  ///< 下部渐变
@property (nonatomic, strong) UILabel *roomCodeLabel;           ///< 房间号
@property (nonatomic, strong) CBLiveChatViewVC *liveChatView;   ///< 聊天系统

@end

@implementation CBLivePlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLookFirstLive = YES;
}

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
    self.liveChatView.liveVO = self.live;
    [self.liveChatView joinChatRoom];
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
        CGFloat y = SafeAreaTopHeight - 40;
        _roomCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 100, 30)];
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

- (CBLiveChatViewVC *)liveChatView {
    if (!_liveChatView) {
        _liveChatView = [CBLiveChatViewVC new];
    }
    return _liveChatView;
}

#pragma mark - Set 
- (void)setLive:(CBAppLiveVO *)live {
    _live = live;
    
    [self firstJoinLiveRoom];
    
    self.url = [NSURL URLWithString:live.channel_source];
    [self.roomCodeLabel shadowWtihText:[NSString stringWithFormat:@"房间号: %@", live.room_id]];
}

@end
 
