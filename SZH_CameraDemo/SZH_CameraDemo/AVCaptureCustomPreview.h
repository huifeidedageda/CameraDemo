//
//  AVCaptureCustomPreview.h
//  SZH_CameraDemo
//
//  Created by 智衡宋 on 2017/9/15.
//  Copyright © 2017年 智衡宋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface AVCaptureCustomPreview : UIView

- (instancetype)initWithFrame:(CGRect)frame AVCaptureSession:(AVCaptureSession *)session;

@end
