//
//  WTQRCodeView.m
//  WTSummary
//
//  Created by piyingke on 17/7/1.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

/**扫描内容的X值 */
#define scanContent_X self.frame.size.width*0.15
/**扫描内容的width */
#define scanContent_Width self.frame.size.width*0.70
/**扫描内容的Y值 */
#define scanContent_Y (self.frame.size.height - scanContent_Width)*0.5
#import "WTQRCodeView.h"
#import <AVFoundation/AVFoundation.h>

@interface WTQRCodeView ()
@property (nonatomic, strong) UIImageView *scanningline;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation WTQRCodeView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initialization];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)initialization{
    self.backgroundColor = [UIColor clearColor];
    self.cornerLocation = CornerLocationDefault;
    self.borderColor = [UIColor whiteColor];
    self.cornerColor = [UIColor colorWithRed:150/255.0 green:169/255.0 blue:246/255.0 alpha:1.0];
    self.cornerWidth = 2.0;
    self.backgroundAlpha = 0.5;
    self.animationTimeInterval = 0.05;
    self.describe = @"将二维码放入框内, 即可自动扫描";
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGFloat scanContentW = scanContent_Width;
    CGFloat scanContentH = scanContentW;
    CGFloat scanContentX = scanContent_X;
    CGFloat scanContentY = scanContent_Y;
    CGFloat scanBorderLineW = 0.5;
    
    // 背景颜色
    [[[UIColor blackColor] colorWithAlphaComponent:self.backgroundAlpha] setFill];
    UIRectFill(rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
    // 绘制扫描区域
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(scanContentX + 0.5 *scanBorderLineW, scanContentY + 0.5 *scanBorderLineW, scanContentW - scanBorderLineW, scanContentH - scanBorderLineW)];
    [bezierPath fill];
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    // 扫描边框
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(scanContentX, scanContentY, scanContentW, scanContentH)];
    borderPath.lineCapStyle = kCGLineCapButt;
    borderPath.lineWidth = scanBorderLineW;
    [self.borderColor set];
    [borderPath stroke];
    
    // 边框长度
    CGFloat cornerLength = 20;
    // 左上边角
    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    leftTopPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    CGFloat insideExcess = fabs(0.5 *(self.cornerWidth - scanBorderLineW));
    CGFloat outsideExcess = 0.5 *(scanBorderLineW + self.cornerWidth);
    if (self.cornerLocation == CornerLocationInside) {
        [leftTopPath moveToPoint:CGPointMake(scanContentX + insideExcess, scanContentY + cornerLength + insideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(scanContentX + insideExcess, scanContentY + insideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(scanContentX + cornerLength + insideExcess, scanContentY + insideExcess)];
    } else if (self.cornerLocation == CornerLocationOutside) {
        [leftTopPath moveToPoint:CGPointMake(scanContentX - outsideExcess, scanContentY + cornerLength - outsideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(scanContentX - outsideExcess, scanContentY - outsideExcess)];
        [leftTopPath addLineToPoint:CGPointMake(scanContentX + cornerLength - outsideExcess, scanContentY - outsideExcess)];
    } else {
        [leftTopPath moveToPoint:CGPointMake(scanContentX, scanContentY + cornerLength)];
        [leftTopPath addLineToPoint:CGPointMake(scanContentX, scanContentY)];
        [leftTopPath addLineToPoint:CGPointMake(scanContentX + cornerLength, scanContentY)];
    }
    
    [leftTopPath stroke];
    
    // 左下边角
    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    leftBottomPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLocationInside) {
        [leftBottomPath moveToPoint:CGPointMake(scanContentX + cornerLength + insideExcess, scanContentY + scanContentH - insideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(scanContentX + insideExcess, scanContentY + scanContentH - insideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(scanContentX + insideExcess, scanContentY + scanContentH - cornerLength - insideExcess)];
    } else if (self.cornerLocation == CornerLocationOutside) {
        [leftBottomPath moveToPoint:CGPointMake(scanContentX + cornerLength - outsideExcess, scanContentY + scanContentH + outsideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(scanContentX - outsideExcess, scanContentY + scanContentH + outsideExcess)];
        [leftBottomPath addLineToPoint:CGPointMake(scanContentX - outsideExcess, scanContentY + scanContentH - cornerLength + outsideExcess)];
    } else {
        [leftBottomPath moveToPoint:CGPointMake(scanContentX + cornerLength, scanContentY + scanContentH)];
        [leftBottomPath addLineToPoint:CGPointMake(scanContentX, scanContentY + scanContentH)];
        [leftBottomPath addLineToPoint:CGPointMake(scanContentX, scanContentY + scanContentH - cornerLength)];
    }
    
    [leftBottomPath stroke];
    
    // 右上边角
    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    rightTopPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLocationInside) {
        [rightTopPath moveToPoint:CGPointMake(scanContentX + scanContentW - cornerLength - insideExcess, scanContentY + insideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(scanContentX + scanContentW - insideExcess, scanContentY + insideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(scanContentX + scanContentW - insideExcess, scanContentY + cornerLength + insideExcess)];
    } else if (self.cornerLocation == CornerLocationOutside) {
        [rightTopPath moveToPoint:CGPointMake(scanContentX + scanContentW - cornerLength + outsideExcess, scanContentY - outsideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(scanContentX + scanContentW + outsideExcess, scanContentY - outsideExcess)];
        [rightTopPath addLineToPoint:CGPointMake(scanContentX + scanContentW + outsideExcess, scanContentY + cornerLength - outsideExcess)];
    } else {
        [rightTopPath moveToPoint:CGPointMake(scanContentX + scanContentW - cornerLength, scanContentY)];
        [rightTopPath addLineToPoint:CGPointMake(scanContentX + scanContentW, scanContentY)];
        [rightTopPath addLineToPoint:CGPointMake(scanContentX + scanContentW, scanContentY + cornerLength)];
    }
    
    [rightTopPath stroke];
    
    // 右下边角
    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    rightBottomPath.lineWidth = self.cornerWidth;
    [self.cornerColor set];
    
    if (self.cornerLocation == CornerLocationInside) {
        [rightBottomPath moveToPoint:CGPointMake(scanContentX + scanContentW - insideExcess, scanContentY + scanContentH - cornerLength - insideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(scanContentX + scanContentW - insideExcess, scanContentY + scanContentH - insideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(scanContentX + scanContentW - cornerLength - insideExcess, scanContentY + scanContentH - insideExcess)];
    } else if (self.cornerLocation == CornerLocationOutside) {
        [rightBottomPath moveToPoint:CGPointMake(scanContentX + scanContentW + outsideExcess, scanContentY + scanContentH - cornerLength + outsideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(scanContentX + scanContentW + outsideExcess, scanContentY + scanContentH + outsideExcess)];
        [rightBottomPath addLineToPoint:CGPointMake(scanContentX + scanContentW - cornerLength + outsideExcess, scanContentY + scanContentH + outsideExcess)];
    } else {
        [rightBottomPath moveToPoint:CGPointMake(scanContentX + scanContentW, scanContentY + scanContentH - cornerLength)];
        [rightBottomPath addLineToPoint:CGPointMake(scanContentX + scanContentW, scanContentY + scanContentH)];
        [rightBottomPath addLineToPoint:CGPointMake(scanContentX + scanContentW - cornerLength, scanContentY + scanContentH)];
    }
    
    [rightBottomPath stroke];
    
    // 描述
    UILabel *describeLabel = [[UILabel alloc] init];
    describeLabel.backgroundColor = [UIColor clearColor];
    describeLabel.frame = CGRectMake(0, scanContentY + scanContentW + 20, self.frame.size.width, 25);
    describeLabel.textAlignment = NSTextAlignmentCenter;
    describeLabel.font = [UIFont boldSystemFontOfSize:13.0];
    describeLabel.textColor = [UIColor whiteColor];
    describeLabel.text = self.describe;
    describeLabel.numberOfLines = 0;
    [self addSubview:describeLabel];
    
    // 添加闪光灯按钮
    UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat lightButtonX = 0;
    CGFloat lightButtonY = CGRectGetMaxY(describeLabel.frame) + 10;
    CGFloat lightButtonW = self.frame.size.width;
    CGFloat lightButtonH = 25;
    lightButton.frame = CGRectMake(lightButtonX, lightButtonY, lightButtonW, lightButtonH);
    [lightButton setTitle:@"打开照明灯" forState:UIControlStateNormal];
    [lightButton setTitle:@"关闭照明灯" forState:UIControlStateSelected];
    [lightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    lightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [lightButton addTarget:self action:@selector(lightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lightButton];
}

- (void)lightButtonAction:(UIButton *)button {
    if (button.selected == NO) { // 点击打开照明灯
        [self turnOnLight:YES];
        button.selected = YES;
    } else { // 点击关闭照明灯
        [self turnOnLight:NO];
        button.selected = NO;
    }
}
- (void)turnOnLight:(BOOL)on {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([captureDevice hasTorch]) {
        [captureDevice lockForConfiguration:nil];
        if (on) {
            [captureDevice setTorchMode:AVCaptureTorchModeOn];
        } else {
            [captureDevice setTorchMode:AVCaptureTorchModeOff];
        }
        [captureDevice unlockForConfiguration];
    }
}



- (UIImageView *)scanningline {
    if (!_scanningline) {
        _scanningline = [[UIImageView alloc] init];
        _scanningline.image = self.scanLineImage;
        _scanningline.frame = CGRectMake(scanContent_X,scanContent_Y,scanContent_Width,2);
    }
    return _scanningline;
}

- (void)addTimer {
    if (self.scanningline) {
        [self.scanningline removeFromSuperview];
    }
    if (self.timer) {
        [self.timer invalidate];
    }
    
    [self addSubview:self.scanningline];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.animationTimeInterval target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
    [self.scanningline removeFromSuperview];
    self.scanningline = nil;
}

- (void)timeAction {
    __block CGRect frame = _scanningline.frame;
    static BOOL flag = YES;
    if (flag) {
        frame.origin.y = scanContent_Y;
        flag = NO;
        [UIView animateWithDuration:self.animationTimeInterval animations:^{
            frame.origin.y += 5;
            self.scanningline.frame = frame;
        } completion:nil];
    } else {
        if (self.scanningline.frame.origin.y >= scanContent_Y) {
            CGFloat scanContent_MaxY = scanContent_Y + self.frame.size.width - 2 *scanContent_X;
            if (self.scanningline.frame.origin.y >= scanContent_MaxY - 10) {
                frame.origin.y = scanContent_Y;
                self.scanningline.frame = frame;
                flag = YES;
            } else {
                [UIView animateWithDuration:self.animationTimeInterval animations:^{
                    frame.origin.y += 5;
                    self.scanningline.frame = frame;
                } completion:nil];
            }
        } else {
            flag = !flag;
        }
    }
}

- (void)setCornerLocation:(CornerLocation)cornerLocation{
    _cornerLocation = cornerLocation;
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
}

- (void)setCornerColor:(UIColor *)cornerColor{
    _cornerColor = cornerColor;
}

- (void)setCornerWidth:(CGFloat)cornerWidth{
    _cornerWidth = cornerWidth;
}

- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha{
    _backgroundAlpha = backgroundAlpha;
}

- (void)setAnimationTimeInterval:(CGFloat)animationTimeInterval{
    _animationTimeInterval = animationTimeInterval;
}

- (void)setDescribe:(NSString *)describe{
    _describe = describe;
}
@end
