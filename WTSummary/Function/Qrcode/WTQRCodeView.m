//
//  WTQRCodeView.m
//  WTSummary
//
//  Created by piyingke on 17/7/1.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

/** 扫描内容的Y值 */
#define scanContent_Y (self.frame.size.height) * 0.26
/** 扫描内容的Y值 */
#define scanContent_X self.frame.size.width * 0.15

#import <AVFoundation/AVFoundation.h>
#import "WTQRCodeView.h"
@interface WTQRCodeView ()
@property (nonatomic, strong) AVCaptureDevice * device;
@property (nonatomic, strong) CALayer * tempLayer;
@property (nonatomic, strong) UIImageView * scanningline;
@property (nonatomic, strong) NSTimer * timer;
@end

@implementation WTQRCodeView
/** 扫描动画线(冲击波) 的高度 */
static CGFloat const scanninglineHeight = 2;
/** 扫描内容外部View的alpha值 */
static CGFloat const scanBorderOutsideViewAlpha = 0.4;

- (CALayer *)tempLayer {
    if (!_tempLayer) {
        _tempLayer = [[CALayer alloc] init];
    }
    return _tempLayer;
}

- (instancetype)initWithFrame:(CGRect)frame layer:(CALayer *)layer {
    if (self = [super initWithFrame:frame]) {
        self.tempLayer = layer;
        // 布局扫描界面
        [self setupSubviews];
        
    }
    return self;
}

+ (instancetype)scanningViewWithFrame:(CGRect )frame layer:(CALayer *)layer {
    return [[self alloc] initWithFrame:frame layer:layer];
}

- (void)setupSubviews {
    
    // 扫描内容的创建
    CALayer *scanContent_layer = [[CALayer alloc] init];
    CGFloat scanContent_layerX = scanContent_X;
    CGFloat scanContent_layerY = scanContent_Y;
    CGFloat scanContent_layerW = self.frame.size.width - 2 * scanContent_X;
    CGFloat scanContent_layerH = scanContent_layerW;
    scanContent_layer.frame = CGRectMake(scanContent_layerX, scanContent_layerY, scanContent_layerW, scanContent_layerH);
    scanContent_layer.borderColor = [UIColor whiteColor].CGColor;
    scanContent_layer.borderWidth = 0.7;
    scanContent_layer.backgroundColor = [UIColor clearColor].CGColor;
    [self.tempLayer addSublayer:scanContent_layer];
    
#pragma mark - - - 扫描外部View的创建
    // 顶部layer的创建
    CALayer *top_layer = [[CALayer alloc] init];
    CGFloat top_layerX = 0;
    CGFloat top_layerY = 0;
    CGFloat top_layerW = self.frame.size.width;
    CGFloat top_layerH = scanContent_layerY;
    top_layer.frame = CGRectMake(top_layerX, top_layerY, top_layerW, top_layerH);
    top_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha].CGColor;
    [self.layer addSublayer:top_layer];
    
    // 左侧layer的创建
    CALayer *left_layer = [[CALayer alloc] init];
    CGFloat left_layerX = 0;
    CGFloat left_layerY = scanContent_layerY;
    CGFloat left_layerW = scanContent_X;
    CGFloat left_layerH = scanContent_layerH;
    left_layer.frame = CGRectMake(left_layerX, left_layerY, left_layerW, left_layerH);
    left_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha].CGColor;
    [self.layer addSublayer:left_layer];
    
    // 右侧layer的创建
    CALayer *right_layer = [[CALayer alloc] init];
    CGFloat right_layerX = CGRectGetMaxX(scanContent_layer.frame);
    CGFloat right_layerY = scanContent_layerY;
    CGFloat right_layerW = scanContent_X;
    CGFloat right_layerH = scanContent_layerH;
    right_layer.frame = CGRectMake(right_layerX, right_layerY, right_layerW, right_layerH);
    right_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha].CGColor;
    [self.layer addSublayer:right_layer];
    
    // 下面layer的创建
    CALayer *bottom_layer = [[CALayer alloc] init];
    CGFloat bottom_layerX = 0;
    CGFloat bottom_layerY = CGRectGetMaxY(scanContent_layer.frame);
    CGFloat bottom_layerW = self.frame.size.width;
    CGFloat bottom_layerH = self.frame.size.height - bottom_layerY;
    bottom_layer.frame = CGRectMake(bottom_layerX, bottom_layerY, bottom_layerW, bottom_layerH);
    bottom_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha].CGColor;
    [self.layer addSublayer:bottom_layer];
    
    // 提示Label
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.backgroundColor = [UIColor clearColor];
    CGFloat promptLabelX = 0;
    CGFloat promptLabelY = CGRectGetMaxY(scanContent_layer.frame) + 30;
    CGFloat promptLabelW = self.frame.size.width;
    CGFloat promptLabelH = 25;
    promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
    promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    promptLabel.text = @"将二维码放入框内, 即可自动扫描";
    promptLabel.numberOfLines = 0;
    [self addSubview:promptLabel];
    
    // 添加闪光灯按钮
    UIButton *light_button = [[UIButton alloc] init];
    CGFloat light_buttonX = 0;
    CGFloat light_buttonY = CGRectGetMaxY(promptLabel.frame) + scanContent_X * 0.5;
    CGFloat light_buttonW = self.frame.size.width;
    CGFloat light_buttonH = 25;
    light_button.frame = CGRectMake(light_buttonX, light_buttonY, light_buttonW, light_buttonH);
    [light_button setTitle:@"打开照明灯" forState:UIControlStateNormal];
    [light_button setTitle:@"关闭照明灯" forState:UIControlStateSelected];
    [light_button setTitleColor:promptLabel.textColor forState:(UIControlStateNormal)];
    light_button.titleLabel.font = [UIFont systemFontOfSize:17];

    [light_button addTarget:self action:@selector(light_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:light_button];
    
#pragma mark - - - 扫描边角imageView的创建
    // 左上侧的image
    UIImage *left_image = [UIImage imageNamed:@"home_share_code_corner1"];
    UIImageView *left_imageView = [[UIImageView alloc] init];
    CGFloat left_imageViewX = scanContent_layerX;
    CGFloat left_imageViewY = scanContent_layerY;
    CGFloat left_imageViewW = 15;
    CGFloat left_imageViewH = left_imageViewW;
    left_imageView.frame = CGRectMake(left_imageViewX, left_imageViewY, left_imageViewW,left_imageViewH);
    left_imageView.image = left_image;
    [self.tempLayer addSublayer:left_imageView.layer];
    
    // 右上侧的image
    UIImage *right_image = [UIImage imageNamed:@"home_share_code_corner2"];
    UIImageView *right_imageView = [[UIImageView alloc] init];
    CGFloat right_imageViewX = CGRectGetMaxX(scanContent_layer.frame) - left_imageViewW;
    CGFloat right_imageViewY = left_imageView.frame.origin.y;
    right_imageView.frame = CGRectMake(right_imageViewX, right_imageViewY, left_imageViewW, left_imageViewW);
    right_imageView.image = right_image;
    [self.tempLayer addSublayer:right_imageView.layer];
    
    // 左下侧的image
    UIImage *left_image_down = [UIImage imageNamed:@"home_share_code_corner3"];
    UIImageView *left_imageView_down = [[UIImageView alloc] init];
    CGFloat left_imageView_downX = left_imageView.frame.origin.x;
    CGFloat left_imageView_downY = CGRectGetMaxY(scanContent_layer.frame) - left_imageViewW;
    left_imageView_down.frame = CGRectMake(left_imageView_downX, left_imageView_downY, left_imageViewW, left_imageViewW);
    left_imageView_down.image = left_image_down;
    [self.tempLayer addSublayer:left_imageView_down.layer];
    
    // 右下侧的image
    UIImage *right_image_down = [UIImage imageNamed:@"home_share_code_corner4"];
    UIImageView *right_imageView_down = [[UIImageView alloc] init];
    CGFloat right_imageView_downX = right_imageView.frame.origin.x;
    CGFloat right_imageView_downY = left_imageView_down.frame.origin.y;
    right_imageView_down.frame = CGRectMake(right_imageView_downX, right_imageView_downY, left_imageViewW, left_imageViewW);
    right_imageView_down.image = right_image_down;
    [self.tempLayer addSublayer:right_imageView_down.layer];
}

#pragma mark - - - 照明灯的点击事件
- (void)light_buttonAction:(UIButton *)button {
    if (button.selected == NO) { // 点击打开照明灯
        [self turnOnLight:YES];
        button.selected = YES;
    } else { // 点击关闭照明灯
        [self turnOnLight:NO];
        button.selected = NO;
    }
}
- (void)turnOnLight:(BOOL)on {
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([_device hasTorch]) {
        [_device lockForConfiguration:nil];
        if (on) {
            [_device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [_device setTorchMode: AVCaptureTorchModeOff];
        }
        [_device unlockForConfiguration];
    }
}

- (UIImageView *)scanningline {
    if (!_scanningline) {
        _scanningline = [[UIImageView alloc] init];
        _scanningline.image = [UIImage imageNamed:@"home_share_code_line@2x"];
        _scanningline.frame = CGRectMake(scanContent_X, scanContent_Y, self.frame.size.width - scanContent_X * 2 , scanninglineHeight);
    }
    return _scanningline;
}

- (void)addScanningline {
    // 扫描动画添加
    [self.tempLayer addSublayer:self.scanningline.layer];
}
#pragma mark - - - 添加定时器
- (void)addTimer {
    [self addScanningline];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
#pragma mark - - - 移除定时器
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
    [self.scanningline removeFromSuperview];
    self.scanningline = nil;
}

#pragma mark - - - 执行定时器方法
- (void)timeAction {
    __block CGRect frame = _scanningline.frame;
    
    static BOOL flag = YES;
    
    if (flag) {
        frame.origin.y = scanContent_Y;
        flag = NO;
        [UIView animateWithDuration:0.05 animations:^{
            frame.origin.y += 5;
            _scanningline.frame = frame;
        } completion:nil];
    } else {
        if (_scanningline.frame.origin.y >= scanContent_Y) {
            CGFloat scanContent_MaxY = scanContent_Y + self.frame.size.width - 2 * scanContent_X;
            if (_scanningline.frame.origin.y >= scanContent_MaxY - 10) {
                frame.origin.y = scanContent_Y;
                _scanningline.frame = frame;
                flag = YES;
            } else {
                [UIView animateWithDuration:0.05 animations:^{
                    frame.origin.y += 5;
                    _scanningline.frame = frame;
                } completion:nil];
            }
        } else {
            flag = !flag;
        }
    }
}

@end
