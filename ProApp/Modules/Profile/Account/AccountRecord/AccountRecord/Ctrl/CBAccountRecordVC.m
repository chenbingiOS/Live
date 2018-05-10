//
//  CBAccountRecordVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/27.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBAccountRecordVC.h"
#import "CBAccountRecordSelectView.h"
#import "CBPackageRecordCell.h"
#import "CBPackageRecordVO.h"
#import "CBAccountInfoVC.h"
#import "CBDiamondInfoVC.h"

@interface CBAccountRecordVC () <CBAccountRecordSelectViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CBAccountRecordSelectView *selectView;
@property (nonatomic, strong) UIScrollView *scrollView;      /** UIScrollView */
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) NSMutableArray <CBPackageRecordVO *> *cellDataAry;

@end

static NSString *const CBPackageRecordCellID = @"CBPackageRecordCellID";

@implementation CBAccountRecordVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"礼包交易记录";
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftTableView];
    [self.scrollView addSubview:self.rightTableView];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBPackageRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CBPackageRecordCellID];
    [cell loadData:self.cellDataAry[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.leftTableView]) {
        CBAccountInfoVC *vc = [CBAccountInfoVC new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([tableView isEqual:self.rightTableView]) {
        CBDiamondInfoVC *vc = [CBDiamondInfoVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page = scrollView.contentOffset.x / kScreenWidth;
    [self.selectView setSelectIndex:(NSInteger)(page+0.5)];
}

#pragma mark - CBAccountRecordSelectViewDelegate
- (void)accountRecordSelectView:(CBAccountRecordSelectView *)view selectIndex:(NSInteger)index {
    
    NSLog(@"%@", @(index));
    
    [self.scrollView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:YES];
}

#pragma mark - layz

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44-64) style:UITableViewStyleGrouped];
        _leftTableView.backgroundColor = [UIColor bgColor];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.rowHeight = 70;
        [_leftTableView registerNib:[UINib nibWithNibName:@"CBPackageRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CBPackageRecordCellID];

    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-44-64) style:UITableViewStyleGrouped];
        _rightTableView.backgroundColor = [UIColor bgColor];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.rowHeight = 70;
        [_rightTableView registerNib:[UINib nibWithNibName:@"CBPackageRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CBPackageRecordCellID];

    }
    return _rightTableView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-44-64)];
        _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (CBAccountRecordSelectView *)selectView {
    if (!_selectView) {
        _selectView = [CBAccountRecordSelectView viewFromXib];
        _selectView.frame = CGRectMake(0, 0, kScreenWidth, 44);
        _selectView.delegate = self;
    }
    return _selectView;
}

- (NSMutableArray <CBPackageRecordVO *> *)cellDataAry {
    if (!_cellDataAry) {
        _cellDataAry = [NSMutableArray new];
        
        CBPackageRecordVO *vo = [CBPackageRecordVO new];
        vo.title = @"周卡";
        vo.time = @"2018.12.11";
        vo.money = @"-19";
        
        [_cellDataAry addObject:vo];
        [_cellDataAry addObject:vo];
    }
    return _cellDataAry;
}

@end
