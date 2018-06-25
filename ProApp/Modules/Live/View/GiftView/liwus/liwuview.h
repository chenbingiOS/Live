//
//  liwuview.h
//  iphoneLive
//
//  Created by 王敏欣 on 2016/11/4.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "liwuModel.h"
@protocol sendGiftDelegate <NSObject>
-(void)sendGift:(NSMutableArray *)myDic andPlayDic:(NSDictionary *)playDic andData:(NSArray *)datas andLianFa:(NSString *)lianfa;

-(void)pushCoinV;

@end

@interface liwuview : UIView

@property(nonatomic,assign)id<sendGiftDelegate>giftDelegate;



@property(nonatomic,strong)NSDictionary *pldic;
@property(nonatomic,strong)NSMutableArray *mydic;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *buttomView;
@property(nonatomic,strong)NSArray *allArray;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)UIScrollView *scrollbuttom;
@property(nonatomic,strong)UILabel *chongzhi;
@property(nonatomic,strong)UIImageView *coinImg;
@property(nonatomic,strong)liwuModel *selectModel;
@property(nonatomic,strong)UIButton *jumpRecharge;
@property(nonatomic,strong)UIButton *continuBTN;
@property(nonatomic,strong)UIButton *push;
@property(nonatomic,strong)UIImageView *jiantou;

//重置礼物列表下方的钻石数量
-(void)chongzhiV:(NSString *)coins;
-(instancetype)initWithDic:(NSDictionary *)playdic andMyDic:(NSMutableArray *)myDic;



@end
