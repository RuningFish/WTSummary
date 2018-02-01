//
//  WTPlaybackContainerView.m
//  
//
//  Created by piyingke on 2017/10/11.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTPlaybackContainerView.h"
#import "WTPlaybackLoadingView.h"

@interface WTPlaybackContainerView ()<WTCustomSliderDelegate,WTSliderControlDelegate>


/** 显示loading 和 重播的view */
@property (nonatomic, strong) WTPlaybackLoadingView * loadingView;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, strong) NSTimer * timer;
@end

@implementation WTPlaybackContainerView

- (instancetype)initWithContentUrl:(NSString *)url{
    
    if (self = [super init]) {
        
        [self shutdown];
        
        self.url = url;
        [self installSubviews];
    }
    return self;
}

- (void)installSubviews{
    
    WTPlaybackBottomView * bottomView = [[WTPlaybackBottomView alloc] init];
    self.bottomView = bottomView;
    bottomView.bottomSuperView = self;
    [self addSubview:bottomView];
    
//    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.mp4"];
    
    WTPlaybackView * playbackView = [[WTPlaybackView alloc] initWithURLString:self.url];
    self.playbackView = playbackView;
    playbackView.playCache = NO;
    [self.bottomView addSubview:playbackView];
    
    WTPlaybackControlView * mediaControlView = [[WTPlaybackControlView alloc] init];
    self.mediaControlView = mediaControlView;
    [self.bottomView addSubview:mediaControlView];
    mediaControlView.bottomView.bottomSlider.delegate = self;
    mediaControlView.bottomView.fullScreenBlock = ^(UIButton * button){
        if (button.selected) {
            // 全屏
            [bottomView switchFullscreen:YES success:nil];
            [button setImage:[UIImage imageNamed:WTPlaybackBundle(@"Fullscreen_exit")] forState:UIControlStateNormal];
            NSLog(@"全屏");
        }
        else{
            // 半屏
            [bottomView switchFullscreen:NO success:nil];
            [button setImage:[UIImage imageNamed:WTPlaybackBundle(@"Fullscreen")] forState:UIControlStateNormal];
            NSLog(@"半屏");
        }
    };
    
    // loading 和 重播
    WTPlaybackLoadingView * loadingView = [[WTPlaybackLoadingView alloc] init];
    self.loadingView = loadingView;
    [self.bottomView addSubview:loadingView];
    self.loadingView.loadingImage = [UIImage imageNamed:WTPlaybackBundle(@"venvy_sdk_progress_bar_anim_bg")];
    [loadingView startLoading];
    
    loadingView.replayImage = [UIImage imageNamed:WTPlaybackBundle(@"tv_bt_load")];
    loadingView.shareImage = [UIImage imageNamed:WTPlaybackBundle(@"tv_bt_share")];
    
    // 重播
    __weak typeof(loadingView) weakLoading = loadingView;
    loadingView.replayBlock = ^(){
      
        [self.playbackView stop];
        [weakLoading hiddenReplayAndShare];
        [self play];
        [self refreshMediaControl];
        
    };
    
    //注册通知
    [self registerNotifications];
        
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (currentOrientation == UIDeviceOrientationPortrait) {
        self.bottomView.frame = self.bounds;
    } else {
        self.bottomView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
  
    self.mediaControlView.frame = self.bottomView.bounds;
    self.playbackView.frame = self.bottomView.bounds;
    self.loadingView.frame = self.bottomView.bounds;
    
    [self.mediaControlView layoutIfNeeded];
}

- (void)prepareToPlay{
    [self.playbackView prepareToPlay];
}

- (void)play{
    [self.playbackView play];
    [self refreshMediaControl];
}

- (void)pause{
    [self.playbackView pause];
    [self stopRefresh];
}

- (void)shutdown{
    
    [self.bottomView removeFromSuperview];
    [self.mediaControlView removeFromSuperview];
    [self.loadingView removeFromSuperview];
    [self.playbackView shutdown];
    [self removeNotifications];
    [self stopRefresh];
}

- (BOOL)isPlaying{
    
    return [self.playbackView isPlaying];
    
}

- (void)setVideoInfo:(VideoInfo *)videoInfo{
    
    _videoInfo = videoInfo;
    self.mediaControlView.videoInfo = videoInfo;
    
}

- (void)registerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackReadyToplay:) name:WTPlaybackReadyToPlayNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackPlayToEnd:) name:WTPlaybackPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackPlayStateChange:) name:WTPlaybackPlayStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackLoadStateChange:) name:WTPlaybackLoadStateDidChangeNotification object:nil];
    
}

- (void)playbackStateChange:(NSNotification *) noti{
    
//    if (self.playbackView.playState == WTPlaybackStateFailed) {
//        NSLog(@"WTPlaybackStateFailed");
//    }
//    else if (self.playbackView.playState == WTPlaybackStateBuffing){
//        NSLog(@"WTPlaybackStateBuffing");
//    }
//    else if (self.playbackView.playState == WTPlaybackStatePlaying){
//        NSLog(@"WTPlaybackStatePlaying");
//    }
//    else if (self.playbackView.playState == WTPlaybackStatePaused){
//        NSLog(@"WTPlaybackStatePaused");
//    }
//    else if (self.playbackView.playState == WTPlaybackStateStoped){
//        NSLog(@"WTPlaybackStateStoped");
//    }
}

- (void)removeNotifications{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playbackReadyToplay:(NSNotification *)notification{
    
    if (self.videoInfo.lastPlayTime) {
        self.playbackView.currentPlaybackTime = self.videoInfo.lastPlayTime;
    }
    
    [self.playbackView play];
    // 隐藏loading
    [self.loadingView stopLoading];
    // 刷新播放时间
    [self refreshMediaControl];
}

- (void)playbackPlayToEnd:(NSNotification *)notification{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    NSLog(@"playbackPlayToEnd %.02lf ",self.playbackView.currentPlaybackTime);
    NSDictionary * info = notification.userInfo;
    if ([info[WTPlaybackDidFinishReasonUserInfoKey] isEqualToString:WTPlaybackPlayedEnd]) {
        if (self.playbackView.currentPlaybackTime >= self.playbackView.duration) {
            // 显示重播和分享
            [self.loadingView showReplayAndShare];
            // 隐藏进度条
            [self.mediaControlView mediaControlHidden];
        }
    }
    else if ([info[WTPlaybackDidFinishReasonUserInfoKey] isEqualToString:WTPlaybackPlayedError]){
        NSLog(@"播放出错");
        [self.loadingView stopLoading];
    }
    
}

- (void)playbackPlayStateChange:(NSNotification *)notification{
    
}

- (void)playbackLoadStateChange:(NSNotification *)notification{
    
    WTPlaybackView * playback = notification.object;
    if (playback.loadState == WTPlaybackLoadStateUnknown) {
        NSLog(@"WTPlaybackLoadStateUnknown");
        [self.loadingView startLoading];
    }
    else if (playback.loadState == WTPlaybackLoadStateBuffing){
        NSLog(@"WTPlaybackLoadStateBuffing");
        [self.loadingView startLoading];
    }
    else if (playback.loadState == WTPlaybackLoadStatePlayable){
        NSLog(@"WTPlaybackLoadStatePlayable");
        [self.loadingView stopLoading];
    }
    else{
        NSLog(@"xxxxx");
    }
    
}

- (void)refreshMediaControl{
    
    [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    
    NSInteger min = self.playbackView.currentPlaybackTime/60;
    NSInteger sec = self.playbackView.currentPlaybackTime - min*60;
    self.mediaControlView.bottomView.currentTime.text = [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
    CGFloat value = self.playbackView.currentPlaybackTime/self.playbackView.duration;
    [self.mediaControlView.bottomView.slider setValue:value animated:YES];
    
    value = [[NSString stringWithFormat:@"%.03lf",value] floatValue];
    self.mediaControlView.bottomSlider.value = value;
    
    CGFloat bufferProgress = [[NSString stringWithFormat:@"%.02lf",self.playbackView.playableDuration/self.playbackView.duration] floatValue];
    self.mediaControlView.bottomSlider.bufferValue = bufferProgress;
    
    self.mediaControlView.bottomView.bottomSlider.value  = value;
    self.mediaControlView.bottomView.bottomSlider.bufferValue = bufferProgress;
    self.videoInfo.lastPlayTime = self.playbackView.currentPlaybackTime;
}

- (void)stopRefresh{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
}

#pragma mark - WTCustomSliderDelegate
- (void)sliderControlBeginMove:(WTSliderControl *)sliderControl{
    
    [self stopRefresh];
    [self.mediaControlView cancelHidden];
    
}
- (void)sliderControlMoving:(WTSliderControl *)sliderControl{
    
    // 当前播放时间的更新
    NSInteger min = sliderControl.value * self.playbackView.duration/60;
    NSInteger sec = sliderControl.slider.value * self.playbackView.duration - min*60;
    NSString * currentTime = [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
    self.mediaControlView.bottomView.currentTime.text = currentTime;
    
}

- (void)sliderControlEndMove:(WTSliderControl *)sliderControl{
    
    self.playbackView.currentPlaybackTime = sliderControl.slider.value * self.playbackView.duration;
    
    [self refreshMediaControl];
    SEL hidden = NSSelectorFromString(@"mediaControlHidden");
    [self.mediaControlView performSelector:hidden withObject:nil afterDelay:5.0];
}

- (void)sliderBeginMove:(WTCustomSlider *)slider{
    
    [self stopRefresh];
    [self.mediaControlView cancelHidden];
    
}
- (void)sliderMoving:(WTCustomSlider *)slider{
    
    // 当前播放时间的更新
    NSInteger min = slider.value * self.playbackView.duration/60;
    NSInteger sec = slider.value * self.playbackView.duration - min*60;
    NSString * currentTime = [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
    self.mediaControlView.bottomView.currentTime.text = currentTime;
    
}

- (void)sliderEndMove:(WTCustomSlider *)slider{
    
    self.playbackView.currentPlaybackTime = slider.value * self.playbackView.duration;
    [self refreshMediaControl];
    SEL hidden = NSSelectorFromString(@"mediaControlHidden");
    [self.mediaControlView performSelector:hidden withObject:nil afterDelay:5.0];
}
@end
