//
//  CBEditUserInfoVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/1.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBEditUserInfoVC.h"

@interface CBEditUserInfoVC ()


@property (nonatomic, assign) BOOL isEditing;   ///< 是否处于编辑状态

@end

@implementation CBEditUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    [self setupUI];
}

- (void)setupUI {
    self.isEditing = NO;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view.bounds;
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.isEditing = YES;
    }];
    [view addSubview:btn];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)updateUI {
    if (self.isEditing) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
