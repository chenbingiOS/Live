//
//  ANMusicModel.h
//  ProApp
//
//  Created by 林景安 on 2018/6/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>

@interface ANMusicModel : NSObject

/** id */
@property(nonatomic,assign)NSInteger ID;
/** 背景音乐名字 */
@property(nonatomic,copy)NSString *bgm_name;
/** 背景音乐七牛地址 */
@property(nonatomic,copy)NSString *bgm_qiniu_key;
/** 背景音乐封面地址 */
@property(nonatomic,copy)NSString *bgm_thumb;
/** 背景音乐歌手 */
@property(nonatomic,copy)NSString *bgm_singer;
/** 背景音乐备用地址 */
@property(nonatomic,copy)NSString *bgm_url;
/** 音乐使用次数 */
@property(nonatomic,assign)NSInteger bgm_use_num;
/** 音乐是否被选中播放 */
@property(nonatomic,assign)BOOL selected;
/** cell是否被选中播放，一旦被选中，显示确定按钮 */
@property(nonatomic,assign)BOOL cellSelected;
/** cell是否被选中播放，一旦被选中，显示确定按钮 */
@property(nonatomic,copy)NSString *savePath;
@end
