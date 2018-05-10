//
//  CBFillInfoViewController.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/23.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBFillInfoViewController.h"
#import "UIView+DashedLine.h"
#import "CBFillInfoOKView.h"

@interface CBFillInfoViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *positiveIDCardView;
@property (weak, nonatomic) IBOutlet UIView *backIDCardView;
@property (weak, nonatomic) IBOutlet UIImageView *positiveIDCardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backIDCardImageView;
@property (nonatomic, strong) CBFillInfoOKView *okView;

@end

@implementation CBFillInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self setup_ImageView];
    [self.view addSubview:self.okView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.positiveIDCardView dashedLineWithCornerRadius:6 borderWidth:1 dashPattern:6 spacePattern:6 borderColor:[UIColor lightGrayColor]];
    [self.backIDCardView dashedLineWithCornerRadius:6 borderWidth:1 dashPattern:6 spacePattern:6 borderColor:[UIColor lightGrayColor]];
}

- (void)setup_ImageView {
    [self.positiveIDCardImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
    }]];
    [self.positiveIDCardImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
    }]];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.viewWidthConstraint.constant = kScreenWidth;
    if (kScreenWidth == 414) {
        self.viewHeightConstraint.constant = 990;
    } else if (kScreenWidth == 375) {
        self.viewHeightConstraint.constant = 910;
    } else if (iPhoneX) {
        self.viewHeightConstraint.constant = 920;
    }
}

- (CBFillInfoOKView *)okView {
    if (!_okView) {
        _okView = [CBFillInfoOKView viewFromXib];
        _okView.size = CGSizeMake(kScreenWidth, 60);
        _okView.bottom = kScreenHeight-64;
    }
    return _okView;
}

@end
