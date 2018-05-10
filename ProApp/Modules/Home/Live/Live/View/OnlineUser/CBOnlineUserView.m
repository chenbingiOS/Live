//
//  CBOnlineUserView.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

// 在线用户
#import "CBOnlineUserView.h"
#import "ALinUser.h"
#import "CBOnlineUserCell.h"

static NSString *const CBOnlineUserCellID = @"CBOnlineUserCell";

@interface CBOnlineUserView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <ALinUser *> *cellDataAry;

@end

@implementation CBOnlineUserView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置参数 (否则用默认值)
        self.popType = PopTypeMove;
        self.moveAppearCenterY = kScreenHeight - self.height/2;
        self.moveAppearDirection = MoveAppearDirectionFromBottom;
        self.moveDisappearDirection = MoveDisappearDirectionToBottom;
        self.shadowColor = [UIColor colorWithWhite:1 alpha:0.3];
        self.animateDuration = 0.35;
        self.radius = 0;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.lineView];
        [self addSubview:self.tableView];
        
        [self.tableView reloadData];
    }
    return self;
}


#pragma mark - UITableViewDataSource;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBOnlineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBOnlineUserCellID"];
    [cell loadData:self.cellDataAry[indexPath.row]];
    return cell;
}

- (NSMutableArray <ALinUser *> *)cellDataAry {
    if (!_cellDataAry) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user.plist" ofType:nil]];
        _cellDataAry = [ALinUser mj_objectArrayWithKeyValuesArray:array];
    }
    return _cellDataAry;
}

#pragma mark - layz
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.width, 44)];
        _titleLabel.text = @"在线用户";
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _titleLabel.textColor = [UIColor titleNormalColor];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.width, 0.5)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44.5, self.width, self.height - 44.5)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"CBOnlineUserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CBOnlineUserCellID"];
    }
    return _tableView;
}
@end
