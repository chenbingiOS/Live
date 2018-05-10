//
//  CBGiftPackageCell.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/27.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBPackageRecordVO;
@interface CBGiftPackageCell : UITableViewCell

- (void)loadData:(CBPackageRecordVO *)data;

@end
