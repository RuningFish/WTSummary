//
//  WTSliderControl.m
//  UISlider
//
//  Created by piyingke on 2017/10/25.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTSliderControl.h"

@interface WTSliderControl ()
/** 缓冲的进度 */
@property (nonatomic, strong) UIProgressView * progressView;


@end
/** 进度条和缓冲条的高度 */
static CGFloat trackHeight = 2.0;
@implementation WTSliderControl

- (instancetype)init{
    
    if (self = [super init]) {
        self.showThumb = YES;
        [self installSubviews];
    }
    return self;
}

- (void)installSubviews{
    
    UIProgressView * progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView = progressView;
    [self addSubview:self.progressView];
    self.progressView.progressTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    self.progressView.trackTintColor = [UIColor clearColor];
    
    WTSlider * slider = [[WTSlider alloc] init];
    self.slider = slider;
    [slider setThumbImage:[self circleImageWithColor:[UIColor whiteColor] radius:13] forState:UIControlStateNormal];
    [self addSubview:self.slider];
    
    self.progressView.backgroundColor = [UIColor redColor];
    [self.progressView setProgress:0.7 animated:NO];
    
//    self.slider.minimumTrackTintColor = [UIColor greenColor];
    [self.slider setValue:0.5 animated:NO];
    
    [slider addTarget:self action:@selector(sliderControlBeginMove) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(sliderControlMoving) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(sliderControlEndMove) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.progressView.frame = CGRectMake(0, 0, self.frame.size.width, trackHeight);
    /** 修改progressview的高度 */
//    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 0.5f);
    self.progressView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.slider.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)sliderControlBeginMove{
    if ([self.delegate respondsToSelector:@selector(sliderControlBeginMove:)]) {
        [self.delegate sliderControlBeginMove:self];
//        NSLog(@"sliderControlBeginMove");
    }
}

- (void)sliderControlMoving{
    if ([self.delegate respondsToSelector:@selector(sliderControlMoving:)]) {
        [self.delegate sliderControlMoving:self];
//        NSLog(@"sliderControlMoving");
    }
}

- (void)sliderControlEndMove{
    if ([self.delegate respondsToSelector:@selector(sliderControlEndMove:)]) {
        [self.delegate sliderControlEndMove:self];
//        NSLog(@"sliderControlEndMove");
    }
}

- (float)value{
    return self.slider.value;
}

//- (void)setValue:(float)value{
//    _value = value;
//}
- (void)setShowThumb:(BOOL)showThumb{
    
    _showThumb = showThumb;
    if (!showThumb) {
        [self.slider setThumbImage:[self circleImageWithColor:[UIColor clearColor] radius:1.0] forState:UIControlStateNormal];
        self.slider.userInteractionEnabled = showThumb;
    }
    else{
        [self.slider setThumbImage:[self circleImageWithColor:self.thumbColor?self.thumbColor:[UIColor whiteColor] radius:13.0] forState:UIControlStateNormal];
        self.slider.userInteractionEnabled = showThumb;
    }
    
}

- (void)setThumbWidth:(float)thumbWidth{
    _thumbWidth = thumbWidth;
    [self.slider setThumbImage:[self circleImageWithColor:self.thumbColor?self.thumbColor:[UIColor whiteColor] radius:thumbWidth] forState:UIControlStateNormal];
}

- (void)setThumbColor:(UIColor *)thumbColor{
    _thumbColor = thumbColor;
    [self.slider setThumbImage:[self circleImageWithColor:thumbColor radius:self.thumbWidth?self.thumbWidth:13] forState:UIControlStateNormal];
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor{
    _minimumTrackTintColor = minimumTrackTintColor;
    self.slider.minimumTrackTintColor = minimumTrackTintColor;
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor{
    _maximumTrackTintColor = maximumTrackTintColor;
    self.slider.maximumTrackTintColor = maximumTrackTintColor;
}

- (void)setProgress:(float)progress{
    _progress = progress;
    [self.progressView setProgress:progress];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor{
    _progressTintColor = progressTintColor;
    self.progressView.progressTintColor = progressTintColor;
    
}

- (void)setTrackTintColor:(UIColor *)trackTintColor{
    _trackTintColor = trackTintColor;
    self.progressView.trackTintColor = trackTintColor;
}

#pragma mark - image method
/** 隐藏滑块按钮 */
- (UIImage *)rectImageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f,0.0f, size.width,size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 圆形图片隐藏滑块按钮 */
- (UIImage *)circleImageWithColor:(UIColor *)color radius:(CGFloat)radius{
    
    UIImage * image = [self rectImageWithColor:color size:CGSizeMake(radius, radius)];
    return [self circleImageWithImage:image borderWidth:0 borderColor:[UIColor clearColor]];
}

/** 设置滑块按钮的大小 */
- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return newImage;
}


- (UIImage *)circleImageWithImage:(UIImage *)sourceImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    
    CGFloat imageWidth = sourceImage.size.width + 2 * borderWidth;
    
    CGFloat imageHeight = sourceImage.size.height + 2 * borderWidth;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeight), NO, 0.0);
    
    UIGraphicsGetCurrentContext();
    
    CGFloat radius = (sourceImage.size.width < sourceImage.size.height?sourceImage.size.width:sourceImage.size.height)*0.5;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imageWidth * 0.5, imageHeight * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    bezierPath.lineWidth = borderWidth;
    
    [borderColor setStroke];
    
    [bezierPath stroke];
    
    [bezierPath addClip];
    
    [sourceImage drawInRect:CGRectMake(borderWidth, borderWidth, sourceImage.size.width, sourceImage.size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
@end

@implementation WTSlider
//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
//
//    rect.size.width = 13;
//    rect.size.height = 13;
//    rect.origin.x = 0;
//    rect.origin.y = (bounds.size.height - rect.size.height)/2;
//
//    CGRect rec = CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 13 , 13);
//
//    return rec;//CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 13 , 13);
//}

- (CGRect)trackRectForBounds:(CGRect)bounds{

    bounds.size.width = self.frame.size.width;
    bounds.size.height = trackHeight;
    bounds.origin.x = 0;
    bounds.origin.y = (self.frame.size.height - bounds.size.height)/2;
    return bounds;
}

@end
