//
//  AVCaptureCustomPreview.m
//  SZH_CameraDemo
//
//  Created by 智衡宋 on 2017/9/15.
//  Copyright © 2017年 智衡宋. All rights reserved.
//

#import "AVCaptureCustomPreview.h"
#import <Masonry.h>
#import "AVCaptureCustomToolBar.h"
#import <GPUImage.h>
@interface AVCaptureCustomPreview ()<AVCaptureCustomToolBarDelegate>
//辅助功能
@property (nonatomic,strong) UIButton  *toolsButton;
//切换摄像头
@property (nonatomic,strong) UIButton  *changeDerection;
//切换照相
@property (nonatomic,strong) UIButton  *takePicturesButton;
//切换摄像
@property (nonatomic,strong) UIButton  *cameraShootingButton;
// 聚焦动画view
@property(nonatomic, strong) UIView *focusView;

@end


@implementation AVCaptureCustomPreview {
    
    AVCaptureVideoPreviewLayer   *_previewLayer;
    AVCaptureCustomToolBar       *_toolbar;
    UITapGestureRecognizer       *_tapAction;
}

#pragma mark ------------- 初始化

- (instancetype)initWithFrame:(CGRect)frame AVCaptureSession:(AVCaptureSession *)session {
    self = [super initWithFrame:frame];
    if (self) {
        [self szh_setupAVCaptureSession:session];
        [self szh_setupUI];
        [self szh_addTapGesture];
    }
    return self;
}

#pragma mark ------------- 添加点击手势

- (void)szh_addTapGesture {
    self.userInteractionEnabled = YES;
    _tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAciton:)];
    [self addGestureRecognizer:_tapAction];
}

- (void)tapAciton:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:self];
    [self runFocusAnimation:self.focusView point:point];
    
}

-(UIView *)focusView{
    if (_focusView == nil) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150, 150.0f)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.layer.borderColor = [UIColor blueColor].CGColor;
        _focusView.layer.borderWidth = 5.0f;
        _focusView.hidden = YES;
    }
    return _focusView;
}

// 聚焦、曝光动画
-(void)runFocusAnimation:(UIView *)view point:(CGPoint)point{
    view.center = point;
    view.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
        
    }completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            view.hidden = YES;
            view.transform = CGAffineTransformIdentity;
        });
    }];
}

#pragma mark ------------- 创建UI

- (void)szh_setupUI {
    
    
    [self addSubview:self.focusView];
    [self addSubview:self.toolsButton];
    [self addSubview:self.changeDerection];
    [self addSubview:self.takePicturesButton];
    [self addSubview:self.cameraShootingButton];
    
    [_toolsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(30);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [_changeDerection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(_toolsButton);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [_takePicturesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    [_cameraShootingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.bottom.equalTo(_takePicturesButton);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
}

#pragma mark ------------- 懒加载

- (UIButton *)toolsButton {
    if (!_toolsButton) {
        _toolsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _toolsButton.backgroundColor = [UIColor redColor];
        _toolsButton.tag = 100001;
        [_toolsButton addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolsButton;
}

- (UIButton *)changeDerection {
    if (!_changeDerection) {
        _changeDerection = [UIButton buttonWithType:UIButtonTypeSystem];
        _changeDerection.backgroundColor = [UIColor redColor];
        _changeDerection.tag = 100002;
        [_changeDerection addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeDerection;
}

- (UIButton *)takePicturesButton {
    if (!_takePicturesButton) {
        _takePicturesButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _takePicturesButton.backgroundColor = [UIColor redColor];
        _takePicturesButton.tag = 100003;
        [_takePicturesButton addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePicturesButton;
}

- (UIButton *)cameraShootingButton {
    if (!_cameraShootingButton) {
        _cameraShootingButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cameraShootingButton.backgroundColor = [UIColor redColor];
        _cameraShootingButton.tag = 100004;
        [_cameraShootingButton addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraShootingButton;
}


#pragma mark ------------- 按钮监听

- (void)touchAction:(UIButton *)button {
    
    switch (button.tag) {
        case 100001:
            [self szh_showToolBar];
            break;
        case 100002:
            if (_delegate&& [_delegate respondsToSelector:@selector(szh_changeFunctions:)]) {
                [_delegate szh_changeFunctions:2];
            }
            
            break;
        case 100003:
            if (_delegate&& [_delegate respondsToSelector:@selector(szh_changeFunctions:)]) {
                [_delegate szh_changeFunctions:3];
            }
            break;
        case 100004:
            if (_delegate&& [_delegate respondsToSelector:@selector(szh_changeFunctions:)]) {
                [_delegate szh_changeFunctions:4];
            }
            break;
        default:
            break;
    }
    
    
}

#pragma mark ------------- 展示辅助工具条

- (void)szh_showToolBar {
    
    if (!_toolbar) {
        _toolbar = [[AVCaptureCustomToolBar alloc]init];
        _toolbar.delegate = self;
        [self addSubview:_toolbar];
        [_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_toolsButton.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(40);
            
        }];
    } else {
        [_toolbar removeFromSuperview];
        _toolbar = nil;
    }
    
}

- (void)szh_showToolsFunction:(NSInteger)number {
    
    switch (number) {
        case 1:
            if (_delegate&& [_delegate respondsToSelector:@selector(szh_changeToolsFunctions:)]) {
                [_delegate szh_changeToolsFunctions:1];
            }

            break;
        case 2:
            if (_delegate&& [_delegate respondsToSelector:@selector(szh_changeToolsFunctions:)]) {
                [_delegate szh_changeToolsFunctions:2];
            }
            break;
        case 3:
            if (_delegate&& [_delegate respondsToSelector:@selector(szh_changeToolsFunctions:)]) {
                [_delegate szh_changeToolsFunctions:3];
            }
            break;
            
        default:
            break;
    }
    
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
