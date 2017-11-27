//
//  WTCustomSlider.h
//  UISlider
//
//  Created by piyingke on 2017/10/21.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTCustomSlider;
@protocol WTCustomSliderDelegate <NSObject>

@optional
- (void)sliderBeginMove:(WTCustomSlider *)slider;
- (void)sliderMoving:(WTCustomSlider *)slider;
- (void)sliderEndMove:(WTCustomSlider *)slider;
@end

@interface WTCustomSlider : UIControl

/** 播放的进度 */
@property (nonatomic, assign) float value;
/** 缓冲的进度 */
@property (nonatomic, assign) float bufferValue;
/** 最小值 */
@property (nonatomic, assign) float minimumValue;
/** 最大值 */
@property (nonatomic, assign) float maximumValue;
/** 圆形小球的大小 */
@property (nonatomic, assign) CGSize thumbBallSize;
/** 进度条的高度 默认为2 */
@property (nonatomic, assign) float sliderHieght;
/** 是否显示小圆球 默认显示 */
@property (nonatomic, assign,getter=isShowThumbBall) BOOL showThumbBall;
/** delegate */
@property (nonatomic, weak) id<WTCustomSliderDelegate> delegate;
/** 默认进度条的颜色 */
@property (nonatomic, strong) UIColor * backProgressColor;
/** 已播放进度条的颜色 */
@property (nonatomic, strong) UIColor * playedProgressColor;
/** 缓冲进度条的颜色 */
@property (nonatomic, strong) UIColor * bufferProgressColor;

/** 设置小球的颜色 */
- (void)setThumbBallColor:(UIColor *)color;
/** 设置小球的图片 */
- (void)setThumbBallImage:(UIImage *)image;

@end
