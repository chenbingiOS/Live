

#import "liwucell.h"
#import "liwuModel.h"
#import "UIImageView+WebCache.h"


@implementation liwucell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenaaaa) name:@"cella" object:nil];
        self.cellimageV = [[UIImageView alloc]init];
        self.cellimageV.contentMode = UIViewContentModeScaleAspectFit;
         self.priceL = [[UILabel alloc]init];
        self.priceL.backgroundColor = [UIColor clearColor];
         self.priceL.textAlignment = NSTextAlignmentCenter;
        self.priceL.font = [UIFont systemFontOfSize:15];
        self.priceL.textColor = [UIColor colorWithRed:60/255.0 green:139/255.0 blue:126/255.0 alpha:1];
        self.countL = [[UILabel alloc]init];
        self.countL.textColor = [UIColor lightGrayColor];
        self.countL.backgroundColor = [UIColor clearColor];
        self.countL.numberOfLines = 0;
        self.countL.font = [UIFont systemFontOfSize:15];
        
        imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"个人中心(钻石)"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        imageVs = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 20, 4, 15,15)];
        
        imageVs.hidden = YES;
        
        [imageVs  setImage:[UIImage imageNamed:@"chat_gift_continue_normal.png"] forState:UIControlStateNormal];
        
        _duihao = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _duihao.frame = CGRectMake(self.frame.size.width - 20, 4, 15,15);
 
        [_duihao setImage:[UIImage imageNamed:@"chat_gift_continue_selected.png"] forState:UIControlStateNormal];
        
        [_duihao setHidden:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(all) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:imageVs];//连
        [self.contentView addSubview:_duihao];//对号
        [self.contentView addSubview:imageView];//魅力值
        [self.contentView addSubview:self.cellimageV];//礼物图
        [self.contentView addSubview:self.priceL];//价格
        [self.contentView addSubview:self.countL];//经验值
       // [self.contentView addSubview:btn];
    }
    return self;
}
-(void)all{
    if (_duihao.hidden == YES) {
        _duihao.hidden = NO;
    }
    else{
        _duihao.hidden = YES;
    }
}
-(void)setModel:(liwuModel *)model{
    _model = model;
    
    [self setData];
    
    if ([_model.type isEqualToString:@"1"]) {
        
        imageVs.hidden = NO;
        
    }
}

-(void)setData{
    
    
    
    [self.cellimageV sd_setImageWithURL:[NSURL URLWithString:_model.imagePath] placeholderImage:[UIImage imageNamed:@"mr.png"]];

    _priceL.text = _model.price;
    
 //   _countL.text = _model.num;
    
    _cellimageV.frame = _model.imageVR;
    
   // _countL.frame = _model.numR;
    
    _priceL.frame = _model.priceR;
    
    imageView.frame = CGRectMake(_model.priceR.size.width+_model.priceR.origin.x, _model.priceR.origin.y, 15, 15);

    
}

@end
