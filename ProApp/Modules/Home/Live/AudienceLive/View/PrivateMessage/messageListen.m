#import "messageListen.h"

@interface messageListen ()<EMChatManagerDelegate,EMClientDelegate>
@end
@implementation messageListen
-(void)huan{
    [[EMClient sharedClient] loginWithUsername:[CBLiveUserConfig getHXuid] password:[CBLiveUserConfig getHXpwd] completion:^(NSString *aUsername, EMError *aError) {
        NSLog(@"messagelisten--%@",aError.errorDescription);        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [self huan];
}
- (void)didAutoLoginWithError:(EMError *)aError
{
    NSLog(@"  环信  %@",aError.errorDescription);
}
- (void)didLoginFromOtherDevice{
    NSLog(@"  环信  当前登录账号在其它设备登录");

}
- (void)didRemovedFromServer{
    
    NSLog(@"  环信  当前登录账号已经被从服务器端删除");
}
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState{
    NSLog(@"环信 网络状态变化  %u",aConnectionState);
}
@end
