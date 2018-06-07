//
//  CBOpenLiveVC.m
//  ProApp
//
//  Created by hxbjt on 2018/6/6.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBOpenLiveVC.h"
#import "CBImagePickerTool.h"

@interface CBOpenLiveVC ()

@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *settingCoverBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeCoverBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (nonatomic, strong) CBImagePickerTool *tool;

@end

@implementation CBOpenLiveVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.coverImageView roundedCornerRadius:8];
    self.tool = [CBImagePickerTool new];
    @weakify(self);
    self.tool.finishBlock = ^(CBImagePickerTool *imagePickerTool, NSDictionary *mediaInfo) {
        @strongify(self);
        self.coverImageView.image = mediaInfo.editedImage;
        self.tipLab.hidden = YES;
        self.coverImageView.hidden = NO;
        self.settingCoverBtn.hidden = YES;
        self.changeCoverBtn.hidden = NO;
        self.okBtn.hidden = NO;
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionCloseBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)actionSettingCoverBtn:(UIButton *)sender {
    [self.tool showFromView:self.view];
}

- (IBAction)actionChangeCoverBtn:(id)sender {
    [self.tool showFromView:self.view];
}

- (IBAction)actionOKBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
