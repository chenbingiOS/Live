//
//  cityDefault.m
//  iphoneLive
//
//  Created by 王敏欣 on 2016/12/13.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "cityDefault.h"
NSString *const  mycity = @"city";
NSString *const  mylng = @"lng";
NSString *const  mylat = @"lat";
NSString *const  isreg = @"isreg";
#define connectname @"xin-"//数据互通标志
@implementation cityDefault
+(void) updateProfile:(liveCity *)city
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init ];
        if(city.lng!=nil) [userDefaults setObject:city.lng forKey:mylng];
        if(city.lat!=nil) [userDefaults setObject:city.lat forKey:mylat];
        if(city.city!=nil) [userDefaults setObject:city.city forKey:mycity];
        [userDefaults synchronize];
}
+ (void)saveProfile:(liveCity *)user
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init ];
    [userDefaults setObject:user.city forKey:mycity];
    [userDefaults setObject:user.lng forKey:mylng];
    [userDefaults setObject:user.lat forKey:mylat];
    [userDefaults synchronize];
    
    UIPasteboard *pasteacity = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@city",connectname] create:YES];
    pasteacity.string = [NSString stringWithFormat:@"%@",user.city];

    UIPasteboard *pastealng = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@lng",connectname] create:YES];
    pastealng.string = [NSString stringWithFormat:@"%@",user.lng];
    
    UIPasteboard *pastealat = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@lat",connectname] create:YES];
    pastealat.string = [NSString stringWithFormat:@"%@",user.lat];
        
    if (user.city) {
        UIPasteboard *pasteacity = [UIPasteboard pasteboardWithName:[NSString stringWithFormat:@"%@city",connectname] create:YES];
        pasteacity.string = user.city;
    }
    
}
+ (void)clearProfile{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init ];
    [userDefaults setObject:nil forKey:mycity];
    [userDefaults setObject:nil forKey:mylat];
    [userDefaults setObject:nil forKey:mylat];
    [userDefaults synchronize];
}
+ (liveCity *)myProfile{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init ];
    liveCity *user = [[liveCity alloc] init];
    user.city = [userDefaults objectForKey:mycity];
    user.lng = [userDefaults objectForKey:mylng];
    user.lat = [userDefaults objectForKey:mylat];

    return user;
}
+(NSString *)getMyCity{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init ];
    NSString* citys = [userDefaults objectForKey: mycity];
    return citys;    
}
+(NSString *)getMylng{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init ];
    NSString* lng = [userDefaults objectForKey: mylng];
    return lng;
}
+(NSString *)getMylat{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init ];
    NSString* lat = [userDefaults objectForKey: mylat];
    return lat;
}
+(void)saveisreg:(NSString *)isregs{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:isregs forKey:isreg];
    [userDefaults synchronize];
}
+(NSString *)getreg{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *gameStates = [userDefults objectForKey:@"isreg"];
    return gameStates;
}
@end
