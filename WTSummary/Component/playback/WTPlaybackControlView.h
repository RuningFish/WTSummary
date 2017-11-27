//
//  WTPlaybackControlView.h
//  
//
//  Created by piyingke on 2017/10/11.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTControlBottomView.h"
#import "WTCustomSlider.h"
#import "WTControlTopView.h"
#import "WTControlMiddleView.h"

//#define WTPlaybackBundle(file) [@"WTPlayback.bundle" stringByAppendingPathComponent:file]

@class WTSlider;
@interface WTPlaybackControlView : UIView
/** 顶部的视频介绍 */
@property (nonatomic, strong) WTControlTopView    * topView;
/** 中间的暂停／播放按钮 */
@property (nonatomic, strong) WTControlMiddleView * middleView;
/** 底部的进度条／全屏等 */
@property (nonatomic, strong) WTControlBottomView * bottomView;
/** videoInfo */
@property (nonatomic, strong) VideoInfo  * videoInfo;
/** 底部细的进度条 */
@property (nonatomic, strong) WTCustomSlider * bottomSlider;

- (void)mediaControlHidden;
- (void)cancelHidden;

@end
