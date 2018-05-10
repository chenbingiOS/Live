//
//  CBAccountVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBAccountVC.h"
#import "UIView+DashedLine.h"
#import "CBAccountRecordVC.h"

@interface CBAccountVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *accountViewA;
@property (weak, nonatomic) IBOutlet UIView *accountViewB;
@property (weak, nonatomic) IBOutlet UIView *accountViewC;
@property (weak, nonatomic) IBOutlet UIView *accountViewD;
@property (weak, nonatomic) IBOutlet UIView *accountViewE;
@property (weak, nonatomic) IBOutlet UIView *accountViewF;

@end

@implementation CBAccountVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.viewHeightConstraint.constant = kScreenHeight;
    self.viewWidthConstraint.constant = kScreenWidth;
}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionAccountRecord:(id)sender {
    CBAccountRecordVC *vc = [CBAccountRecordVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
