//
//  AVCaptureCustomToolBar.h
//  SZH_CameraDemo
//
//  Created by 智衡宋 on 2017/9/15.
//  Copyright © 2017年 智衡宋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AVCaptureCustomToolBarDelegate <NSObject>

- (void)szh_showToolsFunction:(NSInteger)number;

@end

@interface AVCaptureCustomToolBar : UIView

@property (nonatomic,weak)id<AVCaptureCustomToolBarDelegate>delegate;

@end
