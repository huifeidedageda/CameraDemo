//
//  AVCaptureCustomPreview.m
//  SZH_CameraDemo
//
//  Created by 智衡宋 on 2017/9/15.
//  Copyright © 2017年 智衡宋. All rights reserved.
//

#import "AVCaptureCustomPreview.h"


@implementation AVCaptureCustomPreview {
    
    AVCaptureVideoPreviewLayer   *_previewLayer;
    
}


- (instancetype)initWithFrame:(CGRect)frame AVCaptureSession:(AVCaptureSession *)session {
    self = [super initWithFrame:frame];
    if (self) {
        [self szh_setupAVCaptureSession:session];
    }
    return self;
}


#pragma mark ------------- 创建UI

- (void)szh_setupUI {
    
    
    
    
}

#pragma mark ------------- 创建捕捉预览

- (void)szh_setupAVCaptureSession:(AVCaptureSession *)session {
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    _previewLayer.frame = self.bounds;
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.layer addSublayer:_previewLayer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
