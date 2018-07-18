
#import "chatmessageModel.h"

#import "NSString+StringSize.h"


#import "SDWebImage/UIButton+WebCache.h"
#import "UIImageView+WebCache.h"


#define __VIEW_WIDTH__ [UIScreen mainScreen].bounds.size.width
#define __SPACE__ 15

#define __TIME_HIGTH__ 25

#define __TEXT_MAXW__ 200

@implementation chatmessageModel



- (instancetype)initWithDic:(NSDictionary *)dic

{
    self = [super init];
    
    if (self) {
               // NSNumber *num = [dic valueForKey:@"type"];
        
                _icon = [dic valueForKey:@"avatar"];
        
                _text = [dic valueForKey:@"text"];
        
                _time = [dic valueForKey:@"time"];
        
                _type = [dic valueForKey:@"type"];
        
                //[self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setMessageFrame:(chatmessageModel *)upMessage

{
    
    BOOL isEqual = [_time isEqual:upMessage.time];
    
    if (!isEqual) {
        _timeR = CGRectMake(0, 0, __VIEW_WIDTH__, __TIME_HIGTH__);
    }
    
    CGSize textSize = [_text sizeWithFont:__TEXT_FONT__ maxWidth:__TEXT_MAXW__];
    
    CGSize buttonSize = CGSizeMake(textSize.width + __EDGE_W__*3, textSize.height + __EDGE_W__*3);
    
    CGFloat textX;
    
    CGFloat textY = CGRectGetMaxY(_timeR);
    
    CGFloat iconX;
    if ([_type isEqual:@"0"]) {
        textX = __VIEW_WIDTH__ - __ICON_WIDTH__ - __SPACE__ - buttonSize.width;
        
        iconX = __VIEW_WIDTH__ - __SPACE__ - __ICON_WIDTH__;
    }
    else
    {
        textX = __ICON_WIDTH__ + __SPACE__;
        iconX = __SPACE__;
        
    }
    
    _iconR = CGRectMake(iconX, textY, __ICON_WIDTH__, __ICON_WIDTH__);
    _textR = CGRectMake(textX, textY, buttonSize.width, buttonSize.height);
    
    _rowH = MAX(CGRectGetMaxY(_textR), CGRectGetMaxY(_iconR))+__SPACE__;
    
}
+(instancetype)messageWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}



@end
