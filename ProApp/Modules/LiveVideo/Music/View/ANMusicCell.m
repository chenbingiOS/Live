//
//  ANMusicCell.m
//  ProApp
//
//  Created by 林景安 on 2018/6/28.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "ANMusicCell.h"
#import "ANMusicPlayButton.h"
#import <Masonry.h>

#define Margin 10

@interface ANMusicCell ()
@property(nonatomic,weak) UIImageView *musicImage;
@property(nonatomic,weak) UILabel *musicName;
@property(nonatomic,weak) UILabel *musicAuth;
@property(nonatomic,weak) UILabel *useNum;
@property(nonatomic,weak) ANMusicPlayButton *musicPlayBtr;
@property(nonatomic,weak) UIView *line;
@property(nonatomic,weak) UIButton *confirmBtr;
@end



@implementation ANMusicCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"ANMusicCell";
    //先从缓存池中找可重用的cell
    ANMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //没找到就创建
    if (cell == nil) {
        cell = [[ANMusicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

//通过model放回cell高度
+(CGFloat)cellHeightWith:(ANMusicModel *)model {
    if(model.cellSelected){
        return 156;
    } else{
        return 106;
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubview];
    }
    return self;
}

#pragma mark -----------UI界面初始化----------------
-(void)initSubview{
    
    self.backgroundColor = [UIColor clearColor];
    //contentView 显示初始化
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(3, 5, 3, 5));
    }];    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.clipsToBounds=YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    //图片显示初始化
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.borderWidth = 0.5;
    imageView.layer.borderColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3].CGColor;
    imageView.clipsToBounds=YES;
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(Margin);
        make.left.mas_offset(Margin);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    imageView.userInteractionEnabled = YES;//开启交互
    
    ANMusicPlayButton *btr = [[ANMusicPlayButton alloc] init];
    [imageView addSubview:btr];
    [btr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    //按键添加监听
    [btr addTarget:self action:@selector(btrDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.musicPlayBtr = btr;
    self.musicImage = imageView;
    
    
    //歌名显示初始化
    UILabel *musicName = [[UILabel alloc] init];
    [self.contentView addSubview:musicName];
    [musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Margin);
        make.left.equalTo(imageView.mas_right).offset(Margin);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin);
        make.height.mas_equalTo(20);
    }];
    self.musicName = musicName;
    //歌手显示初始化
    UILabel *musicAuth = [[UILabel alloc] init];
    [self.contentView addSubview:musicAuth];
    [musicAuth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(musicName.mas_bottom).offset(Margin);
        make.left.equalTo(imageView.mas_right).offset(Margin);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin);
        make.height.mas_equalTo(20);
    }];
    self.musicAuth = musicAuth;
    //歌曲使用次数显示初始化
    UILabel *useNum = [[UILabel alloc] init];
    
    [self.contentView addSubview:useNum];
    [useNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(musicAuth.mas_bottom).offset(Margin);
        make.left.equalTo(imageView.mas_right).offset(Margin);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin);
        make.height.mas_equalTo(20);
    }];
    self.useNum = useNum;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.top.equalTo(imageView.mas_bottom).offset(Margin);
        make.height.mas_offset(0.5);
    }];
    self.line = line;
    
    //确认按钮
    UIButton *confirmBtr = [[UIButton alloc] init];
    [confirmBtr setTitle:@"确认" forState:UIControlStateNormal];
    
    [confirmBtr setBackgroundImageColor:RGBACOLOR(232, 71, 162, 0.9) forState:UIControlStateNormal];
    [self.contentView addSubview:confirmBtr];
    [confirmBtr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(Margin);
        make.left.mas_offset(Margin);
        make.right.mas_offset(-Margin);
        make.height.mas_offset(30);
    }];
    
    confirmBtr.layer.cornerRadius = 15;
    confirmBtr.layer.borderWidth = 0.5;
    confirmBtr.layer.borderColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3].CGColor;
    confirmBtr.clipsToBounds=YES;
    [confirmBtr addTarget:self action:@selector(confirmButtonDidClick:)  forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtr = confirmBtr;
}

#pragma mark -----------数据填充----------------
-(void)setDataWithMusicModel:(ANMusicModel *)musicModel{
    
    self.model = musicModel;
    
    self.musicPlayBtr.selected = musicModel.selected;
    NSURL *url = [NSURL URLWithString:musicModel.bgm_thumb];
    [self.musicImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_for_music"]];
    
    self.musicName.text = musicModel.bgm_name;
    self.musicAuth.attributedText = [self attributedString:@"歌手:" second:musicModel.bgm_singer];
    self.useNum.attributedText = [self attributedString:@"使用数:" second:[NSString stringWithFormat:@"%ld",musicModel.bgm_use_num]];
    
    self.line.hidden = self.confirmBtr.hidden = !musicModel.cellSelected;
    
}



#pragma mark -----------播放按钮被点击----------------
- (void)btrDidClick:(UIButton *)btr {
    if (btr.selected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ANMusicPauseButtonDidClick object:self];
        self.model.selected = btr.selected = NO;
        return;
    }
    self.model.selected = btr.selected = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:ANMusicPlayButtonDidClick object:self];
}
#pragma mark -----------确认按钮被点击 通知下载音乐----------------
-(void)confirmButtonDidClick:(UIButton *) confirmBtr{
    [[NSNotificationCenter defaultCenter] postNotificationName:ANNotificationDownLoadMusic object:self];
}

//图文混排输出
- (NSMutableAttributedString *)attributedString:(NSString *)first second:(NSString *)second{
    NSString *str = [first stringByAppendingString:second];
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:str];
    [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[str rangeOfString:first]];
    [mutableStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[str rangeOfString:first]];
    [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[str rangeOfString:second]];
    [mutableStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[str rangeOfString:second]];
    return mutableStr;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
