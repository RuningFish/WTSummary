//
//  WTCustomSlider.m
//  UISlider
//
//  Created by piyingke on 2017/10/21.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTCustomSlider.h"

@interface WTCustomSlider ()
/** slider的背景色view */
@property (nonatomic, strong) UIView * backgroundView;
/** slider的缓冲进度view */
@property (nonatomic, strong) UIView * bufferProgressView;
/** slider的播放进度view */
@property (nonatomic, strong) UIView * playedProgressView;
/** 圆形小球的触摸区域 */
@property (nonatomic, strong) UIImageView * touchView;
/** slider的小圆球 */
@property (nonatomic, strong) UIButton * thumbBall;

@property (nonatomic, assign) CGFloat touchViewY;
@end

/** 触摸区域的大小 */
static CGFloat touchWidth = 40;

@implementation WTCustomSlider

- (instancetype)init{
    if (self = [super init]) {
        [self installSubviews];
    }
    return self;
}

- (void)installSubviews{
    
    /** slider的背景色view */
    self.backgroundView = [[UIView alloc] init];
    [self addSubview:self.backgroundView];
    
    /** slider的缓冲进度view */
    self.bufferProgressView = [[UIView alloc] init];
    [self addSubview:self.bufferProgressView];
    
    /** slider的播放进度view */
    self.playedProgressView = [[UIView alloc] init];
    [self addSubview:self.playedProgressView];
    
    /** 圆形小球的触摸区域 */
    self.touchView = [[UIImageView alloc] init];
    self.touchView.userInteractionEnabled = YES;
    [self addSubview:self.touchView];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panViewTouch:)];
    [self.touchView addGestureRecognizer:pan];
    
    /** slider的圆形小球 */
    self.thumbBall = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.touchView addSubview:self.thumbBall];
    
    self.touchView.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.bufferProgressView.backgroundColor = [UIColor lightGrayColor];
    self.playedProgressView.backgroundColor = [UIColor redColor];
    self.thumbBall.backgroundColor = [UIColor whiteColor];
    
    /** 触摸区域的位置 */
    CGFloat touchButtonX = -touchWidth/2;
    CGFloat touchButtonY = (touchWidth >= self.frame.size.height)?(self.frame.size.height/2 - touchWidth/2):(self.frame.size.height/2 - touchWidth/2);
    self.touchView.frame = CGRectMake(touchButtonX, touchButtonY, touchWidth, touchWidth);
    
    self.thumbBallSize = CGSizeMake(13, 13);
    self.value = 0.0;
    self.minimumValue = 0.0;
    self.maximumValue = 1.0;
    self.sliderHieght = 2.0;
    self.showThumbBall = YES;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat sliderHeight = (self.sliderHieght > 0)?self.sliderHieght:2;
    self.backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, sliderHeight);
    
    CGFloat centerY = self.frame.size.height*0.5;
    CGPoint  centerPoint = self.center;
    centerPoint.y = self.center.y;
    
    self.backgroundView.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    CGPoint playCenter = self.playedProgressView.center;
    playCenter.y = centerY;
    self.playedProgressView.center = playCenter;
    
    CGPoint center = self.touchView.center;
    center.y = centerY;
    self.touchView.center = center;
    self.touchViewY = self.touchView.frame.origin.y;

    // 圆形小球的位置
    CGFloat thumbBallW = MAX(self.thumbBallSize.width, self.thumbBallSize.height);
    
    CGFloat thumbBallX = (touchWidth - thumbBallW)/2;
    self.thumbBall.frame = CGRectMake(thumbBallX, thumbBallX, thumbBallW, thumbBallW);
    self.thumbBall.layer.cornerRadius = thumbBallW*0.5;
    self.thumbBall.layer.masksToBounds = YES;
    
    // 如果自动旋转的话，小屏的缓冲进度需要在全屏下更新
    if (self.bufferValue == 1.0) {
        CGFloat playedProgressY = (self.frame.size.height - self.sliderHieght)/2;
        self.bufferProgressView.frame = CGRectMake(0, playedProgressY, self.frame.size.width, self.sliderHieght);
    }
}

- (void)panViewTouch:(UIGestureRecognizer *)gesture{
    
    CGPoint point = [gesture locationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(sliderBeginMove:)]) {
            [self.delegate sliderBeginMove:self];
        }
    }
    
    else if (gesture.state == UIGestureRecognizerStateChanged){
        
        // 移动范围的最小值
        CGFloat minX = -touchWidth/2;
        // 移动范围的最大值
        CGFloat maxX = self.frame.size.width - touchWidth/2;
        if (point.x <= minX) {
            point.x = minX;
        }
        else if (point.x >= maxX){
            point.x = maxX;
        }
        self.touchView.frame = CGRectMake(point.x, self.touchViewY, touchWidth, touchWidth);
        // 滑动的进度值
        CGFloat value = (point.x + touchWidth/2 - self.backgroundView.frame.origin.x)/self.backgroundView.frame.size.width;
        
        CGFloat playedProgressY = (self.frame.size.height - self.sliderHieght)/2;
        self.playedProgressView.frame = CGRectMake(0, playedProgressY, self.frame.size.width*value, self.sliderHieght);
        value = (self.maximumValue - self.minimumValue)*value + self.minimumValue;
        self.value = value;
    
        if ([self.delegate respondsToSelector:@selector(sliderMoving:)]) {
            [self.delegate sliderMoving:self];
        }
    }
    
    else if (gesture.state == UIGestureRecognizerStateEnded){
        if ([self.delegate respondsToSelector:@selector(sliderEndMove:)]) {
            [self.delegate sliderEndMove:self];
        }
    }
    
}

- (void)setValue:(float)value{
    
    if (value >= self.minimumValue && value <= self.maximumValue) {
        _value = value;
        CGFloat playedProgressY = (self.frame.size.height - self.sliderHieght)/2;
        // 当前播放的进度
        if ((1.0-(value-self.minimumValue)<=0.01)) {
            value = 1.0;
        }
        CGFloat playedProgressW = self.frame.size.width*(value - self.minimumValue);
        self.playedProgressView.frame = CGRectMake(0, playedProgressY, playedProgressW, self.sliderHieght);
        CGPoint touchViewCenter = self.touchView.center;
        touchViewCenter.x = playedProgressW;
        self.touchView.center = touchViewCenter;
        
    }
    else if (value > self.maximumValue){
        _value = self.maximumValue;
    }
    else if (value < self.maximumValue){
        _value = self.minimumValue;
    }
    
}

- (void)setBufferValue:(float)bufferValue{
    
    if (self.bufferValue >= bufferValue) return;
    
    _bufferValue = bufferValue;
    CGFloat playedProgressY = (self.frame.size.height - self.sliderHieght)/2;
    // 缓冲的进度
    if ((1.0-bufferValue<=0.001)) {
        bufferValue = 1.0;
    }
    CGFloat bufferProgressW = self.frame.size.width*bufferValue;
    self.bufferProgressView.frame = CGRectMake(0, playedProgressY, bufferProgressW, self.sliderHieght);
    
}

- (void)setThumbBallSize:(CGSize)thumbBallSize{
    
    _thumbBallSize = thumbBallSize;
    CGRect frame = self.thumbBall.frame;
    frame.size = thumbBallSize;
    self.thumbBall.frame = frame;
    
}
- (void)setShowThumbBall:(BOOL)showThumbBall{
    
    _showThumbBall = showThumbBall;
    self.touchView.hidden = !showThumbBall;
}

- (void)setBackProgressColor:(UIColor *)backProgressColor{
    
    _backProgressColor = backProgressColor;
    self.backgroundView.backgroundColor = backProgressColor;
    
}

- (void)setPlayedProgressColor:(UIColor *)playedProgressColor{
    
    _playedProgressColor = playedProgressColor;
    self.playedProgressView.backgroundColor = playedProgressColor;
}

- (void)setBufferProgressColor:(UIColor *)bufferProgressColor{
    
    _bufferProgressColor = bufferProgressColor;
    self.bufferProgressView.backgroundColor = bufferProgressColor;
}

- (void)setThumbBallColor:(UIColor *)color{
    
    self.thumbBall.backgroundColor = color;
}

- (void)setThumbBallImage:(UIImage *)image{
    
    [self.thumbBall setImage:image forState:UIControlStateNormal];
}
@end
