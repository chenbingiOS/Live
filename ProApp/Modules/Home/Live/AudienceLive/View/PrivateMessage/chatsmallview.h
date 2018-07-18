

#import <UIKit/UIKit.h>
#import "messageListen.h"
#import "messagelisviews.h"
@interface chatsmallview : messageListen<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,EMChatManagerDelegate,EMClientDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    UIView *mview;
    NSString *content;
    EMConversation *conversation;
    UIButton *emjoyBtn;
    UILabel *labell;
    UIScrollView *scrollbuttom;
    UIView *backview;
    UIView *zhezhao;
    UIView *navtion;
    UIButton *send;
    int sendok;
    UIActivityIndicatorView *testActivityIndicator;//菊花

}

@property(nonatomic,assign)int bakcOK;//判断返回

@property(nonatomic,strong)NSString *chatothsersattention;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *models;

@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,strong)NSMutableArray *allArray;

@property (nonatomic) NSTimeInterval messageTimeIntervalTag;

@property (nonatomic) NSInteger messageCountOfPage; //default 50

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSArray *emojyArray;

@property(nonatomic,strong)UIView *emojyView;

@property(nonatomic,strong)NSString *chatID;

@property(nonatomic,strong)NSString *chatname;

@property(nonatomic,strong)NSString *icon;

-(void)getnew;

@end
