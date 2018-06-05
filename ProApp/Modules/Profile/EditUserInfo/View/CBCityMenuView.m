//
//  CBCityMenuView.m
//  ProApp
//
//  Created by hxbjt on 2018/6/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBCityMenuView.h"

@interface CBCityMenuView () <UIPickerViewDelegate,UIPickerViewDataSource>

// 数据源
@property (nonatomic, strong) NSArray<NSMutableArray*> *dataArray;
// 数据源数组
@property (nonatomic, strong) NSMutableArray *allProvinces;// 所有省信息
@property (nonatomic, strong) NSMutableArray *allCities;// 一个省的所有城市信息
@property (nonatomic, strong) NSMutableArray *currentCityArray;// 当前省的 所有城市名称
@property (nonatomic, strong) NSMutableArray *currentAreaArray;// 当前市的 所有区名称
// 记录当前行
@property (nonatomic, assign) NSInteger provinceIndex;
@property (nonatomic, assign) NSInteger cityIndex;
// 记录当前省市区
@property (nonatomic, copy) NSString *currentProvince;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *currentArea;

@end

@implementation CBCityMenuView

#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont fontWithName:@"PingFang-SC-Regular" size:16]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray[component].count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return [UIScreen mainScreen].bounds.size.width / self.dataArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    for (UIView *subView in pickerView.subviews) {
        if (subView.frame.size.height <= 1) {//获取分割线view
            subView.hidden = NO;
            subView.frame = CGRectMake(0, subView.frame.origin.y, subView.frame.size.width, 0.5);
            subView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];//设置分割线颜色
        }
    }
    switch (component) {
        case 0: return [self.allProvinces[row] objectForKey:@"divisionName"]; break;
        case 1: return self.currentCityArray[row]; break;
        case 2: return self.currentAreaArray[row]; break;
        default: break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        // 重置当前城市数组
        self.provinceIndex = row;
        [self resetCityArray];
        // 刷新城市列表,并滚动至第一行
        [self scrollToTopRowAtComponent:1];
        // 记录当前城市
        _currentCity = _currentCityArray[0];
        // 根据当前城市重置区数组
        self.cityIndex = [_currentCityArray indexOfObject:_currentCity];
        [self resetAreaArray];
        // 刷新区列表,并滚动至第一行
        [self scrollToTopRowAtComponent:2];
        // 记录当前
        _currentProvince = [_allProvinces[row] objectForKey:@"divisionName"];
        // 记录当前区
        if (_currentAreaArray.count) {
            _currentArea = _currentAreaArray[0];
        }
        else{
            _currentArea = @"";
        }
    }
    else if(component == 1){
        // 记录当前城市
        _currentCity = _currentCityArray[row];
        // 根据当前城市重置区数组
        self.cityIndex = row;
        [self resetAreaArray];
        // 刷新区列表,并滚动至第一行
        [self scrollToTopRowAtComponent:2];
        if (_currentAreaArray.count) {
            _currentArea = _currentAreaArray[0];
        }
        else{
            _currentArea = @"";
        }
    }
    else{
        // 重置当前区
        if (_currentAreaArray.count) {
            _currentArea = _currentAreaArray[row];
        }
        else{
            _currentArea = @"";
        }
    }
}

/** 获取plist文件路径 */
-(NSString*)addressFilePath{
    return [[NSBundle mainBundle] pathForResource:@"CB_address.plist" ofType:nil];
}

/** 获取当前省 的市数组 */
-(void)resetCityArray{
    [self.currentCityArray removeAllObjects];
    // 当前省信息字典
    NSDictionary *currentPorvinceDict = self.allProvinces[_provinceIndex];
    // 当前省编码
    NSString *cityPostcode = [currentPorvinceDict objectForKey:@"divisionCode"];
    // 根据省编码 获取 市信息数组
    NSArray *cityArr = [[NSDictionary dictionaryWithContentsOfFile:[self addressFilePath]] objectForKey:cityPostcode];
    self.allCities = [NSMutableArray arrayWithArray:cityArr];
    // 重置城市数组
    for (NSDictionary *dict in cityArr) {
        [_currentCityArray addObject:[dict objectForKey:@"divisionName"]];
    }
}

/** 根据当前城市编号 获取区数组 */
-(void)resetAreaArray{
    [self.currentAreaArray removeAllObjects];
    NSString *currentCityPostcode = [_allCities[_cityIndex] objectForKey:@"divisionCode"];
    // 根据市编码 获取 区信息数组
    NSArray *areaArr = [[NSDictionary dictionaryWithContentsOfFile:[self addressFilePath]] objectForKey:currentCityPostcode];
    // 重置区数组
    for (NSDictionary *dict in areaArr) {
        [_currentAreaArray addObject:[dict objectForKey:@"divisionName"]];
    }
}

/** 刷新区列表,并滚动至第一行 */
-(void)scrollToTopRowAtComponent:(NSInteger)component{
    [self.pickerView reloadComponent:component];
    [self.pickerView selectRow:0 inComponent:component animated:YES];
}

#pragma mark - lazy
/** 所有省字典数据 */
-(NSMutableArray*)allProvinces{
    if (!_allProvinces) {
        _allProvinces = [[NSDictionary dictionaryWithContentsOfFile:[self addressFilePath]] objectForKey:@"provinces"];
        _currentProvince = [_allProvinces[0] objectForKey:@"divisionName"];// 初始化当前省
    }
    return _allProvinces;
}

/** 市名称 数组 */
-(NSMutableArray*)currentCityArray{
    if (!_currentCityArray) {
        _currentCityArray = [[NSMutableArray alloc] init];
        // 重置城市数组
        [self resetCityArray];
        _currentCity = _currentCityArray[0];
    }
    return _currentCityArray;
}

/** 区名称 数组 */
-(NSMutableArray*)currentAreaArray{
    if (!_currentAreaArray) {
        _currentAreaArray = [[NSMutableArray alloc] init];
        // 重置区数组
        [self resetAreaArray];
        _currentArea = _currentAreaArray[0];
    }
    return _currentAreaArray;
}

- (NSArray<NSMutableArray *> *)dataArray {
    if (!_dataArray) {
        [self allProvinces];// 初始化所有省数据
        [self currentCityArray]; //初始化当前市数据
        [self currentAreaArray];// 初始化当前区数组
        _dataArray = @[self.allProvinces, self.currentCityArray, self.currentAreaArray];
    }
    return _dataArray;
}

- (IBAction)actionOKSelect:(id)sender {
    if (self.selectBlock) {
        self.selectBlock(self, _currentProvince, _currentCity, _currentArea);
    }    
    if ([self.delegate respondsToSelector:@selector(cityMenuView:selectedProvince:city:area:)]) {
        [self.delegate cityMenuView:self selectedProvince:_currentProvince city:_currentCity area:_currentArea];
    }
}

@end

@implementation CBCityMenuPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置参数 (否则用默认值)
        self.popType = PopTypeMove;
        self.moveAppearCenterY = kScreenHeight - self.height/2;
        self.moveAppearDirection = MoveAppearDirectionFromBottom;
        self.moveDisappearDirection = MoveDisappearDirectionToBottom;
        self.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.animateDuration = 0.35;
        self.radius = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.homeMenuView];
        
        @weakify(self);
        [self.homeMenuView.closeBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            [self hide];
        }];
    }
    return self;
}

- (CBCityMenuView *)homeMenuView {
    if (!_homeMenuView) {
        _homeMenuView = [CBCityMenuView viewFromXib];
        _homeMenuView.frame = CGRectMake(0, 0, kScreenWidth, 244);
    }
    return _homeMenuView;
}

@end
