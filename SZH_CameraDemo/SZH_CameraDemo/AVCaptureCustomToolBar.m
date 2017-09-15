//
//  AVCaptureCustomToolBar.m
//  SZH_CameraDemo
//
//  Created by 智衡宋 on 2017/9/15.
//  Copyright © 2017年 智衡宋. All rights reserved.
//

#import "AVCaptureCustomToolBar.h"
#import <Masonry.h>

@interface AVCaptureCustomToolBar ()
//辅助功能
@property (nonatomic,strong) UIButton  *oneButton;
//切换摄像头
@property (nonatomic,strong) UIButton  *twoButton;
//切换照相
@property (nonatomic,strong) UIButton  *threeButton;
@end


@implementation AVCaptureCustomToolBar

#pragma mark ------------- 初始化

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self szh_setupUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self szh_setupUI];
    }
    return self;
}

#pragma mark ------------- 创建UI

- (void)szh_setupUI {
    
    
    [self addSubview:self.oneButton];
    [self addSubview:self.twoButton];
    [self addSubview:self.threeButton];
    
    
    [_oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(5);
        make.width.equalTo(_twoButton.mas_width);
        make.height.mas_equalTo(30);
    }];
    
    [_twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_oneButton.mas_right).offset(20);
        make.right.equalTo(_threeButton.mas_left).offset(-20);
        make.top.equalTo(_oneButton.mas_top);
        make.width.equalTo(_threeButton.mas_width);
        make.height.mas_equalTo(30);
    }];
    
    [_threeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(_twoButton.mas_top);
        make.width.equalTo(_oneButton.mas_width);
        make.height.mas_equalTo(30);
    }];
    
    
}

#pragma mark ------------- 懒加载

- (UIButton *)oneButton {
    if (!_oneButton) {
        _oneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _oneButton.backgroundColor = [UIColor redColor];
        _oneButton.tag = 1000001;
        [_oneButton addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneButton;
}

- (UIButton *)twoButton {
    if (!_twoButton) {
        _twoButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _twoButton.backgroundColor = [UIColor redColor];
        _twoButton.tag = 1000002;
        [_twoButton addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _twoButton;
}

- (UIButton *)threeButton {
    if (!_threeButton) {
        _threeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _threeButton.backgroundColor = [UIColor redColor];
        _threeButton.tag = 1000003;
        [_threeButton addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _threeButton;
}


#pragma mark ------------- 


- (void)touchAction:(UIButton *)button {
    
    switch (button.tag) {
       
        case 1000001:
            if (_delegate&& [_delegate respondsToSelector:@selector(szh_showToolsFunction:)]) {
                [_delegate szh_showToolsFunction:1];
            }
            
            break;
        case 1000002:
            if (_delegate&& [_delegate respondsToSelector:@selector(szh_showToolsFunction:)]) {
                [_delegate szh_showToolsFunction:2];
            }
            break;
        case 1000003:
            if (_delegate&& [_delegate respondsToSelector:@selector(szh_showToolsFunction:)]) {
                [_delegate szh_showToolsFunction:3];
            }
            break;
        default:
            break;
    }
    
    
}

#pragma mark ------------- 




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
