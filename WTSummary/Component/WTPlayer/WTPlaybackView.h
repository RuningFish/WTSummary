//
//  WTPlaybackView.h
//  123
//
//  Created by piyingke on 17/9/29.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WTPlaybackContentModeNone = 0,
    WTPlaybackContentModeAspectFit,
    WTPlaybackContentModeAspectFill,
    WTPlaybackContentModeFill
}WTPlaybackContentMode;

typedef enum {
    WTPlaybackPlaybackStateStopped = 0,
    WTPlaybackPlaybackStatePlaying,
    WTPlaybackPlaybackStatePaused,
    WTPlaybackPlaybackStateInterrupted,
    WTPlaybackPlaybackStateSeekingForward
}WTPlaybackPlaybackState;

typedef enum {
    WTPlaybackLoadStateUnknown = 0,
    WTPlaybackLoadStateBuffing,
    WTPlaybackLoadStatePlayable
}WTPlaybackLoadState;

@interface WTPlaybackView : UIView

- (void)prepareToPlay;
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (void)shutdown;
- (void)setPauseInBackground:(BOOL)pause;

/** 当前播放时间 */
@property (nonatomic)    NSTimeInterval currentPlaybackTime;
/** 视频总时长 */
@property (nonatomic, readonly)  NSTimeInterval duration;
@property (nonatomic, readonly)  NSTimeInterval playableDuration;
/** 是否准备播放 */
@property (nonatomic, readonly)  BOOL isPreparedToPlay;
/** 播放状态 */
@property (nonatomic, readonly)  WTPlaybackPlaybackState playbackState;
/** load状态 */
@property (nonatomic, readonly)  WTPlaybackLoadState loadState;

@property (nonatomic, assign) WTPlaybackContentMode playbackMode;
/** 自动播放 */
@property (nonatomic, assign) BOOL autoPlay;

@property (nonatomic) float playbackRate;
/** 0:无声音 1:有声音 */
@property (nonatomic, assign) float playbackVolume;
/** 是否需要边下边播 */
@property (nonatomic, assign) BOOL playCache;

/** 当前播放时间点截屏 */
- (UIImage *)thumbnailImageAtCurrentTime;

- (id)initWithURL:(NSURL *)url;
- (id)initWithURLString:(NSString *)urlString;

/** 从time处开始播放视频跳转 */
- (void)seekToTime:(CGFloat)time completionHandler:(void(^)(BOOL finished))completionHandle;

@end

extern NSString * const WTPlaybackReadyToPlayNotification;
extern NSString * const WTPlaybackLoadStateDidChangeNotification;
extern NSString * const WTPlaybackPlayerItemDidPlayToEndTimeNotification;
extern NSString * const WTPlaybackPlayStateDidChangeNotification;

