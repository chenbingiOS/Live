//
//  CBContributionRankVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBContributionRankVC.h"
#import "CBGuardRankCell.h"
#import "CBGuardRankBCell.h"
#import "CBGuardRankCCell.h"

@interface CBContributionRankVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *const CBGuardRankACellID = @"CBGuardRankACellID";
static NSString *const CBGuardRankBCellID = @"CBGuardRankBCellID";
static NSString *const CBGuardRankCCellID = @"CBGuardRankCCellID";


@implementation CBContributionRankVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"贡献榜";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CBGuardRankCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CBGuardRankACellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CBGuardRankBCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CBGuardRankBCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CBGuardRankCCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CBGuardRankCCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CBGuardRankCell *cell = [tableView dequeueReusableCellWithIdentifier:CBGuardRankACellID];
        return cell;
    } else if (indexPath.row == 1 || indexPath.row == 2) {
        CBGuardRankBCell *cell = [tableView dequeueReusableCellWithIdentifier:CBGuardRankBCellID];
        return cell;
    } else {
        CBGuardRankCCell *cell = [tableView dequeueReusableCellWithIdentifier:CBGuardRankCCellID];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 215;
    } else if (indexPath.row == 1) {
        return 105;
    } else if (indexPath.row == 2) {
        return 105;
    } else {
        return 70;
    }
    return 0;
}

@end
