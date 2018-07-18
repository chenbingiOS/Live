
#import <UIKit/UIKit.h>
@interface messageListen : UIViewController
{
     int unRead;//未读消息
     int sendMessage;
     EMConversation *em;//会话id;
     UILabel *label;
}
@property(nonatomic,strong)NSArray *conversations;//获取会话列表
@end
