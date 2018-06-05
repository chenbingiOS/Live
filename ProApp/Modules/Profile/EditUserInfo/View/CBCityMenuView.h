//
//  CBCityMenuView.h
//  ProApp
//
//  Created by hxbjt on 2018/6/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBPopView.h"

@class CBCityMenuView;
@protocol CBCityMenuViewDelegate <NSObject>

- (void)cityMenuView:(CBCityMenuView*)cityMenuView
    selectedProvince:(NSString*)province
                city:(NSString*)city
                area:(NSString*)area;

@end

@interface CBCityMenuView : UIView

@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) id<CBCityMenuViewDelegate> delegate;

@property (copy, nonatomic) void(^selectBlock)(CBCityMenuView *cityMenuView, NSString *province, NSString *city, NSString *area);

@end

@interface CBCityMenuPopView : CBPopView

@property (nonatomic, strong) CBCityMenuView *homeMenuView;

@end
