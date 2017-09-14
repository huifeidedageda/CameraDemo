//
//  ViewController.m
//  SZH_CameraDemo
//
//  Created by 智衡宋 on 2017/9/14.
//  Copyright © 2017年 智衡宋. All rights reserved.
//

#import "ViewController.h"


#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController {
    
    //捕捉会话
    AVCaptureSession            *_captureSession;
    //输入
    AVCaptureDeviceInput        *_videoInput;
    AVCaptureDeviceInput        *_audioInput;
    //捕捉预览
    AVCaptureVideoPreviewLayer  *_previewLayer;
    //捕捉链接
    AVCaptureConnection         *_videoConnection;
    AVCaptureConnection         *_audioConnection;
    //输出
    AVCaptureStillImageOutput   *_imageOutput;
    AVCaptureAudioDataOutput    *_audioOut;
    AVCaptureVideoDataOutput    * _videoOut;
    
}





#pragma mark -----------

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark ----------- 创建捕捉预览

- (void)szh_setCopturePreviewLayer {
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
    
}

#pragma mark ----------- 创建捕捉会话

- (void)szh_setCaptureSession {
    _captureSession = [[AVCaptureSession alloc]init];
    [_captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
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
    
}

#pragma mark ----------- 创建捕捉输出

- (void)szh_setupCaptureOutput {
    
    
}

#pragma mark -----------


#pragma mark -----------



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
