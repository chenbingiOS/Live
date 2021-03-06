//
//  CBOnlineUserCell.h
//  ProApp
//
//  Created by 陈冰 on 2018/4/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBAppLiveVO;
@interface CBOnlineUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)loadData:(CBAppLiveVO *)data;

@end
