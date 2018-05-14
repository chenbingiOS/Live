//
//  CBHomeMenuView.h
//  ProApp
//
//  Created by 陈冰 on 2018/5/14.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPopView.h"

@interface CBHomeMenuView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *liveButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;

@end

@interface CBHomeMenuPopView : CBPopView

@property (nonatomic, strong) CBHomeMenuView *homeMenuView;

@end


