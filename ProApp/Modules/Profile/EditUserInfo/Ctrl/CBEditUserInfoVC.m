//
//  CBEditUserInfoVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/1.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBEditUserInfoVC.h"
#import "CBSexMenuView.h"
#import "CBCircularAvatarTool.h"

@interface CBEditUserInfoVC () 

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *exchangeAvaterBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNickTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;
@property (weak, nonatomic) IBOutlet UITextField *coordinatesTextField;
@property (weak, nonatomic) IBOutlet UITextField *signatureTextField;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *fengwoNumLab;

@property (nonatomic, assign) BOOL isEditing;   ///< 是否处于编辑状态
@property (nonatomic, strong) CBSexMenuPopView *sexMenuPopView;

@end

@implementation CBEditUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    [self setupUI];
    [self updateUI];
    [self reloadByUserInfo];
}

- (void)setupUI {
    self.isEditing = NO;
    {
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
    {
        @weakify(self);
        [self.sexMenuPopView.homeMenuView.liveButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            self.sexTextField.text = @"女";
            [self.sexMenuPopView hide];
        }];
        [self.sexMenuPopView.homeMenuView.videoButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            self.sexTextField.text = @"男";
            [self.sexMenuPopView hide];
        }];
    }
}

- (void)updateUI {
    if (self.isEditing) {
        self.exchangeAvaterBtn.userInteractionEnabled = YES;
        self.userNickTextField.userInteractionEnabled = YES;
        self.signatureTextField.userInteractionEnabled = YES;
        self.sexBtn.userInteractionEnabled = YES;
        self.locationBtn.userInteractionEnabled = YES;
    } else {
        self.exchangeAvaterBtn.userInteractionEnabled = NO;
        self.userNickTextField.userInteractionEnabled = NO;
        self.signatureTextField.userInteractionEnabled = NO;
        self.sexBtn.userInteractionEnabled = NO;
        self.locationBtn.userInteractionEnabled = NO;
    }
}

- (void)httpUpdateUserInfo {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSString *url = urlChangeUserinfo;
    NSDictionary *param = @{
                            @"token":[CBLiveUserConfig getOwnToken],
                            @"user_nicename":self.userNickTextField.text,
                            @"sex": [self.sexTextField.text isEqualToString:@"男"] ? @"1":@"2",
                            @"signature":self.signatureTextField.text,
                            @"location":self.coordinatesTextField.text
                            };    
    UIImage *uploadImage = self.avaterImageView.image;
    [PPNetworkHelper uploadImagesWithURL:url parameters:param name:@"avatar" images:@[uploadImage] fileNames:nil imageScale:0.5 imageType:@"jpeg" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        NSNumber *code = [responseObject valueForKey:@"code"];
        NSString *descrp = [responseObject valueForKey:@"descrp"];
        [MBProgressHUD showAutoMessage:descrp];
        if ([code isEqualToNumber:@200]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void)reloadByUserInfo {
    CBLiveUser *user = [CBLiveUserConfig myProfile];
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
    self.userNickTextField.text = user.user_nicename;
    if ([user.sex isEqualToString:@"0"]) {
        self.sexTextField.text = @"保密";
    } else if ([user.sex isEqualToString:@"1"]) {
        self.sexTextField.text = @"男";
    } else if ([user.sex isEqualToString:@"2"]) {
        self.sexTextField.text = @"女";
    }
    self.coordinatesTextField.text = user.location;
    self.signatureTextField.text = user.signature;
    
    self.accountLab.text = [NSString stringWithFormat:@"fengwotv%@",user.ID];
    self.phoneLab.text = user.mobile;
    self.fengwoNumLab.text = user.ID;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.contentHeightConstraint.constant = 603;
}

- (IBAction)actionChangeSex:(id)sender {
    [self.view endEditing:YES];
    [self.sexMenuPopView showIn:self.navigationController.view];
}

- (IBAction)actionLocation:(id)sender {
    [self.view endEditing:YES];
    [self.sexMenuPopView showIn:self.view];
}

- (IBAction)actionChangeAvatar:(id)sender {
    CBCircularAvatarTool *tool = [CBCircularAvatarTool new];
    @weakify(self);
    tool.finishBlock = ^(CBCircularAvatarTool *circularAvatarTool, NSDictionary *mediaInfo) {
        @strongify(self);
        self.avaterImageView.image = mediaInfo.circularEditedImage;
    };
    [tool showFromView:self.view];
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
