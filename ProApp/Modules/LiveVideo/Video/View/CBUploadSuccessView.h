//
//  CBUploadSuccessView.h
//  ProApp
//
//  Created by hxbjt on 2018/6/7.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPopView.h"

@interface CBUploadSuccessView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@interface CBUploadSuccessPopView : CBPopView

@property (nonatomic, strong) CBUploadSuccessView *homeMenuView;

@end
