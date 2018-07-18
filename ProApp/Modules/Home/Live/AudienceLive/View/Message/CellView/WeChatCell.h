//
//  WeChatCell.h
//  HanTu
//
//  Created by apple on 2016/11/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageModel;

typedef void  (^DoubleClickBlock) (MessageModel * model);


@interface WeChatCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView messageModel:(MessageModel *)model;

+(CGFloat)tableHeightWithModel:(MessageModel *)model;


@property (nonatomic,strong) UIImageView* voiceAnimationImageView;
@property (nonatomic,strong) UIImageView* coversImageView;

@property (nonatomic,strong) MessageModel* messageModel;
@property(nonatomic,copy)DoubleClickBlock doubleblock;
@property(nonatomic,copy)DoubleClickBlock singleblock;
@property(nonatomic,copy)DoubleClickBlock resendblock;

-(void)setDoubleClickBlock:(DoubleClickBlock )doubleClickBlock;
-(void)setSingleClickBlock:(DoubleClickBlock )singleClickBlock;
-(void)setResendClickBlock:(DoubleClickBlock )resendClickBlock;

-(void)stopVoiceAnimation;
-(void)startVoiceAnimation;
-(void)startSentMessageAnimation;
-(void)stopSentMessageAnimation;


@end
