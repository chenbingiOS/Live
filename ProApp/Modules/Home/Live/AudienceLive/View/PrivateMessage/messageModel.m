

#import "messageModel.h"


@implementation messageModel


-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    
    if (self) {
        
        self.userName = [dic valueForKey:@"user_nicename"];
        self.sex = [dic valueForKey:@"sex"];
        self.level = [dic valueForKey:@"level"];
        self.imageIcon = [dic valueForKey:@"avatar"];
        self.uid = [dic valueForKey:@"id"];
        
        
        self.content = [dic valueForKey:@"lastMessage"];
        self.unReadMessage  = [dic valueForKey:@"unRead"];
        self.time = [dic valueForKey:@"time"];
        
        /*
         
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        self.time = dateString;
         
        */
        
        
    }
    
    return  self;
    
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    
    return [[self alloc]initWithDic:dic];
    
}

@end
