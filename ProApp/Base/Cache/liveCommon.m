//
//  liveCommon.m
//  
//
//  Created by 王敏欣 on 2017/1/18.
//
//
#import "liveCommon.h"
@implementation liveCommon
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        
        _video_share_title = [dic valueForKey:@"video_share_title"];
        _video_share_des = [dic valueForKey:@"video_share_des"];
        _share_title = [dic valueForKey:@"share_title"];
        _share_des = [dic valueForKey:@"share_des"];
        _wx_siteurl = [dic valueForKey:@"wx_siteurl"];
        _ipa_ver = [dic valueForKey:@"ipa_ver"];
        _app_ios = [dic valueForKey:@"app_ios"];
        _ios_shelves =[NSString stringWithFormat:@"%@",[dic valueForKey:@"ios_shelves"]];
        _name_coin = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name_coin"]];
        _name_votes = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name_votes"]];
        _enter_tip_level = [NSString stringWithFormat:@"%@",[dic valueForKey:@"enter_tip_level"]];
        
        _maintain_switch = [NSString stringWithFormat:@"%@",[dic valueForKey:@"maintain_switch"]];
        _maintain_tips = [NSString stringWithFormat:@"%@",[dic valueForKey:@"maintain_tips"]];
        _live_cha_switch = [NSString stringWithFormat:@"%@",[dic valueForKey:@"live_cha_switch"]];
        _live_pri_switch = [NSString stringWithFormat:@"%@",[dic valueForKey:@"live_pri_switch"]];
        
        _live_time_coin = [dic valueForKey:@"live_time_coin"];
        _live_type = [dic valueForKey:@"live_type"];
        _share_type = [dic valueForKey:@"share_type"];
        
        _pravitelive_switch = [NSString stringWithFormat:@"%@",[dic valueForKey:@"privatelive_switch"]];
        
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
@end
