//
//  TSCChatModel.m
//  Test-inke
//
//  Created by 唐嗣成 on 2018/1/3.
//  Copyright © 2018年 shawnTang. All rights reserved.
//

#import "TSCChatModel.h"

@implementation TSCChatModel
-(instancetype)initWithDictinary:(NSDictionary *)dict{
    if(self = [super init]){
        _name = [NSString stringWithFormat:@"%@:",dict[@"userName"]];
        _context = dict[@"context"];
        _userLevel = [NSString stringWithFormat:@"%@",dict[@"userLevel"]];
        //        NSNumber *tableWidth = dict[@"tableWidth"];
        _tableWidth = @260;
        _type = dict[@"type"];
        
        if(_type.integerValue == 1) {
            CGFloat contentHeight= [_context boundingRectWithSize:CGSizeMake(_tableWidth.floatValue-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
            _cellHeight = [NSNumber numberWithFloat:contentHeight+10];
        } else {
            /*------------------------------------计算文本宽度是否为两行--------------------------------------------*/
            //计算名字宽度
            CGFloat nameWidth = [_name boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
            nameWidth = ceilf(nameWidth);
            _nameWidth = @(nameWidth);
            NSLog(@"计算名字宽度 %@", @(nameWidth));
            //计算文本宽度
            CGFloat contentWidth = [_context boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
            contentWidth = ceilf(contentWidth);
            NSLog(@"计算文本宽度 %@", @(contentWidth));
            //第一行可行的宽度
            CGFloat contentMaxWidth = _tableWidth.floatValue - nameWidth - 32 - 15; //5*4的间隔+32的level宽度
            NSLog(@"第一行可行的宽度 %@", @(contentMaxWidth));
            
            if (contentWidth > contentMaxWidth){
                _isMoreLine = YES;
//                CGFloat singleWidth = [@"国" boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
//                CGFloat singleCount = ceilf(contentMaxWidth/singleWidth);
                //计算第一行几个字 （先算每单位中能放几个字,再算出第一行的宽度内可以放几个字）
                NSUInteger cutLength = contentMaxWidth * (CGFloat)_context.length / contentWidth;
                _firstContent = [_context substringToIndex:cutLength];
                _secondContent = [_context substringFromIndex:cutLength];
                _secondContentSize = [_secondContent boundingRectWithSize:CGSizeMake(_tableWidth.floatValue-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
                _cellHeight = [NSNumber numberWithFloat:_secondContentSize.height + 10 + 16];
            } else {
                // 是一个相反值
                _backgroundTrailling = [NSNumber numberWithFloat:contentMaxWidth - contentWidth + 5];
            }
        }
    }
    return self;
}

@end

