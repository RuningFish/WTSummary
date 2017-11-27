//
//  WTControlBottomView.h
//  123
//
//  Created by admin on 17/10/15.
//  Copyright © 2017年 piyingke. All rights reserved.
//  暂停 时长 全屏 进度条 的view

#import <UIKit/UIKit.h>
#import "WTCustomSlider.h"
#import "WTSliderControl.h"

@class WTSlider;
typedef void (^FullScreenButtonBlock)(UIButton *);

@interface WTControlBottomView : UIView
/** 当前的播放时间 */
@property (nonatomic, strong) UILabel * currentTime;
/** 视频的总时长 */
@property (nonatomic, strong) UILabel * totalTime;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton * fullScreenBtn;
/** slider */
@property (nonatomic, strong) WTSlider  * slider;
/** slider */
@property (nonatomic, strong) WTCustomSlider  * bottomSlider;

@property (nonatomic, strong) WTSliderControl * sliderControl;
/** 全屏按钮的点击 */
@property(nonatomic, copy) FullScreenButtonBlock fullScreenBlock;
@end
