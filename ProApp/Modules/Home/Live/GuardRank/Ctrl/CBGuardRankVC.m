//
//  CBGuardRankVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/2.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBGuardRankVC.h"
#import "CBGuardVC.h"
#import "CBGuardRankCCell.h"

@interface CBGuardRankVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *const CBGuardRankCCellID = @"CBGuardRankCCellID";

@implementation CBGuardRankVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"守护排行榜";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"去守护" style:UIBarButtonItemStylePlain target:self action:@selector(toGuard)];
    [self.tableView registerNib:[UINib nibWithNibName:@"CBGuardRankCCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CBGuardRankCCellID];
}

- (void)toGuard {
    CBGuardVC *vc = [CBGuardVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBGuardRankCCell *cell = [tableView dequeueReusableCellWithIdentifier:CBGuardRankCCellID];
    return cell;
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
