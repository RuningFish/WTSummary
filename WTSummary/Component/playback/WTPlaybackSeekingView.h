//
//  WTPlaybackSeekingView.h
//
//  Created by piyingke on 2017/10/30.
//  Copyright © 2017年 piyingke. All rights reserved.
//  快进／快退的界面

#import <UIKit/UIKit.h>

@interface WTPlaybackSeekingView : UIView
/** 快进／快退的图标 */
@property (nonatomic, strong) UIImageView * seekingImageView;
/** 当前的播放时间 */
@property (nonatomic, assign) CGFloat currentTime;
/** 总时长 */
@property (nonatomic, assign) CGFloat duration;

+ (instancetype)seekingView;
- (void)show;
- (void)remove;

@end
