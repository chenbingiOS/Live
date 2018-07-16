//
//  CBShareView.h
//  ProApp
//
//  Created by hxbjt on 2018/6/12.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPopView.h"

@interface CBShareView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *wxButton;
@property (weak, nonatomic) IBOutlet UIButton *wxfriendButton;
@property (weak, nonatomic) IBOutlet UIButton *wbButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (nonatomic, copy) void(^clickBtnBlock)(void);
@property (nonatomic, copy) NSString *shareContentId;

@end

@interface CBSharePopView : CBPopView

@property (nonatomic, strong) CBShareView *shareView;

@end

