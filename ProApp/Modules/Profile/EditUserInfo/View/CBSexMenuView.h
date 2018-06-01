//
//  CBSexMenuView.h
//  ProApp
//
//  Created by 陈冰 on 2018/5/14.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPopView.h"

@interface CBSexMenuView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *liveButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;

@end

@interface CBSexMenuPopView : CBPopView

@property (nonatomic, strong) CBSexMenuView *homeMenuView;

@end


