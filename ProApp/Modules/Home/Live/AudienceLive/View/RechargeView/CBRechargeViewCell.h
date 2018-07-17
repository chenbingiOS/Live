//
//  CBRechargeViewCell.h
//  ProApp
//
//  Created by hxbjt on 2018/7/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBRechargeVO;
@interface CBRechargeViewCell : UICollectionViewCell

@property (nonatomic, strong) CBRechargeVO *rechargeVO;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@end
