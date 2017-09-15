//
//  ViewController.m
//  SZH_CameraDemo
//
//  Created by 智衡宋 on 2017/9/14.
//  Copyright © 2017年 智衡宋. All rights reserved.
//
#define ISIOS9 __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AVCaptureCustomPreview.h"
#import <GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <CoreMedia/CMMetadata.h>
@interface ViewController ()<AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate,AVCaptureCustomPreviewDelegate>

@end

@implementation ViewController {
    
    //捕捉会话
    AVCaptureSession            *_captureSession;
    //输入
    AVCaptureDeviceInput        *_videoInput;
    AVCaptureDeviceInput        *_audioInput;
    //捕捉链接
    AVCaptureConnection         *_videoConnection;
    AVCaptureConnection         *_audioConnection;
    //输出
    AVCaptureStillImageOutput   *_imageOutput;
    AVCaptureAudioDataOutput    *_audioOutput;
    AVCaptureVideoDataOutput    * _videoOutput;
    
    
    BOOL                        _orShooting;
    //录制的文件
    NSURL				        *_movieURL;
    AVAssetWriter             *_assetWriter;
    AVAssetWriterInput	      *_assetAudioInput;
    AVAssetWriterInput        *_assetVideoInput;
    
    dispatch_queue_t           _movieWritingQueue;
    
}





#pragma mark ----------- 程序加载

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self szh_createCamera];
}

#pragma mark ----------- 创建相机

- (void)szh_createCamera {
    
    
    [self szh_setupSomeInit];
    [self szh_setCaptureSession];
    [self szh_setupCaptureInput];
    [self szh_setupCaptureOutput];
    [self szh_startCaptureSession];
    
}

#pragma mark ----------- 初始化一些设置

- (void)szh_setupSomeInit {
    
    _movieURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"movie.mov"]];
}

#pragma mark ----------- 创建捕捉预览

- (void)szh_setCopturePreviewLayer:(AVCaptureSession *)session {
    
    AVCaptureCustomPreview *preview  = [[AVCaptureCustomPreview alloc]initWithFrame:self.view.bounds AVCaptureSession:session];
    preview.delegate = self;
    [self.view addSubview:preview];
    
}

#pragma mark ----------- 预览照相代理

- (void)szh_changeFunctions:(NSInteger)number {
    
    switch (number) {
        case 2:
            [self szh_switchCameras];
            break;
        case 3:
            [self szh_takePhotos];
            break;
        case 4:
            [self szh_shootingPictures];
            break;
        default:
            break;
    }
    
}

#pragma mark ----------- 使用照相各种功能

//切换摄像头
- (void)szh_switchCameras {
    
    NSArray *inputs =_captureSession.inputs;
    for (AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera =nil;
            _videoInput =nil;
            
            if (position ==AVCaptureDevicePositionFront)
                newCamera = [self szh_cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self szh_cameraWithPosition:AVCaptureDevicePositionFront];
            _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [_captureSession beginConfiguration];
            
            [_captureSession removeInput:input];
            [_captureSession addInput:_videoInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [_captureSession commitConfiguration];
            break;
        }
    }
}

- (AVCaptureDevice *)szh_cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

//拍照
- (void)szh_takePhotos {
    AVCaptureConnection *connection = [_imageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (connection.isVideoOrientationSupported) {
        connection.videoOrientation = [self currentVideoOrientation];
    }
    
    [_imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer) {
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc]initWithData:imageData];
            
            NSLog(@"是否存入相册 -------- %@",image);
        }
        
        
    }];
    
}

// 调整设备取向
- (AVCaptureVideoOrientation)currentVideoOrientation{
    AVCaptureVideoOrientation orientation;
    switch (AVCaptureVideoOrientationPortrait) {
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    return orientation;
}

//摄像
- (void)szh_shootingPictures {
    
    _orShooting = !_orShooting;
    if (_orShooting) {
        [self szh_startShooting];
    } else {
        [self szh_stopShooting];
    }

}

//开始录制
- (void)szh_startShooting {
    
 
    
}

//停止录制
- (void)szh_stopShooting {
    
    
  
    
    
}

// 保存视频
- (void)szh_saveMovieToCameraRoll
{
   
    if (ISIOS9) {
        [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
            if (status != PHAuthorizationStatusAuthorized) return ;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCreationRequest *videoRequest = [PHAssetCreationRequest creationRequestForAsset];
                [videoRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:_movieURL options:nil];
            } completionHandler:^( BOOL success, NSError * _Nullable error ) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                   
                });
              
            }];
        }];
    }
    else{
        ALAssetsLibrary *lab = [[ALAssetsLibrary alloc]init];
        [lab writeVideoAtPathToSavedPhotosAlbum:_movieURL completionBlock:^(NSURL *assetURL, NSError *error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
               
            });
            
        }];
    }
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
    if (_orShooting) {
        NSLog(@"录制中。。。。。");
    }

}



- (void)writeSampleBuffer:(CMSampleBufferRef)sampleBuffer ofType:(NSString *)mediaType
{
    
    

}

#pragma mark - configer
// 配置音频源数据写入
- (BOOL)setupAssetWriterAudioInput:(CMFormatDescriptionRef)currentFormatDescription
{
    
    return YES;
}

// 配置视频源数据写入
- (BOOL)setupAssetWriterVideoInput:(CMFormatDescriptionRef)currentFormatDescription
{
    
    return YES;
}




// 移除文件
- (void)removeFile:(NSURL *)fileURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = fileURL.path;
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (!success){
//            [self showError:error];
        }
        else{
            NSLog(@"删除视频文件成功");
        }
    }
}



#pragma mark ----------- 辅助功能代理

- (void)szh_changeToolsFunctions:(NSInteger)number {
    
    switch (number) {
        case 1:
            [self szh_fillInLight];
            break;
        case 2:
            [self szh_openFlashlight];
            break;
        case 3:
            [self szh_turnOnAutoExposureAndFocus];
            break;
        default:
            break;
    }
    
}

#pragma mark ----------- 使用各种辅助功能

//补光
- (void)szh_fillInLight {
    
   [self changeTorch:[self torchMode] == AVCaptureTorchModeOn?AVCaptureTorchModeOff:AVCaptureTorchModeOn];

}

- (AVCaptureDevice *)activeCamera
{
    return _videoInput.device;
}

- (AVCaptureFlashMode)flashMode{
    return [[self activeCamera] flashMode];
}

- (BOOL)cameraHasFlash {
    return [[self activeCamera] hasFlash];
}

- (BOOL)cameraHasTorch {
    return [[self activeCamera] hasTorch];
}

- (AVCaptureTorchMode)torchMode {
    return [[self activeCamera] torchMode];
}

- (id)changeTorch:(AVCaptureTorchMode)torchMode{
    if (![self cameraHasTorch]) {
        NSDictionary *desc = @{NSLocalizedDescriptionKey:@"不支持手电筒"};
        NSError *error = [NSError errorWithDomain:@"com.cc.camera" code:403 userInfo:desc];
        return error;
    }
    // 如果闪光灯打开，先关闭闪光灯
    if ([self flashMode] == AVCaptureFlashModeOn) {
        [self setFlashMode:AVCaptureFlashModeOff];
    }
    return [self setTorchMode:torchMode];
}

- (id)setTorchMode:(AVCaptureTorchMode)torchMode{
    AVCaptureDevice *device = [self activeCamera];
    if ([device isTorchModeSupported:torchMode]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.torchMode = torchMode;
            [device unlockForConfiguration];
        }
        return error;
    }
    return nil;
}

- (id)setFlashMode:(AVCaptureFlashMode)flashMode{
    AVCaptureDevice *device = [self activeCamera];
    if ([device isFlashModeSupported:flashMode]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.flashMode = flashMode;
            [device unlockForConfiguration];
           
        }
        return error;
    }
    return nil;
}

//闪光灯
- (void)szh_openFlashlight {
    
    [self changeFlash:[self flashMode] == AVCaptureFlashModeOn?AVCaptureFlashModeOff:AVCaptureFlashModeOn];
}

- (id)changeFlash:(AVCaptureFlashMode)flashMode{
    if (![self cameraHasFlash]) {
        NSDictionary *desc = @{NSLocalizedDescriptionKey:@"不支持闪光灯"};
        NSError *error = [NSError errorWithDomain:@"com.cc.camera" code:401 userInfo:desc];
        return error;
    }
    // 如果手电筒打开，先关闭手电筒
    if ([self torchMode] == AVCaptureTorchModeOn) {
        [self setTorchMode:AVCaptureTorchModeOff];
    }
    return [self setFlashMode:flashMode];
}

//自动聚焦、曝光
- (void)szh_turnOnAutoExposureAndFocus {
    
    [self resetFocusAndExposureModes];
}

- (id)resetFocusAndExposureModes
{
    AVCaptureDevice *device = [self activeCamera];
    AVCaptureExposureMode exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    AVCaptureFocusMode focusMode = AVCaptureFocusModeContinuousAutoFocus;
    BOOL canResetFocus = [device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode];
    BOOL canResetExposure = [device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode];
    CGPoint centerPoint = CGPointMake(0.5f, 0.5f);
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        if (canResetFocus) {
            device.focusMode = focusMode;
            device.focusPointOfInterest = centerPoint;
        }
        if (canResetExposure) {
            device.exposureMode = exposureMode;
            device.exposurePointOfInterest = centerPoint;
        }
        [device unlockForConfiguration];
    }
    return error;
}

#pragma mark ----------- 创建捕捉会话

- (void)szh_setCaptureSession {
    _captureSession = [[AVCaptureSession alloc]init];
    [_captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    [self szh_setCopturePreviewLayer:_captureSession];
}

#pragma mark ----------- 开启捕捉会话

- (void)szh_startCaptureSession {
    if (!_captureSession.isRunning) {
        [_captureSession startRunning];
    }
}

#pragma mark ----------- 关闭捕捉会话

- (void)szh_stopCaptureSession {
    if (_captureSession.isRunning) {
        [_captureSession stopRunning];
    }
}

#pragma mark ----------- 创建捕捉输入

- (void)szh_setupCaptureInput {
    AVCaptureDevice *vedioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error1;
    _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:vedioDevice error:&error1];
    if (_videoInput) {
        if ([_captureSession canAddInput:_videoInput]) {
            [_captureSession addInput:_videoInput];
        }
    }
    
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error2;
    _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error2];
    if (_audioInput) {
        if ([_captureSession canAddInput:_audioInput]) {
            [_captureSession addInput:_audioInput];
        }
    }
}

#pragma mark ----------- 创建捕捉输出

- (void)szh_setupCaptureOutput {
    
    dispatch_queue_t captureQueue = dispatch_queue_create("com.cc.MovieCaptureQueue", DISPATCH_QUEUE_SERIAL);
    
    
    //视频输出
    _videoOutput = [[AVCaptureVideoDataOutput alloc]init];
    [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    [_videoOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]}];
    [_videoOutput setSampleBufferDelegate:self queue:captureQueue];
    if ([_captureSession canAddOutput:_videoOutput]) {
        [_captureSession addOutput:_videoOutput];
    }
    
    //视频链接
    _videoConnection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
    _videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    
    
    //音频输出
    _audioOutput = [[AVCaptureAudioDataOutput alloc]init];
    [_audioOutput setSampleBufferDelegate:self queue:captureQueue];
    if ([_captureSession canAddOutput:_audioOutput]) {
        [_captureSession addOutput:_audioOutput];
    }
    //音频链接
    _audioConnection = [_audioOutput connectionWithMediaType:AVMediaTypeAudio];
    
    
    
    
    //图片输出
    _imageOutput = [[AVCaptureStillImageOutput alloc]init];
    _imageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    if ([_captureSession canAddOutput:_imageOutput]) {
        [_captureSession addOutput:_imageOutput];
    }
    
}

#pragma mark -----------  内存警告

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
