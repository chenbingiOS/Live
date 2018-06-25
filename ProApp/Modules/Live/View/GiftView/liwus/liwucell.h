
#import <UIKit/UIKit.h>

#import "liwuModel.h"



@interface liwucell : UICollectionViewCell
{
    UIImageView *imageView;
    UIButton *imageVs;
}




@property(nonatomic,strong)UIButton *duihao;

@property(nonatomic,strong)UIImageView *cellimageV;

@property(nonatomic,strong)UILabel *priceL;

@property(nonatomic,strong)UILabel *countL;

@property(nonatomic,strong)liwuModel *model;


@end
