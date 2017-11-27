//
//  WTSliderControl.h
//  UISlider
//
//  Created by piyingke on 2017/10/25.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTSliderControl,WTSlider;
@protocol WTSliderControlDelegate <NSObject>
@optional
- (void)sliderControlBeginMove:(WTSliderControl *)sliderControl;
- (void)sliderControlMoving:(WTSliderControl *)sliderControl;
- (void)sliderControlEndMove:(WTSliderControl *)sliderControl;
@end

@interface WTSliderControl : UIControl
/** 播放的进度 */
@property (nonatomic, strong) WTSlider * slider;

/** slider value */
@property (nonatomic) float value;
/** delegate */
@property (nonatomic, weak) id<WTSliderControlDelegate> delegate;
/** 是否显示小圆球 默认显示 */
@property (nonatomic, assign) BOOL showThumb;
/** 小圆球的大小 */
@property (nonatomic, assign) float thumbWidth;
/** 小圆球的颜色 */
@property (nonatomic, strong) UIColor * thumbColor;
@property (nonatomic, strong) UIColor * minimumTrackTintColor;
@property (nonatomic, strong) UIColor * maximumTrackTintColor;

/** progressView */
@property (nonatomic, assign) float progress;
@property (nonatomic, strong) UIColor * progressTintColor;
@property (nonatomic, strong) UIColor * trackTintColor;
@end

@interface WTSlider : UISlider
@end
