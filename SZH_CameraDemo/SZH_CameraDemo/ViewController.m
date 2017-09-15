//
//  ViewController.m
//  SZH_CameraDemo
//
//  Created by 智衡宋 on 2017/9/14.
//  Copyright © 2017年 智衡宋. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AVCaptureCustomPreview.h"
@interface ViewController ()<AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate>

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
    
}





#pragma mark ----------- 程序加载

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self szh_createCamera];
}

#pragma mark ----------- 创建相机

- (void)szh_createCamera {
    
    [self szh_setCaptureSession];
    [self szh_setupCaptureInput];
    [self szh_setupCaptureOutput];
    [self szh_startCaptureSession];
}


#pragma mark ----------- 创建捕捉预览

- (void)szh_setCopturePreviewLayer:(AVCaptureSession *)session {
    
    AVCaptureCustomPreview *preview  = [[AVCaptureCustomPreview alloc]initWithFrame:self.view.bounds AVCaptureSession:session];
    [self.view addSubview:preview];
    
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


#pragma mark ----------- 



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
