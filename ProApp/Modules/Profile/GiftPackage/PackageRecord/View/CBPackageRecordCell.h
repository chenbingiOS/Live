//
//  CBPackageRecordCell.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/27.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBPackageRecordVO;
@interface CBPackageRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

- (void)loadData:(CBPackageRecordVO *)data;

@end
