//
//  CBCircularAvatarTool.h
//  ProApp
//
//  Created by hxbjt on 2018/6/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString const * UIImagePickerControllerCircularEditedImage;

@class CBCircularAvatarTool;

@protocol CBCircularAvatarDelegate <NSObject>

@required
- (void)cb_circularAvatar:(CBCircularAvatarTool *)circularAvatarTool didFinishWithMediaInfo:(NSDictionary *)mediaInfo;
@optional
- (void)cb_circularAvatar:(CBCircularAvatarTool *)circularAvatarTool willPresentImagePickerController:(UIImagePickerController *)imagePicker;
- (void)cb_circularAvatarDidCancel:(CBCircularAvatarTool *)circularAvatarTool;

@end

@interface CBCircularAvatarTool : NSObject

@property (weak, nonatomic) id<CBCircularAvatarDelegate> delegate;
@property (copy, nonatomic) void(^willPresentImagePickerBlock)(CBCircularAvatarTool *circularAvatarTool, UIImagePickerController *imagePicker);
@property (copy, nonatomic) void(^finishBlock)(CBCircularAvatarTool *circularAvatarTool, NSDictionary *mediaInfo);
@property (copy, nonatomic) void(^cancelBlock)(CBCircularAvatarTool *circularAvatarTool);

- (instancetype)initWithDelegate:(id<CBCircularAvatarDelegate>)delegate;
- (void)showFromView:(UIView *)view;

@end


@interface NSDictionary (CBCircularAvatarTool)

@property (readonly, nonatomic) UIImage      *originalImage;
@property (readonly, nonatomic) UIImage      *editedImage;
@property (readonly, nonatomic) NSURL        *mediaURL;
@property (readonly, nonatomic) NSDictionary *mediaMetadata;
@property (readonly, nonatomic) UIImage      *circularEditedImage;

@end

@interface UIImage (CBCircularAvatarTool)

- (UIImage *)circularImage;

@end

@interface UIActionSheet (CBCircularAvatarTool)

@property (strong, nonatomic) CBCircularAvatarTool *circularAvatarTool;

@end

@interface UIAlertController (CBCircularAvatarTool)

@property (strong, nonatomic) CBCircularAvatarTool *circularAvatarTool;

@end

@interface UIImagePickerController (CBCircularAvatarTool)

@property (strong, nonatomic) CBCircularAvatarTool *circularAvatarTool;

@end








