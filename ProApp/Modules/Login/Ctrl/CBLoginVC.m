//
//  CBLoginVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/5/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBLoginVC.h"

@interface CBLoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@end

@implementation CBLoginVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self setTextFieldLeftPadding:self.phoneTextField forWidth:44.0f andImageName:@"login_icon_phone"];
    [self setTextFieldLeftPadding:self.pwdTextField forWidth:44.0f andImageName:@"login_icon_password"];
}

- (void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth andImageName:(NSString *)imgName{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
     textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, leftWidth, frame.size.height)];
    imgV.contentMode = UIViewContentModeCenter;
    imgV.image = [UIImage imageNamed:imgName];
    [leftview addSubview:imgV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
