

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define __TEXT_FONT__ [UIFont systemFontOfSize:14]
#define __TIME_FONT__ [UIFont systemFontOfSize:10]
#define __ICON_WIDTH__ 40

//内边距
#define __EDGE_W__ 15

/*
//给枚举类型MessageType进行声明（两个成员变量）
typedef enum {
    MessageTypeMe = 0,
    MessageTypeOther
}MessageType;
*/


@interface chatmessageModel : NSObject

//应该展示的数据
@property(nonatomic,copy)NSString *time;

@property(nonatomic,copy)NSString *text;

@property(nonatomic,copy)NSString *type;

@property(nonatomic,strong)NSString *icon;

//应该展示的坐标

@property(nonatomic,assign)CGRect timeR;
@property(nonatomic,assign)CGRect textR;
@property(nonatomic,assign)CGRect iconR;

@property(nonatomic,assign)CGFloat rowH;


-(void)setMessageFrame:(chatmessageModel *)upMessage;


-(instancetype)initWithDic:(NSDictionary *)dic;

+(instancetype)messageWithDic:(NSDictionary *)dic;


@end
