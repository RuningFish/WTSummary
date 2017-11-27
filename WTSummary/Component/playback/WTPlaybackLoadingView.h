//
//  WTPlaybackLoadingView.h
//  123
//
//  Created by admin on 17/10/22.
//  Copyright © 2017年 piyingke. All rights reserved.
//  用来显示loading 和 重播的视图

#import <UIKit/UIKit.h>

typedef void (^replayButtonBlock)();
typedef void (^shareButtonBlock)();

@interface WTPlaybackLoadingView : UIView

/** loading的图片 如果不设置 默认显示系统的loading */
@property (nonatomic, strong) UIImage * loadingImage;
/** 重播的icon */
@property (nonatomic, strong) UIImage * replayImage;
/** 分享的icon */
@property (nonatomic, strong) UIImage * shareImage;
/** 是否要显示重播 */
@property (nonatomic, assign) BOOL  isShowReplay;

@property (nonatomic, copy) replayButtonBlock replayBlock;
@property (nonatomic, copy) shareButtonBlock   shareBlock;


- (void)startLoading;
- (void)stopLoading;

/** 显示重播和分享 */
- (void)showReplayAndShare;
/** 隐藏重播和分享 */
- (void)hiddenReplayAndShare;

@end
