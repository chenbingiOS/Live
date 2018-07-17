//
//  CBRechargeView.h
//  ProApp
//
//  Created by hxbjt on 2018/7/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPopView.h"

@protocol CBRechargeViewDelegate <NSObject>

@optional
- (void)itemsViewDidSelectedItem:(NSString *)item;

@end

@interface CBRechargeView : UIView

@property (nonatomic, assign) id <CBRechargeViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *topUpBtn;

@end

@interface CBRechargePopView : CBPopView

@property (nonatomic, strong) CBRechargeView *rechargeView;

@end
