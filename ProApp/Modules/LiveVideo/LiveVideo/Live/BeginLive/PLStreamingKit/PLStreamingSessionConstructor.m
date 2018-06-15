//
//  PLStreamingSessionConstructor.m
//  PLStreamingKitExample
//
//  Created by TaoZeyu on 16/5/24.
//  Copyright © 2016年 pili-engineering. All rights reserved.
//

#import "PLStreamingSessionConstructor.h"

@implementation PLStreamingSessionConstructor
{
    NSURL *_streamCloudURL;
    PLMediaStreamingSession *_session;
}

- (PLMediaStreamingSession *)streamingSession
{
    [self _createStreamingSessionWithSream:nil];
    return _session;
}

- (PLMediaStreamingSession *)_createStreamingSessionWithSream:(PLStream *)stream
{
    CGSize videoSize = CGSizeMake(368 , 640);
    
    PLVideoCaptureConfiguration *videoCaptureConfiguration = [[PLVideoCaptureConfiguration alloc]initWithVideoFrameRate:24 sessionPreset:AVCaptureSessionPresetMedium previewMirrorFrontFacing:YES previewMirrorRearFacing:NO streamMirrorFrontFacing:NO streamMirrorRearFacing:NO cameraPosition:AVCaptureDevicePositionFront videoOrientation:AVCaptureVideoOrientationPortrait];
    PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
    PLVideoStreamingConfiguration *videoStreamConfiguration = [[PLVideoStreamingConfiguration alloc] initWithVideoSize:videoSize expectedSourceVideoFrameRate:24 videoMaxKeyframeInterval:72 averageVideoBitRate:768 * 1024 videoProfileLevel:AVVideoProfileLevelH264HighAutoLevel];
    PLAudioStreamingConfiguration *audioSreamConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
    _session = [[PLMediaStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration
                                                     audioCaptureConfiguration:audioCaptureConfiguration
                                                   videoStreamingConfiguration:videoStreamConfiguration
                                                   audioStreamingConfiguration:audioSreamConfiguration
                                                                        stream:stream];
    return _session;
}

@end
