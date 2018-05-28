//
//  CBRecordVideoVC.m
//  ProApp
//
//  Created by hxbjt on 2018/5/25.
//  Copyright © 2018年 ChenBing. All rights reserved.
//

#import "CBRecordVideoVC.h"
#import "UIButton+LXMImagePosition.h"

#import "PLShortVideoKit/PLShortVideoKit.h"
#import "PLSProgressBar.h"
#import "PLSDeleteButton.h"
#import "EditViewController.h"
#import <Photos/Photos.h>
#import "PhotoAlbumViewController.h"
#import "PLSEditVideoCell.h"
#import "PLSFilterGroup.h"
#import "PLSViewRecorderManager.h"
#import "PLSRateButtonView.h"

// TuSDK mark - 导入
#import "FilterView.h"
#import "StickerScrollView.h"
#import <TuSDKVideo/TuSDKVideo.h>

#define AlertViewShow(msg) [[[UIAlertView alloc] initWithTitle:@"warning" message:[NSString stringWithFormat:@"%@", msg] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]

#define PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG 10001
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define PLS_RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

@interface CBRecordVideoVC ()
<
PLShortVideoRecorderDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
PLSViewRecorderManagerDelegate,
PLSRateButtonViewDelegate,
FilterViewEventDelegate, StickerViewClickDelegate, TuSDKFilterProcessorDelegate
>

@property (strong, nonatomic) PLSVideoConfiguration *videoConfiguration;
@property (strong, nonatomic) PLSAudioConfiguration *audioConfiguration;
@property (strong, nonatomic) PLShortVideoRecorder *shortVideoRecorder;
@property (strong, nonatomic) PLSViewRecorderManager *viewRecorderManager;
@property (strong, nonatomic) PLSProgressBar *progressBar;
@property (strong, nonatomic) UIButton *recordButton;

@property (strong, nonatomic) PLSDeleteButton *deleteButton;
@property (strong, nonatomic) UIButton *endButton;
@property (strong, nonatomic) PLSRateButtonView *rateButtonView;
@property (strong, nonatomic) NSArray *titleArray;
@property (assign, nonatomic) NSInteger titleIndex;

@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *recordToolboxView;
@property (strong, nonatomic) UIImageView *indicator;
@property (strong, nonatomic) UILabel *durationLabel;

@property (strong, nonatomic) UIAlertView *alertView;


// 录制的视频文件的存储路径设置
@property (assign, nonatomic) BOOL useSDKInternalPath;

// 录制时是否使用SDK内部滤镜
@property (assign, nonatomic) BOOL isUseFilterWhenRecording;
// 录制时是否使用外部滤镜
@property (assign, nonatomic) BOOL isUseExternalFilterWhenRecording;

// 所有滤镜
@property (strong, nonatomic) PLSFilterGroup *filterGroup;
// 展示所有滤镜的集合视图
@property (strong, nonatomic) UICollectionView *editVideoCollectionView;
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *filtersArray;
@property (assign, nonatomic) NSInteger filterIndex;

// 录制前是否开启自动检测设备方向调整视频拍摄的角度（竖屏、横屏）
@property (assign, nonatomic) BOOL isUseAutoCheckDeviceOrientationBeforeRecording;

// TuSDK mark - 初始化数据
// 滤镜列表
@property (strong, nonatomic) NSArray *videoFilters;
// 当前的滤镜索引
@property (assign, nonatomic) NSInteger videoFilterIndex;

// TuSDK mark - 初始化对象
// 滤镜栏
@property (nonatomic, strong) FilterView *filterView;
// 贴纸栏
@property (nonatomic, strong) StickerScrollView *stickerView;
// TuSDK美颜处理类
@property (nonatomic,strong) TuSDKFilterProcessor *filterProcessor;
// 当前获取的滤镜对象
@property (nonatomic,strong) TuSDKFilterWrap *currentFilter;

@end

@implementation CBRecordVideoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.shortVideoRecorder startCaptureSession];
    [self getFirstMovieFromPhotoAlbum];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.shortVideoRecorder stopCaptureSession];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 录制时默认开启SDK内部滤镜功能
        self.isUseFilterWhenRecording = YES;
        // 录制时默认开启外部滤镜功能
        self.isUseExternalFilterWhenRecording = NO;
        // 录制前默认打开自动检测设备方向调整视频拍摄的角度（竖屏、横屏）
        self.isUseAutoCheckDeviceOrientationBeforeRecording = YES;
        
        if (self.isUseFilterWhenRecording) {
            // 滤镜
            self.filterGroup = [[PLSFilterGroup alloc] init];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // 短视频录制核心类设置
    [self setupShortVideoRecorder];
    // UI
    [self setupBaseToolboxView];
    [self setupRecordToolboxView];
    // TuSDK mark - 初始化
    [self initTUSDK];
}

// 短视频录制核心类设置
- (void)setupShortVideoRecorder {
    // SDK 的版本信息
    NSLog(@"PLShortVideoRecorder versionInfo: %@", [PLShortVideoRecorder versionInfo]);
    
    self.videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
    self.videoConfiguration.position = AVCaptureDevicePositionFront;
    self.videoConfiguration.videoFrameRate = 25;
    self.videoConfiguration.averageVideoBitRate = 1024*1000;
    self.videoConfiguration.videoSize = CGSizeMake(544, 960);
    self.videoConfiguration.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    self.audioConfiguration = [PLSAudioConfiguration defaultConfiguration];
    
    self.shortVideoRecorder = [[PLShortVideoRecorder alloc] initWithVideoConfiguration:self.videoConfiguration audioConfiguration:self.audioConfiguration];
    self.shortVideoRecorder.delegate = self;
    self.shortVideoRecorder.maxDuration = 10.0f; // 设置最长录制时长
    self.shortVideoRecorder.outputFileType = PLSFileTypeMPEG4;
    self.shortVideoRecorder.innerFocusViewShowEnable = YES; // 显示 SDK 内部自带的对焦动画
    self.shortVideoRecorder.previewView.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT);
    [self.view addSubview:self.shortVideoRecorder.previewView];
    
    // 默认开启美颜功能
    [self.shortVideoRecorder setBeautifyModeOn:YES];
    
    // 录制前是否开启自动检测设备方向调整视频拍摄的角度（竖屏、横屏）
    if (self.isUseAutoCheckDeviceOrientationBeforeRecording) {
        self.shortVideoRecorder.adaptationRecording = YES; // 根据设备方向自动确定横屏 or 竖屏拍摄效果
        [self.shortVideoRecorder setDeviceOrientationBlock:^(PLSPreviewOrientation deviceOrientation){
            switch (deviceOrientation) {
                case PLSPreviewOrientationPortrait:
                    NSLog(@"deviceOrientation : PLSPreviewOrientationPortrait");
                    break;
                case PLSPreviewOrientationPortraitUpsideDown:
                    NSLog(@"deviceOrientation : PLSPreviewOrientationPortraitUpsideDown");
                    break;
                case PLSPreviewOrientationLandscapeRight:
                    NSLog(@"deviceOrientation : PLSPreviewOrientationLandscapeRight");
                    break;
                case PLSPreviewOrientationLandscapeLeft:
                    NSLog(@"deviceOrientation : PLSPreviewOrientationLandscapeLeft");
                    break;
                default:
                    break;
            }
        }];
    }
    
    // 默认关闭SDK内部滤镜
    if (self.isUseFilterWhenRecording) {
        // 滤镜资源
        self.filtersArray = [[NSMutableArray alloc] init];
        for (NSDictionary *filterInfoDic in self.filterGroup.filtersInfo) {
            NSString *name = [filterInfoDic objectForKey:@"name"];
            NSString *coverImagePath = [filterInfoDic objectForKey:@"coverImagePath"];
            NSDictionary *dic = @{ @"name"            : name,
                                   @"coverImagePath"  : coverImagePath };
            [self.filtersArray addObject:dic];
        }
        
        // 展示多种滤镜的 UICollectionView
        CGRect frame = self.editVideoCollectionView.frame;
        CGFloat x = PLS_BaseToolboxView_HEIGHT;
        CGFloat y = PLS_BaseToolboxView_HEIGHT;
        CGFloat width = frame.size.width - 2*x;
        CGFloat height = frame.size.height;
        self.editVideoCollectionView.frame = CGRectMake(x, y, width, height);
        [self.view addSubview:self.editVideoCollectionView];
        [self.editVideoCollectionView reloadData];
        self.editVideoCollectionView.hidden = YES;
    }
}

// 基本工具栏
- (void)setupBaseToolboxView {
    
    // 返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 35, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"ShortVideo_close"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 左边工具条
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-64, 35, 64, kScreenWidth+64)];
    self.baseToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.baseToolboxView];
    // 切换摄像头
    UIButton *toggleCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleCameraButton.frame = CGRectMake(0, 0, 64, 64);
    [toggleCameraButton setTitle:@"切镜头" forState:UIControlStateNormal];
    toggleCameraButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    [toggleCameraButton setImage:[UIImage imageNamed:@"ShortVideo_lens"] forState:UIControlStateNormal];
    [toggleCameraButton addTarget:self action:@selector(toggleCameraButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [toggleCameraButton setImagePosition:LXMImagePositionTop spacing:4];
    [self.baseToolboxView addSubview:toggleCameraButton];
    
    // 倒计时
    UIButton *countdownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    countdownButton.frame = CGRectMake(0, 64+15, 64, 64);
    [countdownButton setTitle:@"倒计时" forState:UIControlStateNormal];
    countdownButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    [countdownButton setImage:[UIImage imageNamed:@"ShortVideo_countdown"] forState:UIControlStateNormal];
    [countdownButton addTarget:self action:@selector(toggleCameraButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [countdownButton setImagePosition:LXMImagePositionTop spacing:4];
    [self.baseToolboxView addSubview:countdownButton];
    
    // 七牛滤镜
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(0, 128+15+15, 64, 64);
    [filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    filterButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    [filterButton setImage:[UIImage imageNamed:@"ShortVideo_filter"] forState:UIControlStateNormal];
    [filterButton setImagePosition:LXMImagePositionTop spacing:4];
    [filterButton addTarget:self action:@selector(filterButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:filterButton];
    
    // 外部人脸识别加贴纸
    UIButton *externalStickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    externalStickerButton.frame = CGRectMake(0, 192+15+15+15, 64, 64);
    [externalStickerButton setTitle:@"贴纸" forState:UIControlStateNormal];
    externalStickerButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    [externalStickerButton setImage:[UIImage imageNamed:@"ShortVideo_meme"] forState:UIControlStateNormal];
    [externalStickerButton setImagePosition:LXMImagePositionTop spacing:4];
    [externalStickerButton addTarget:self action:@selector(externalStickerButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:externalStickerButton];
    
    self.useSDKInternalPath = YES;
}

// 录制工具栏
- (void)setupRecordToolboxView {
    CGFloat y = PLS_BaseToolboxView_HEIGHT + PLS_SCREEN_WIDTH;
    self.recordToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, y, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT- y)];
    self.recordToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.recordToolboxView];
    
    // 倍数拍摄
    self.titleArray = @[@"极慢", @"慢", @"正常", @"快", @"极快"];
    CGFloat rateTopSapce;
    if (PLS_SCREEN_HEIGHT > 568) {
        rateTopSapce = 50;
    } else {
        rateTopSapce = 45;
    }
    self.rateButtonView = [[PLSRateButtonView alloc] initWithFrame:CGRectMake(PLS_SCREEN_WIDTH/2 - 150, rateTopSapce, 300, 28) defaultIndex:2];
    self.rateButtonView.hidden = NO;
    self.titleIndex = 2;
    CGFloat countSpace = 200 /self.titleArray.count / 6;
    self.rateButtonView.space = countSpace;
    self.rateButtonView.staticTitleArray = self.titleArray;
    self.rateButtonView.rateDelegate = self;
    [self.recordToolboxView addSubview:self.rateButtonView];
    
    // 录制视频的操作按钮
    CGFloat buttonWidth = 80.0f;
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
    self.recordButton.center = CGPointMake(PLS_SCREEN_WIDTH / 2, self.recordToolboxView.frame.size.height - 100);
    [self.recordButton setImage:[UIImage imageNamed:@"shortVideo_end_video"] forState:UIControlStateNormal];
    [self.recordButton addTarget:self action:@selector(recordButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordToolboxView addSubview:self.recordButton];
    
    // 删除视频片段的按钮
    CGPoint center = self.recordButton.center;
    center.x = 100;
    self.deleteButton = [PLSDeleteButton getInstance];
    self.deleteButton.style = PLSDeleteButtonStyleNormal;
    self.deleteButton.frame = CGRectMake(0, 0, 40, 40);
    self.deleteButton.center = center;
    [self.deleteButton setImage:[UIImage imageNamed:@"ShortVideo_cancel_video"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordToolboxView addSubview:self.deleteButton];
    self.deleteButton.hidden = YES;
    
    // 结束录制的按钮
    center = self.recordButton.center;
    center.x = kScreenWidth - 100;
    self.endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.endButton.frame = CGRectMake(0, 0, 40, 40);
    self.endButton.center = center;
    [self.endButton setImage:[UIImage imageNamed:@"ShortVideo_finish_video"] forState:UIControlStateNormal];
    [self.endButton addTarget:self action:@selector(endButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.endButton.enabled = NO;
    [self.recordToolboxView addSubview:self.endButton];
    self.endButton.hidden = YES;
    
    // 视频录制进度条
    self.progressBar = [[PLSProgressBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.recordToolboxView.frame) - 10, PLS_SCREEN_WIDTH, 10)];
    [self.recordToolboxView addSubview:self.progressBar];
    
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake((PLS_SCREEN_WIDTH - 130)/2, CGRectGetHeight(self.recordToolboxView.frame) - 45, 130, 40)];
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", self.shortVideoRecorder.getTotalDuration];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    [self.recordToolboxView addSubview:self.durationLabel];
    
    // 导入视频的操作按钮
    center = self.recordButton.center;
    center.x = CGRectGetWidth([UIScreen mainScreen].bounds) - 60;
}

#pragma mark -- Button event
// 获取相册中最新的一个视频的封面
- (void)getFirstMovieFromPhotoAlbum {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.includeHiddenAssets = NO;
        fetchOptions.includeAllBurstAssets = NO;
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO],
                                         [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchOptions];
        
        NSMutableArray *assets = [[NSMutableArray alloc] init];
        [fetchResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [assets addObject:obj];
        }];
        
        if (assets.count > 0) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            CGSize size = CGSizeMake(50, 50);
            [[PHImageManager defaultManager] requestImageForAsset:assets[0] targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                
                // 设置的 options 可能会导致该回调调用两次，第一次返回你指定尺寸的图片，第二次将会返回原尺寸图片
                if ([[info valueForKey:@"PHImageResultIsDegradedKey"] integerValue] == 0){
                    // Do something with the FULL SIZED image
                    
                } else {
                    // Do something with the regraded image
                    
                }
            }];
        }
    });
}

// 返回上一层
- (void)backButtonEvent:(id)sender {
    if ([self.shortVideoRecorder getFilesCount] > 0) {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:[NSString stringWithFormat:@"放弃这个视频(共%ld个视频段)?", (long)[self.shortVideoRecorder getFilesCount]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertView.tag = PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG;
        [self.alertView show];
    } else {
        [self discardRecord];
    }
}

// 切换前后置摄像头
- (void)toggleCameraButtonEvent:(id)sender {
    [self.shortVideoRecorder toggleCamera];
}

// 七牛滤镜
- (void)filterButtonEvent:(UIButton *)button {
    button.selected = !button.selected;
    self.editVideoCollectionView.hidden = !button.selected;
}

// 删除上一段视频
- (void)deleteButtonEvent:(id)sender {
    if (_deleteButton.style == PLSDeleteButtonStyleNormal) {
        [_progressBar setLastProgressToStyle:PLSProgressBarProgressStyleDelete];
        _deleteButton.style = PLSDeleteButtonStyleDelete;
        
    } else if (_deleteButton.style == PLSDeleteButtonStyleDelete) {
        
        [self.shortVideoRecorder deleteLastFile];
        
        [_progressBar deleteLastProgress];
        
        _deleteButton.style = PLSDeleteButtonStyleNormal;
    }
}

// 录制视频
- (void)recordButtonEvent:(id)sender {
    if (self.shortVideoRecorder.isRecording) {
        [self.shortVideoRecorder stopRecording];
    } else {
        if (self.useSDKInternalPath) {
            // 方式1
            // 录制的视频的存放地址由 SDK 内部自动生成
            [self.shortVideoRecorder startRecording];
        } else {
            // 方式2
            // fileURL 录制的视频的存放地址，该参数可以在外部设置，录制的视频会保存到该位置
            [self.shortVideoRecorder startRecording:[self getFileURL]];
        }
    }
}

- (NSURL *)getFileURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:@"TestPath"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]) {
        // 如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mp4"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:fileName];
    
    return fileURL;
}

// 结束录制
- (void)endButtonEvent:(id)sender {
    AVAsset *asset = self.shortVideoRecorder.assetRepresentingAllFiles;
    [self playEvent:asset];
    [self.viewRecorderManager cancelRecording];
    
}

// 取消录制
- (void)discardRecord {
    [self.shortVideoRecorder cancelRecording];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG:
        {
            switch (buttonIndex) {
                case 0:
                    
                    break;
                case 1:
                {
                    [self discardRecord];
                }
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- PLSRateButtonViewDelegate
- (void)rateButtonView:(PLSRateButtonView *)rateButtonView didSelectedTitleIndex:(NSInteger)titleIndex{
    self.titleIndex = titleIndex;
    switch (titleIndex) {
        case 0:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateTopSlow;
            break;
        case 1:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateSlow;
            break;
        case 2:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateNormal;
            break;
        case 3:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateFast;
            break;
        case 4:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateTopFast;
            break;
        default:
            break;
    }
}

#pragma mark - PLSViewRecorderManagerDelegate
- (void)viewRecorderManager:(PLSViewRecorderManager *)manager didFinishRecordingToAsset:(AVAsset *)asset totalDuration:(CGFloat)totalDuration {
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    plsMovieSettings[PLSAssetKey] = asset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:totalDuration];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    EditViewController *videoEditViewController = [[EditViewController alloc] init];
    videoEditViewController.settings = outputSettings;
    [self presentViewController:videoEditViewController animated:YES completion:nil];
}

#pragma mark -- PLShortVideoRecorderDelegate 摄像头／麦克风鉴权的回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didGetCameraAuthorizationStatus:(PLSAuthorizationStatus)status {
    if (status == PLSAuthorizationStatusAuthorized) {
        [recorder startCaptureSession];
    }
    else if (status == PLSAuthorizationStatusDenied) {
        NSLog(@"Error: user denies access to camera");
    }
}

- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didGetMicrophoneAuthorizationStatus:(PLSAuthorizationStatus)status {
    if (status == PLSAuthorizationStatusAuthorized) {
        [recorder startCaptureSession];
    }
    else if (status == PLSAuthorizationStatusDenied) {
        NSLog(@"Error: user denies access to microphone");
    }
}

#pragma mark - PLShortVideoRecorderDelegate 摄像头对焦位置的回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFocusAtPoint:(CGPoint)point {
    NSLog(@"shortVideoRecorder: didFocusAtPoint: %@", NSStringFromCGPoint(point));
}

#pragma mark - PLShortVideoRecorderDelegate 摄像头采集的视频数据的回调
/// @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
- (CVPixelBufferRef)shortVideoRecorder:(PLShortVideoRecorder *)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    //此处可以做美颜/滤镜等处理
    // 是否在录制时使用SDK内部滤镜
    if (self.isUseFilterWhenRecording) {
        PLSFilter *filter = self.filterGroup.currentFilter;
        pixelBuffer = [filter process:pixelBuffer];
    }
    
    if (self.isUseExternalFilterWhenRecording) {
        // TuSDK mark - TUSDK 美颜处理 暂时屏蔽其他滤镜处理，可根据需求使用
        pixelBuffer =  [_filterProcessor syncProcessPixelBuffer:pixelBuffer];
        [_filterProcessor destroyFrameData];
    }
    
    return pixelBuffer;
}

#pragma mark -- PLShortVideoRecorderDelegate 视频录制回调
// 开始录制一段视频时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didStartRecordingToOutputFileAtURL:(NSURL *)fileURL {
    NSLog(@"start recording fileURL: %@", fileURL);
    
    [self.progressBar addProgressView];
    [_progressBar startShining];
}

// 正在录制的过程中
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    [_progressBar setLastProgressToWidth:fileDuration / self.shortVideoRecorder.maxDuration * _progressBar.frame.size.width];
    
    self.endButton.enabled = (totalDuration >= self.shortVideoRecorder.minDuration);
    
    self.deleteButton.hidden = YES;
    self.endButton.hidden = YES;
    
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", totalDuration];
}

// 删除了某一段视频
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didDeleteFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"delete fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    
    self.endButton.enabled = totalDuration >= self.shortVideoRecorder.minDuration;
    
    if (totalDuration <= 0.0000001f) {
        self.deleteButton.hidden = YES;
        self.endButton.hidden = YES;
    }
    
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", totalDuration];
}

// 完成一段视频的录制时
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"finish recording fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    
    [_progressBar stopShining];
    
    self.deleteButton.hidden = NO;
    self.endButton.hidden = NO;
    
    if (totalDuration >= self.shortVideoRecorder.maxDuration) {
        [self endButtonEvent:nil];
    }
}

// 在达到指定的视频录制时间 maxDuration 后，如果再调用 [PLShortVideoRecorder startRecording]，直接执行该回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFinishRecordingMaxDuration:(CGFloat)maxDuration {
    NSLog(@"finish recording maxDuration: %f", maxDuration);
    
    AVAsset *asset = self.shortVideoRecorder.assetRepresentingAllFiles;
    [self playEvent:asset];
    [self.viewRecorderManager cancelRecording];
}

#pragma mark -- 下一步
- (void)playEvent:(AVAsset *)asset {
    // 获取当前会话的所有的视频段文件
    NSArray *filesURLArray = [self.shortVideoRecorder getAllFilesURL];
    NSLog(@"filesURLArray:%@", filesURLArray);
    
    __block AVAsset *movieAsset = asset;
    
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    plsMovieSettings[PLSAssetKey] = movieAsset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self.shortVideoRecorder getTotalDuration]];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    EditViewController *videoEditViewController = [[EditViewController alloc] init];
    videoEditViewController.settings = outputSettings;
    videoEditViewController.filesURLArray = filesURLArray;
    [self presentViewController:videoEditViewController animated:YES completion:nil];
}
#pragma mark - 输出路径
- (NSURL *)exportAudioMixPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *fileName = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_mix.mp4",nowTimeStr]];
    return [NSURL fileURLWithPath:fileName];
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- dealloc
- (void)dealloc {
    self.shortVideoRecorder.delegate = nil;
    self.shortVideoRecorder = nil;
    self.filtersArray = nil;
    self.alertView = nil;
    NSLog(@"dealloc: %@", [[self class] description]);
}

#pragma mark -- UICollectionView delegate  用来展示和处理 SDK 内部自带的滤镜效果
// 加载 collectionView 视图
- (UICollectionView *)editVideoCollectionView {
    if (!_editVideoCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(50, 65);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _editVideoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, layout.itemSize.height) collectionViewLayout:layout];
        _editVideoCollectionView.backgroundColor = [UIColor clearColor];
        
        _editVideoCollectionView.showsHorizontalScrollIndicator = NO;
        _editVideoCollectionView.showsVerticalScrollIndicator = NO;
        [_editVideoCollectionView setExclusiveTouch:YES];
        
        [_editVideoCollectionView registerClass:[PLSEditVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([PLSEditVideoCell class])];
        
        _editVideoCollectionView.delegate = self;
        _editVideoCollectionView.dataSource = self;
    }
    return _editVideoCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.filtersArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLSEditVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PLSEditVideoCell class]) forIndexPath:indexPath];
    
    // 滤镜
    NSDictionary *filterInfoDic = self.filtersArray[indexPath.row];
    
    NSString *name = [filterInfoDic objectForKey:@"name"];
    NSString *coverImagePath = [filterInfoDic objectForKey:@"coverImagePath"];
    
    cell.iconPromptLabel.text = name;
    cell.iconImageView.image = [UIImage imageWithContentsOfFile:coverImagePath];
    
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 滤镜
    self.filterGroup.filterIndex = indexPath.row;
}

#pragma mark - TuSDK method

- (void)checkBundleId {
    // 需要提供包名，获取对应的资源才可以请用。
    // 获取到对应包名的资源之后，设置 self.isUseExternalFilterWhenRecording = YES; 即可使用
    AlertViewShow(@"使用高级滤镜和人脸贴纸特效，请联系七牛销售！");
}

- (void)externalStickerButtonOnClick:(UIButton *)button {
    [self checkBundleId];
    
    if (!_stickerView) {
        [self initStickerView];
    }
    
    _stickerView.hidden = !_stickerView.hidden;
    if (!_stickerView.hidden) {
        _filterView.hidden = YES;
    }
}

// TuSDK mark - 初始化
- (void)initTUSDK {
    [self initFilterCodes];
    [self initFilterProcessor];
}

- (void)initFilterCodes {
    self.videoFilters = @[@"Normal",@"porcelain",@"nature",@"pink",@"jelly",@"ruddy",@"sugar",@"honey",@"clear",@"timber",@"whitening"];
    self.videoFilterIndex = 0;
}

// 初始化 TuSDKFilterProcessor
- (void)initFilterProcessor {
    // 传入图像的方向是否为原始朝向(相机采集的原始朝向)，SDK 将依据该属性来调整人脸检测时图片的角度。如果没有对图片进行旋转，则为 YES
    BOOL isOriginalOrientation = NO;
    
    self.filterProcessor = [[TuSDKFilterProcessor alloc] initWithFormatType:kCVPixelFormatType_32BGRA isOriginalOrientation:isOriginalOrientation];
    self.filterProcessor.delegate = self;
    
    // 是否开启了镜像
    self.filterProcessor.horizontallyMirrorFrontFacingCamera = NO;
    // 前置还是后置
    
    self.filterProcessor.outputPixelFormatType = lsqFormatTypeBGRA;
    
    
    self.filterProcessor.cameraPosition = AVCaptureDevicePositionFront;
    self.filterProcessor.adjustOutputRotation = NO;
    [self.filterProcessor setEnableLiveSticker:YES];
    
    // 切换滤镜
    [self.filterProcessor switchFilterWithCode:self.videoFilters[1]];
}

- (void)initFilterView {
    // 注：当前Demo中参数调节栏和左滑油滑手势冲突，在自己的项目中可自定义UI
    CGFloat filterViewHeight = 246;
    _filterView = [[FilterView alloc]initWithFrame:CGRectMake(0, self.view.lsqGetSizeHeight - filterViewHeight, self.view.lsqGetSizeWidth, filterViewHeight)];
    _filterView.canAdjustParameter = true;
    _filterView.filterEventDelegate = self;
    _filterView.currentFilterTag = 1;
    _filterView.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.7];
    [_filterView createFilterWith:_videoFilters];
    [_filterView refreshAdjustParameterViewWith:_currentFilter.code filterArgs:_currentFilter.filterParameter.args];
    
    [self.view addSubview:_filterView];
    _filterView.hidden = YES;
}

- (void)initStickerView {
    CGFloat stickerViewHeight = 246;
    _stickerView = [[StickerScrollView alloc]initWithFrame:CGRectMake(0, self.view.lsqGetSizeHeight - stickerViewHeight, self.view.lsqGetSizeWidth, stickerViewHeight)];
    _stickerView.stickerDelegate = self;
    _stickerView.cameraStickerType = lsqCameraStickersTypeSquare;
    _stickerView.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.7];
    [self.view addSubview:_stickerView];
    _stickerView.hidden = YES;
}

#pragma mark -- 滤镜栏点击代理方法 FilterEventDelegate

// 调节滤镜效果
- (void)filterViewParamChangedWith:(TuSDKICSeekBar *)seekbar changedProgress:(CGFloat)progress {
    //根据tag获得当前滤镜的对应参数，修改precent;
    NSInteger index = seekbar.tag;
    TuSDKFilterArg *arg = _currentFilter.filterParameter.args[index];
    
    NSLog(@"当前调节的滤镜参数名为 : %@",arg.key);
    
    if ([arg.key isEqualToString:@"smoothing"]) {
        
        // value range 0-1
        arg.precent = progress * 0.5;
    }else if ([arg.key isEqualToString:@"chinSize"])
    {
        arg.precent = progress * 0.3;
    }else{
        arg.precent = progress;
    }
    
    //    arg.precent = progress;
    //设置滤镜参数；
    [_currentFilter submitParameter];
}

- (void)filterViewSwitchFilterWithCode:(NSString *)filterCode{
    //切换滤镜
    [_filterProcessor switchFilterWithCode:filterCode];
}

#pragma mark -- 贴纸栏点击代理方法 StickerViewClickDelegate

- (void)clickStickerViewWith:(TuSDKPFStickerGroup *)stickGroup {
    if (!stickGroup) {
        //为nil时 移除已有贴纸组；
        [_filterProcessor removeAllLiveSticker];
        _stickerView.hidden = YES;
        
        return;
    }
    //展示对应贴纸组；
    [_filterProcessor showGroupSticker:stickGroup];
}

#pragma mark -- TuSDKFilterProcessorDelegate

/**
 *  滤镜改变 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param processor 视频处理对象
 *  @param newFilter 新的滤镜对象
 */
- (void)onVideoProcessor:(TuSDKFilterProcessor *)processor filterChanged:(TuSDKFilterWrap *)newFilter {
    //赋值新滤镜 同事刷新新滤镜的参数配置；
    _currentFilter = newFilter;
    [_filterView refreshAdjustParameterViewWith:newFilter.code filterArgs:newFilter.filterParameter.args];
}
@end
