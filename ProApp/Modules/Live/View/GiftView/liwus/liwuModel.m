
#import "liwuModel.h"

#import "UIImageView+WebCache.h"

@implementation liwuModel


-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
     
        self.imagePath = [dic valueForKey:@"gifticon"];
        self.price = [dic valueForKey:@"needcoin"];
        self.num = [NSString stringWithFormat:@"+%@",[dic valueForKey:@"experience"]];
        self.type = [dic valueForKey:@"type"];
        self.giftname = [dic valueForKey:@"giftname"];
        self.ID = [dic valueForKey:@"id"];
        self.duihaiOK = 0;
        
        [self setView];
        
        
    }
    
    return self;
    
}


-(void)setView{
    
    _imageVR = CGRectMake(20,5, kScreenWidth/10,kScreenWidth/10);
    
    UIFont *font = [UIFont systemFontOfSize:15];

    CGSize  size1 = [_price boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    _priceR = CGRectMake(_imageVR.size.width/2,_imageVR.size.height+10,size1.width, size1.height);
    
    CGSize  size2 = [_num boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    _numR = CGRectMake(_imageVR.size.width/2,_imageVR.size.height + size1.height+10, size2.width, size2.height);
    
    
}

+(instancetype)modelWithDic:(NSDictionary *)dic{
    
    
    return  [[self alloc]initWithDic:dic];
}


@end
