//
//  CBFeedBackVC.m
//  ProApp
//
//  Created by 陈冰 on 2018/4/26.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBFeedBackVC.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>

@interface CBFeedBackVC () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CBFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.textView.delegate = self;
    self.textView.placeholder = @"请输入反馈信息，140个字以内";
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 140) {
        textView.text = [textView.text substringToIndex:140];
        number = 140;
    }
    self.statusLabel.text = [NSString stringWithFormat:@"%ld/140",(long)number];
}


- (IBAction)actionSubmitFeedBack:(id)sender {
    [self.view endEditing:YES];
    if (self.textView.text.length == 0){
        [MBProgressHUD showAutoMessage:@"请输入反馈信息，140个字以内"];
        return;
    }
    
    {
        NSString *url = urlSubmitFeedBack;
        NSDictionary *regDict = @{@"content":self.textView.text,
                                  @"token":[CBLiveUserConfig getOwnToken]};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [PPNetworkHelper POST:url parameters:regDict success:^(id responseObject) {
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
            [MBProgressHUD showAutoMessage:@"重置密码失败"];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
