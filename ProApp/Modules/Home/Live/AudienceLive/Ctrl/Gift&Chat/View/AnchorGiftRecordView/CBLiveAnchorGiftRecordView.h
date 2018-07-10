//
//  CBLiveAnchorGiftRecordView.h
//  ProApp
//
//  Created by hxbjt on 2018/7/10.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPopView.h"

@interface CBLiveAnchorGiftRecordView : UIView

@property (weak, nonatomic) IBOutlet UIButton *contributionBtn;
@property (weak, nonatomic) IBOutlet UIButton *giftListBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *countCoinLab;
@property (weak, nonatomic) IBOutlet UILabel *countPeopleLab;

@property (nonatomic, strong) NSArray *listAry;

@end


@interface CBLiveAnchorGiftRecordPopView : CBPopView

@property (nonatomic, strong) CBLiveAnchorGiftRecordView *giftRecordView;

@end
