//
//  CBOccupantsCountView.m
//  ProApp
//
//  Created by hxbjt on 2018/6/19.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBOccupantsCountView.h"
#import "CBAppLiveVO.h"


@interface CBOccupantsCountView () {
    CBAppLiveVO *_room;
}
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation CBOccupantsCountView

- (instancetype)initWithFrame:(CGRect)frame room:(CBAppLiveVO *)room {
    self = [super initWithFrame:frame];
    if (self) {
        _room = room;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.numberLabel];
        
        self.numberLabel.text = _room.online_num;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOccupantsView)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UILabel*)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(0, 2, self.width, self.height/2-3);
        _nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:9];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = @"观众";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel*)numberLabel
{
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.frame = CGRectMake(0, self.height/2-1, self.width, self.height/2);
        _numberLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.text = @"0";
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

- (void)actionTapOccupantsView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectOccupantsWithUserID:)]) {
        [self.delegate didSelectOccupantsWithUserID:_room.ID];
    }
}

@end
