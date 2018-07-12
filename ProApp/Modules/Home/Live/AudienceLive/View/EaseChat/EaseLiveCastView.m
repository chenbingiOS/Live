//
//  EaseLiveCastView.m
//  EaseMobLiveDemo
//
//  Created by EaseMob on 16/7/26.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import "EaseLiveCastView.h"

#import "CBAppLiveVO.h"

@interface EaseLiveCastView ()
{
    CBAppLiveVO *_room;
}

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation EaseLiveCastView

- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO*)room
{
    self = [super initWithFrame:frame];
    if (self) {
        _room = room;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = CGRectGetHeight(frame)/2;
        
        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.numberLabel];
        
        if ([_room.is_attention isEqualToString:@"0"]) {
            [self addSubview:self.attentionBtn];
        } else {
            frame.size.width = frame.size.width-45;
            self.frame = frame;
        }
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_room.avatar] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
        self.nameLabel.text = _room.user_nicename;
        self.numberLabel.text = [NSString stringWithFormat:@"房间号: %@", _room.room_id];
    }
    return self;
}

- (UIImageView*)headImageView
{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.frame = CGRectMake(0, 0, self.height, self.height);
        _headImageView.image = [UIImage imageNamed:@"placeholder_head"];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = CGRectGetHeight(_headImageView.frame)/2;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapShowAnchorInfo)];
        _headImageView.userInteractionEnabled = YES;
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

- (UILabel*)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(_headImageView.width + 8.f, 2.f, self.width - (_headImageView.width + 10.f)-50, self.height/2);
        _nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel*)numberLabel
{
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.frame = CGRectMake(_headImageView.width + 8.f, self.height/2+1, self.width - (_headImageView.width + 10.f)-50, self.height/2);
        _numberLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:9];
        _numberLabel.textColor = [UIColor whiteColor];
    }
    return _numberLabel;
}

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat left = self.width-50;
        _attentionBtn.frame = CGRectMake(left, 0, 50, 30);
        _attentionBtn.layer.cornerRadius = 15;
        _attentionBtn.layer.masksToBounds = YES;
        _attentionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _attentionBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
        [_attentionBtn addTarget:self action:@selector(actionAttentionCurrentAnchorBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _attentionBtn.backgroundColor = [UIColor mainColor];
    }
    return _attentionBtn;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = CGPointMake(25, 15);
    }
    return _indicatorView;
}

#pragma mark - action
- (void)actionTapShowAnchorInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionLiveShowAnchorInfo)]) {
        [self.delegate actionLiveShowAnchorInfo];
    }
}

- (void)actionAttentionCurrentAnchorBtn:(UIButton *)sender {
    [sender addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
    [self httpAddAttentionBtn:sender];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionLiveAttentionCurrentAnchor)]) {
        [self.delegate actionLiveAttentionCurrentAnchor];
    }
}

- (void)httpAddAttentionBtn:(UIButton *)sender {
    NSString *url = urlAddAttention;
    NSDictionary *param = @{@"token": [CBLiveUserConfig getOwnToken],
                            @"userid": _room.ID};
    @weakify(self);
    [PPNetworkHelper POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        NSNumber *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToNumber:@200]) {
            self->_room.is_attention = @"1";
            sender.hidden = YES;
            [self _UI_resetSelfWidth];
            [self.indicatorView stopAnimating];
            [self.indicatorView removeFromSuperview];
            [MBProgressHUD showAutoMessage:@"关注成功"];
        } else {
            NSString *descrp = responseObject[@"descrp"];
            [MBProgressHUD showAutoMessage:descrp];
        }
    } failure:^(NSError *error) {
    }];
}

// 重新设置UI对大小
- (void)_UI_resetSelfWidth {
    if (![_room.is_attention isEqualToString:@"0"]) {
        @weakify(self);
        [UIView animateWithDuration:0.35 animations:^{
            @strongify(self);
            CGFloat width = self.frame.size.width - 45;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
        }];
    }
}

#pragma mark - public 

- (void)setNumberOfChatroom:(NSInteger)number
{
    _numberLabel.text = [NSString stringWithFormat:@"%ld%@",(long)number ,NSLocalizedString(@"profile.people", @"")];
}

@end
