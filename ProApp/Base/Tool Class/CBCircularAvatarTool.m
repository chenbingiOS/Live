//
//  CBCircularAvatarTool.m
//  ProApp
//
//  Created by hxbjt on 2018/6/4.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBCircularAvatarTool.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>

NSString const * UIImagePickerControllerCircularEditedImage = @" UIImagePickerControllerCircularEditedImage;";

@interface CBCircularAvatarTool ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (UIWindow *)currentVisibleWindow;
- (UIViewController *)currentVisibleController;

- (void)delegatePerformFinishWithMediaInfo:(NSDictionary *)mediaInfo;
- (void)delegatePerformWillPresentImagePicker:(UIImagePickerController *)imagePicker;
- (void)delegatePerformCancel;

- (void)showAlertController:(UIView *)view;
- (void)showActionSheet:(UIView *)view;

- (void)takePhotoFromCamera;
- (void)takePhotoFromPhotoLibrary;

@end


@implementation CBCircularAvatarTool

#pragma mark - Life Cycle

- (instancetype)initWithDelegate:(id<CBCircularAvatarDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - Public
- (void)show {
    [self showFromView:self.currentVisibleController.view];
}

- (void)showFromView:(UIView *)view {
    if ([UIAlertController class]) {
        [self showAlertController:view];
    } else {
        [self showActionSheet:view];
    }
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    switch (buttonIndex) {
        case 0: { [self takePhotoFromCamera]; break; }
        case 1: { [self takePhotoFromPhotoLibrary]; break; }
        default: break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [self delegatePerformCancel];
    }
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self delegatePerformFinishWithMediaInfo:info];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self delegatePerformCancel];
}

#pragma mark - Private

- (void)delegatePerformFinishWithMediaInfo:(NSDictionary *)mediaInfo {
    if ([[mediaInfo allKeys] containsObject:UIImagePickerControllerEditedImage]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mediaInfo];
        dic[UIImagePickerControllerCircularEditedImage] = [dic[UIImagePickerControllerEditedImage] circularImage];
        mediaInfo = [NSDictionary dictionaryWithDictionary:dic];
    }
    if (_finishBlock) {
        _finishBlock(self,mediaInfo);
    } else if (_delegate && [_delegate respondsToSelector:@selector(cb_circularAvatar:didFinishWithMediaInfo:)]) {
        [_delegate cb_circularAvatar:self didFinishWithMediaInfo:mediaInfo];
    }
}

- (void)delegatePerformWillPresentImagePicker:(UIImagePickerController *)imagePicker {
    if (_willPresentImagePickerBlock) {
        _willPresentImagePickerBlock(self,imagePicker);
    } else if (_delegate && [_delegate respondsToSelector:@selector(cb_circularAvatar:willPresentImagePickerController:)]) {
        [_delegate cb_circularAvatar:self willPresentImagePickerController:imagePicker];
    }
}

- (void)delegatePerformCancel {
    if (_cancelBlock) {
        _cancelBlock(self);
    } else if (_delegate && [_delegate respondsToSelector:@selector(mediaPickerDidCancel:)]) {
        [_delegate cb_circularAvatarDidCancel:self];
    }
}

- (void)showActionSheet:(UIView *)view {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.circularAvatarTool = self;
    [actionSheet addButtonWithTitle:@"拍照"];
    [actionSheet addButtonWithTitle:@"选取照片"];
    [actionSheet addButtonWithTitle:@"取消"];
    actionSheet.cancelButtonIndex = 2;
    actionSheet.delegate = self;
    [actionSheet showFromRect:view.bounds inView:view animated:YES];
}

- (void)showAlertController:(UIView *)view {
    UIAlertController *alertController = [[UIAlertController alloc] init];
    alertController.circularAvatarTool = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhotoFromCamera];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhotoFromPhotoLibrary];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self delegatePerformCancel];
    }]];
    alertController.popoverPresentationController.sourceView = view;
    alertController.popoverPresentationController.sourceRect = view.bounds;
    [self.currentVisibleController presentViewController:alertController animated:YES completion:nil];
}

- (void)takePhotoFromCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePicker.circularAvatarTool = self;        
        [self delegatePerformWillPresentImagePicker:imagePicker];
        [self.currentVisibleController presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)takePhotoFromPhotoLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePicker.circularAvatarTool = self;
        [self delegatePerformWillPresentImagePicker:imagePicker];
        [self.currentVisibleController presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - Setter & Getter

- (UIWindow *)currentVisibleWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            return window;
        }
    }
    return [[[UIApplication sharedApplication] delegate] window];
}

- (UIViewController *)currentVisibleController {
    UIViewController *topController = self.currentVisibleWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

@end

@implementation NSDictionary (CBCircularAvatarTool)

- (UIImage *)originalImage {
    if ([self.allKeys containsObject:UIImagePickerControllerOriginalImage]) {
        return self[UIImagePickerControllerOriginalImage];
    }
    return nil;
}

- (UIImage *)editedImage {
    if ([self.allKeys containsObject:UIImagePickerControllerEditedImage]) {
        return self[UIImagePickerControllerEditedImage];
    }
    return nil;
}

- (UIImage *)circularEditedImage {
    if ([self.allKeys containsObject:UIImagePickerControllerCircularEditedImage]) {
        return self[UIImagePickerControllerCircularEditedImage];
    }
    return nil;
}

- (NSURL *)mediaURL {
    if ([self.allKeys containsObject:UIImagePickerControllerMediaURL]) {
        return self[UIImagePickerControllerMediaURL];
    }
    return nil;
}

- (NSDictionary *)mediaMetadata {
    if ([self.allKeys containsObject:UIImagePickerControllerMediaMetadata]) {
        return self[UIImagePickerControllerMediaMetadata];
    }
    return nil;
}

@end


@implementation UIImage (CBCircularAvatarTool)

- (UIImage *)circularImage {
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2
    
    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width, self.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGFloat rectWidth = self.size.width;
    CGFloat rectHeight = self.size.height;
    
    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [self drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

const char * circularAvatarToolKey;

@implementation UIActionSheet (CBCircularAvatarTool)

- (void)setCircularAvatarTool:(CBCircularAvatarTool *)circularAvatarTool {
    objc_setAssociatedObject(self, &circularAvatarToolKey, circularAvatarTool, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CBCircularAvatarTool *)circularAvatarTool {
    return objc_getAssociatedObject(self, &circularAvatarToolKey);
}

@end

@implementation UIAlertController (CBCircularAvatarTool)

- (void)setCircularAvatarTool:(CBCircularAvatarTool *)circularAvatarTool {
    objc_setAssociatedObject(self, &circularAvatarToolKey, circularAvatarTool, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CBCircularAvatarTool *)circularAvatarTool {
    return objc_getAssociatedObject(self, &circularAvatarToolKey);
}

@end

@implementation UIImagePickerController (CBCircularAvatarTool)

- (void)setCircularAvatarTool:(CBCircularAvatarTool *)circularAvatarTool {
    objc_setAssociatedObject(self, &circularAvatarToolKey, circularAvatarTool, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CBCircularAvatarTool *)circularAvatarTool {
    return objc_getAssociatedObject(self, &circularAvatarToolKey);
}

@end

