//
//  CBEditUserInfoVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/1.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBEditUserInfoVC.h"
#import "CBSexMenuView.h"

@interface CBEditUserInfoVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *exchangeAvaterBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNickTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;
@property (weak, nonatomic) IBOutlet UITextField *coordinatesTextField;
@property (weak, nonatomic) IBOutlet UITextField *signatureTextField;

@property (nonatomic, assign) BOOL isEditing;   ///< 是否处于编辑状态
@property (nonatomic, strong) CBSexMenuPopView *sexMenuPopView;

@end

@implementation CBEditUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    [self setupUI];
    [self updateUI];
}

- (void)setupUI {
    self.isEditing = NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view.bounds;
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor titleNormalColor] forState:UIControlStateNormal];
    @weakify(self);
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        @strongify(self);
        if (self.isEditing == NO) {
            self.isEditing = YES;
            [self updateUI];
            [self.userNickTextField becomeFirstResponder];
            [sender setTitle:@"保存" forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor titleSelectColor] forState:UIControlStateNormal];
        } else {
            self.isEditing = NO;
            [sender setTitle:@"编辑" forState:UIControlStateNormal];
            [self httpUpdateUserInfo];
            [sender setTitleColor:[UIColor titleNormalColor] forState:UIControlStateNormal];
            [self.userNickTextField resignFirstResponder];
            [self.signatureTextField resignFirstResponder];
            [self updateUI];
        }
    }];
    [view addSubview:btn];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)updateUI {
    if (self.isEditing) {
        self.exchangeAvaterBtn.userInteractionEnabled = YES;
        self.userNickTextField.userInteractionEnabled = YES;
        self.signatureTextField.userInteractionEnabled = YES;
    } else {
        self.exchangeAvaterBtn.userInteractionEnabled = NO;
        self.userNickTextField.userInteractionEnabled = NO;
        self.signatureTextField.userInteractionEnabled = NO;
    }
}

- (void)httpUpdateUserInfo {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    NSLog(@"上传成功");
}
 
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (IBAction)actionChangeSex:(id)sender {
    [self.sexMenuPopView showIn:self.view];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.contentHeightConstraint.constant = 603;
}

- (CBSexMenuPopView *)sexMenuPopView {
    if (!_sexMenuPopView) {
        CGFloat height = 180;
        if (iPhoneX) {
            height += 35;
        }
        _sexMenuPopView = [[CBSexMenuPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    }
    return _sexMenuPopView;
}


@end
