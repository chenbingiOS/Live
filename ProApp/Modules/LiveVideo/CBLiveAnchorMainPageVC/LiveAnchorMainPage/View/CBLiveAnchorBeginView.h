//
//  CBLiveAnchorBeginView.h
//  ProApp
//
//  Created by hxbjt on 2018/6/8.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBLiveAnchorBeginView : UIView

@property (weak, nonatomic) IBOutlet UIView *btnBoxView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *beautyBtn;
@property (weak, nonatomic) IBOutlet UIButton *propsBtn;

@property (weak, nonatomic) IBOutlet UIView *toolBoxView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *changeCoverBtn;
@property (weak, nonatomic) IBOutlet UIButton *beginLiveBtn;

@end
