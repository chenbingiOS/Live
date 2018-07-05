//
//  ANMusicCell.h
//  ProApp
//
//  Created by 林景安 on 2018/6/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANMusicModel.h"

/**通知名 音乐播放*/
#define ANMusicPlayButtonDidClick @"AN.MusicPlayButtonDidClick"
/**通知名 音乐暂停*/
#define ANMusicPauseButtonDidClick @"AN.MusicPauseButtonDidClick"
/**通知下载音乐*/
#define ANNotificationDownLoadMusic @"AN.NotificationDownLoadMusic"

@interface ANMusicCell : UITableViewCell

@property(nonatomic,weak) ANMusicModel *model;

/**通过tableView获取Cell,已经集成了cell复用*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 对cell进行数据填充 */
-(void)setDataWithMusicModel:(ANMusicModel *)musicModel;
/** 通过model 获取cell的高度 */
+(CGFloat)cellHeightWith:(ANMusicModel *)model;

@end
