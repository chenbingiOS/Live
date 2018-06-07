//
//  CBImagePickerTool.h
//  ProApp
//
//  Created by hxbjt on 2018/6/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString const * UIImagePickerControllerCircularEditedImage;

@class CBImagePickerTool;

@protocol CBImagePickerToolDelegate <NSObject>

@required
- (void)cb_imagePickerTool:(CBImagePickerTool *)imagePickerTool didFinishWithMediaInfo:(NSDictionary *)mediaInfo;
@optional
- (void)cb_imagePickerTool:(CBImagePickerTool *)imagePickerTool willPresentImagePickerController:(UIImagePickerController *)imagePicker;
- (void)cb_imagePickerToolDidCancel:(CBImagePickerTool *)imagePickerTool;

@end

@interface CBImagePickerTool : NSObject

@property (weak, nonatomic) id<CBImagePickerToolDelegate> delegate;
@property (copy, nonatomic) void(^willPresentImagePickerBlock)(CBImagePickerTool *imagePickerTool, UIImagePickerController *imagePicker);
@property (copy, nonatomic) void(^finishBlock)(CBImagePickerTool *imagePickerTool, NSDictionary *mediaInfo);
@property (copy, nonatomic) void(^cancelBlock)(CBImagePickerTool *imagePickerTool);

- (instancetype)initWithDelegate:(id<CBImagePickerToolDelegate>)delegate;
- (void)showFromView:(UIView *)view;

@end


@interface NSDictionary (CBImagePickerTool)

@property (readonly, nonatomic) UIImage      *originalImage;
@property (readonly, nonatomic) UIImage      *editedImage;
@property (readonly, nonatomic) NSURL        *mediaURL;
@property (readonly, nonatomic) NSDictionary *mediaMetadata;
@property (readonly, nonatomic) UIImage      *circularEditedImage;

@end

@interface UIImage (CBImagePickerTool)

- (UIImage *)circularImage;

@end

@interface UIActionSheet (CBImagePickerTool)

@property (strong, nonatomic) CBImagePickerTool *imagePickerTool;

@end

@interface UIAlertController (CBImagePickerTool)

@property (strong, nonatomic) CBImagePickerTool *imagePickerTool;

@end

@interface UIImagePickerController (CBImagePickerTool)

@property (strong, nonatomic) CBImagePickerTool *imagePickerTool;

@end








