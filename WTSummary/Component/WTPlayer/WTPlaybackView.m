//
//  WTPlaybackView.m
//  123
//
//  Created by piyingke on 17/9/29.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTPlaybackView.h"
#import <AVFoundation/AVFoundation.h>
#import "WTPlaybackKVO.h"
#import "WTAudioSession.h"
#import "WTNotificationManager.h"
#import "WTPlaybackIdleTimer.h"
#import "WTResourceLoaderManager.h"
#import "WTResourceCacheManager.h"
#import "TVideoLoadManager.h"
inline static bool isFloatZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

/** 准备播放 */
NSString * const WTPlaybackReadyToPlayNotification = @"WTPlaybackReadyToPlayNotification";
/** loadState 改变*/
NSString * const WTPlaybackLoadStateDidChangeNotification = @"WTPlaybackLoadStateDidChangeNotification";
/** 播放完成 */
NSString * const WTPlaybackPlayerItemDidPlayToEndTimeNotification = @"WTPlaybacPlayerItemDidPlayToEndTimeNotification";
/** 播放状态改变 */
NSString * const WTPlaybackPlayStateDidChangeNotification = @"WTPlaybackPlayStateDidChangeNotification";
/**播放完成的infoKey */
NSString * const WTPlaybackDidFinishReasonUserInfoKey = @"WTPlaybackDidFinishReasonUserInfoKey";
/** 正常播放完成 */
NSString * const WTPlaybackPlayedEnd = @"WTPlaybackPlayedEnd";
/** 播放出错 */
NSString * const WTPlaybackPlayedError = @"WTPlaybackPlayedError";
@interface WTPlaybackView ()

@property (nonatomic, strong) NSURL * playUrl;
@property (nonatomic, strong) AVURLAsset * playAsset;
@property (nonatomic, strong) AVPlayerItem * playerItem;
@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;
@property (nonatomic, strong) WTPlaybackKVO * playerManager;
@property (nonatomic, strong) WTPlaybackKVO * playerItemManager;
@property (nonatomic, assign,getter=isShutdown) BOOL shutdown;
@property (nonatomic, assign) BOOL pauseInBackground;
@property (nonatomic, assign) BOOL playToEnd;
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, assign) BOOL isSeeking;
@property (nonatomic, assign) BOOL playingBeforeInterruption;
@property (nonatomic) dispatch_once_t readyToPlayToken;
@property (nonatomic, assign) NSTimeInterval seekingTime;

@property (nonatomic, readwrite)  NSTimeInterval duration;
@property (nonatomic, readwrite)  NSTimeInterval playableDuration;
@property (nonatomic, readwrite)  NSInteger bufferingProgress;
@property (nonatomic, readwrite)  BOOL isPreparedToPlay;
@property (nonatomic, readwrite)  WTPlaybackPlaybackState playbackState;
@property (nonatomic, readwrite)  WTPlaybackLoadState loadState;

@property (nonatomic, strong)     WTNotificationManager * notificationManager;
@property (nonatomic, strong)     WTResourceLoaderManager * resourceLoaderManager;
/** 是否是本地视频 */
@property (nonatomic, assign)     BOOL isLocalVideo;
@end

/** playerItem */
static NSString * const status = @"status";
static NSString * const loadedTimeRanges = @"loadedTimeRanges";
static NSString * const playbackLikelyToKeepUp = @"playbackLikelyToKeepUp";
static NSString * const playbackBufferEmpty = @"playbackBufferEmpty";
static NSString * const playbackBufferFull = @"playbackBufferFull";

/** player */
static NSString * const rate = @"rate";
static NSString * const currentItem = @"currentItem";
static NSString * const airPlayVideoActive = @"airPlayVideoActive";

@implementation WTPlaybackView

- (id)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        
        self.playUrl = url;
        self.autoPlay = NO;
        self.playToEnd = NO;
        self.isError = NO;
        self.isSeeking = NO;
        self.playbackRate = 1.0;
        self.playbackVolume = 1.0;
        self.notificationManager = [[WTNotificationManager alloc] init];
        [self setScreenOn:YES];
        
    }
    return self;
}

- (id)initWithURLString:(NSString *)urlString{
    __block NSURL * url = nil;
    if (urlString == nil) {
        urlString = @"";
    }
    if ([urlString rangeOfString:@"/"].location == 0) {
        //本地
        url = [NSURL fileURLWithPath:urlString];
        NSLog(@"本地视频");
        self.isLocalVideo = YES;
    }
    else {
        url = [NSURL URLWithString:urlString];
        [[WTResourceCacheManager manager] cacheFileForURL:url completionHandle:^(BOOL hasCached, NSString *fileUrl) {
            NSLog(@"是否有缓存 - %zd  路径 - %@",hasCached,fileUrl);
            if (hasCached) {
                url = [NSURL fileURLWithPath:fileUrl];;
                self.isLocalVideo = YES;
            }
            else{
                self.isLocalVideo = NO;
                NSLog(@"网络视频");
            }
        }];
    }
    
    if (self = [self initWithURL:url]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 屏幕on/off
- (void)setScreenOn:(BOOL)on{
    [WTPlaybackIdleTimer sharedIdleTimer].appIdleTimerDisabled = on;
}

- (void)shutdown{
    
    self.shutdown = YES;
    [self stop];
    
    if (self.playerItem != nil) {
        [self.playerItem cancelPendingSeeks];
    }
    
    [self.playerItemManager safeRemoveAllObservers];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:self.playerItem];
    [self.playerManager safeRemoveAllObservers];
    [self unregisterApplicationObservers];
    
    [self.playAsset.resourceLoader setDelegate:nil queue:dispatch_get_main_queue()];
    self.playAsset = nil;
    
    // 如果不移除AVPlayerLayer的话 最多只能播放16个
    [self.playerLayer  removeFromSuperlayer];
    self.playerLayer = nil;
    
    [self removeFromSuperview];
    
   
}
#pragma mark - play
- (void)play{
    if (self.playToEnd) {
        self.playToEnd = NO;
        [self setCurrentPlaybackTime:0];
    }
    else{
        [self.player play];
    }
}
#pragma mark - pause
- (void)pause{
    [self.player pause];
}
#pragma mark - stop
- (void)stop{
    // 1.暂停播放
    [self.player pause];
    // 2.锁屏
    [self setScreenOn:NO];
    // 3.播放完成
    self.playToEnd = YES;
}

#pragma mark - isPlaying
- (BOOL)isPlaying{
    if (!isFloatZero(self.player.rate)) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark - 准备播放
- (void)prepareToPlay{
    NSURL * url = self.playUrl;
    AVURLAsset * asset = nil;
    // 如果是m3u8类型的视频,暂不支持边下边播
    if ([url.absoluteString hasSuffix:@".m3u8"]) {
        asset = [AVURLAsset URLAssetWithURL:url options:nil];
    }
    else{
        // 需要边下边播
        if (self.playCache) {
            self.resourceLoaderManager = [WTResourceLoaderManager manager];
            // 本地没有缓存资源
            if (!self.isLocalVideo) {
                url = [self.resourceLoaderManager resourceLoaderURL:url];
                asset = [self.resourceLoaderManager assetWithURL:url];
            }
            else{
                asset = [AVURLAsset assetWithURL:url];
            }
        }
        else{
            asset = [AVURLAsset URLAssetWithURL:url options:nil];
        }
    }
    
    self.playAsset = asset;
    NSArray * keys = @[@"tracks",@"playable",@"duration"];
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didPrepareToPlayAsset:asset withKeys:keys];
            // post notification
            // setting volume
            [self setPlaybackVolume:self.playbackVolume];
            [self setPlaybackRate:self.playbackRate];
        });
    }];
    
}

- (void)didPrepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)keys{
    if (self.isShutdown) return;
    for (NSString * key in keys) {
        NSError * error = nil;
        AVKeyValueStatus keyValueStatus = [asset statusOfValueForKey:key error:&error];
        if (keyValueStatus == AVKeyValueStatusFailed) {
            NSLog(@"keyValueStatus AVKeyValueStatusFailed");
            [self onError:error];
            return;
        }
        else if (keyValueStatus == AVKeyValueStatusCancelled){
            NSLog(@"keyValueStatus AVKeyValueStatusCancelled");
            [self onError:error];
            return;
        }
        
    }
    
    if (!asset.playable) {
        NSError * playError = [NSError errorWithDomain:@"AVMoviePlayer" code:0 userInfo:nil];
        [self onError:playError];
        return;
    }
    
    // remove all observer
    [self.playerItemManager safeRemoveAllObservers];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:self.playerItem];
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.playerItemManager = [[WTPlaybackKVO alloc] initWithTarget:self.playerItem];
    
    // ApplicationObservers
    [self registerApplicationObservers];
    // add new observer
    [self addPlayerItemObserver];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemFailedToPlayToEnd:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.playerItem];
    
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        self.playerManager = [[WTPlaybackKVO alloc] initWithTarget:self.player];
        if (!self.playerLayer) {
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        }
        self.playerLayer.frame = self.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResize;//AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:self.playerLayer];
        
        [self.playerManager safeAddObserver:self forKeyPath:rate options:NSKeyValueObservingOptionNew context:nil];
        [self.playerManager safeAddObserver:self forKeyPath:currentItem options:NSKeyValueObservingOptionNew context:nil];
        [self.playerManager safeAddObserver:self forKeyPath:airPlayVideoActive options:NSKeyValueObservingOptionNew context:nil];
        
    }
    
    if (self.player.currentItem != self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:status];
        [self.playerItem removeObserver:self forKeyPath:loadedTimeRanges];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        [self.playerItem addObserver:self forKeyPath:status options:NSKeyValueObservingOptionNew context:nil];
        [self.playerItem addObserver:self forKeyPath:loadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    AVPlayerItem * playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:status]) {
        AVPlayerItemStatus status = self.playerItem.status;
        
        switch (status) {
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"AVPlayerItemStatusUnknown");
            }
                break;
            case AVPlayerItemStatusReadyToPlay:
            {
                NSLog(@"AVPlayerItemStatusReadyToPlay");
                dispatch_once(&_readyToPlayToken, ^{
                    self.isPreparedToPlay = YES;
                    NSTimeInterval duration = CMTimeGetSeconds(playerItem.duration);
                    // 视频时长
                    self.duration = (duration <= 0)?0.0f:duration;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:WTPlaybackReadyToPlayNotification object:self];
                    
                    if (self.autoPlay && (!self.pauseInBackground || [UIApplication sharedApplication].applicationState == UIApplicationStateActive)) {
                        [self.player play];
                    }
                });

            }
                break;
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"AVPlayerItemStatusFailed");
                [self onError:playerItem.error];
                
            }
                break;
                
        }
    }
    else if ([keyPath isEqualToString:loadedTimeRanges]){
        
        if (self.player && playerItem.status == AVPlayerItemStatusReadyToPlay) {
            NSArray * loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
            // 获取缓冲区域
            CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
            float startSeconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            // 计算缓冲总进度
            self.playableDuration = startSeconds + durationSeconds;
        }
        else{
            self.playableDuration = 0;
        }
    }
    
    else if ([keyPath isEqualToString:playbackLikelyToKeepUp]){
    
        NSLog(@"KVO_AVPlayerItem_playbackLikelyToKeepUp: %@", playerItem.isPlaybackLikelyToKeepUp ? @"YES" : @"NO");
        [self loadStateDidChange];
    }
    
    else if ([keyPath isEqualToString:playbackBufferEmpty]){
        
        BOOL isPlaybackBufferEmpty = playerItem.isPlaybackBufferEmpty;
        NSLog(@"KVO_AVPlayerItem_playbackBufferEmpty: %@", isPlaybackBufferEmpty ? @"YES" : @"NO");
        [self loadStateDidChange];
    }
    
    else if ([keyPath isEqualToString:playbackBufferFull]){
        
        NSLog(@"KVO_AVPlayerItem_playbackBufferFull: %@", playerItem.isPlaybackBufferFull ? @"YES" : @"NO");
        [self loadStateDidChange];
    }
    
    else if ([keyPath isEqualToString:rate]){
        if (self.player && !isFloatZero(self.player.rate)) {
            [self loadStateDidChange];
            [self playbackStateDidChange];
        }
    }
    else if ([keyPath isEqualToString:currentItem]){
        NSLog(@"[keyPath isEqualToString:current]");
    }
}


- (void)addPlayerItemObserver{
    [self.playerItemManager safeAddObserver:self forKeyPath:status options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItemManager safeAddObserver:self forKeyPath:loadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItemManager safeAddObserver:self forKeyPath:playbackLikelyToKeepUp options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItemManager safeAddObserver:self forKeyPath:playbackBufferEmpty options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItemManager safeAddObserver:self forKeyPath:playbackBufferFull options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 加载状态改变
- (void)loadStateDidChange{
    
    if (self.playToEnd) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:WTPlaybackLoadStateDidChangeNotification object:self];
    
}
#pragma mark - 播放状态改变
- (void)playbackStateDidChange{
    
    if (_playbackState != self.playbackState) {
        _playbackState = self.playbackState;
        [[NSNotificationCenter defaultCenter] postNotificationName:WTPlaybackPlayStateDidChangeNotification object:self];
    }
}

#pragma mark - 播放完成
- (void)playerItemDidPlayToEnd:(NSNotification *)notification{
    
    if (self.isShutdown) return;
    
    self.playToEnd = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"WTPlaybackPlayerItemDidPlayToEndTimeNotification");
        
        [self stateDidChange];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WTPlaybackPlayerItemDidPlayToEndTimeNotification object:self userInfo:@{WTPlaybackDidFinishReasonUserInfoKey:WTPlaybackPlayedEnd}];
        
    });
}

#pragma mark - FailedToPlayToEnd
- (void)playerItemFailedToPlayToEnd:(NSNotification *)notification{
    
    if (self.shutdown) return;
    
    [self onError:[notification.userInfo objectForKey:@"error"]];
}


#pragma mark - playedError
- (void)onError:(NSError *)error{
    _isError = YES;
    __block NSError * blockError = error;
    NSLog(@"playback -> error %@",error);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self stateDidChange];
        
        if (blockError == nil) {
            blockError = [[NSError alloc] init];
        }
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:WTPlaybackPlayerItemDidPlayToEndTimeNotification
         object:self userInfo:@{
                    WTPlaybackDidFinishReasonUserInfoKey: WTPlaybackPlayedError,
                    @"error": blockError
                    }];
    });
}

#pragma mark - seekToTime
- (void)seekToTime:(CGFloat)time completionHandler:(void (^)(BOOL))completionHandle{
    
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            
            [weakSelf.player play];
            if (completionHandle) {
                completionHandle(finished);
            }
            
        }];
    }
}

#pragma setter
- (void)setPlaybackMode:(WTPlaybackContentMode)playbackMode{
    
    switch (playbackMode) {
        case WTPlaybackContentModeNone:
            [self setContentMode:UIViewContentModeCenter];
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case WTPlaybackContentModeAspectFit:
            [self setContentMode:UIViewContentModeScaleAspectFit];
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case WTPlaybackContentModeAspectFill:
            [self setContentMode:UIViewContentModeScaleAspectFill];
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        case WTPlaybackContentModeFill:
            [self setContentMode:UIViewContentModeScaleToFill];
            self.playerLayer.videoGravity = AVLayerVideoGravityResize;
            break;
    }
    _playbackMode = playbackMode;
    
}

- (void)setPauseInBackground:(BOOL)pause{
    _pauseInBackground = pause;
}

#pragma mark - getter
- (WTPlaybackPlaybackState)playbackState{
    
    if (!self.player){
        return WTPlaybackPlaybackStateStopped;
    }
    else if (self.playToEnd){
        return WTPlaybackPlaybackStateStopped;
    }
    else if (self.isSeeking){
        return WTPlaybackPlaybackStateSeekingForward;
    }
    else if ([self isPlaying]){
        return WTPlaybackPlaybackStatePlaying;
    }
    else{
        return WTPlaybackPlaybackStatePaused;
    }
    
    return WTPlaybackPlaybackStateStopped;
}

- (NSTimeInterval)currentPlaybackTime{
    
    if (!self.player) {
        return 0.0f;
    }
    
    if (self.isSeeking) {
        return self.seekingTime;
    }
    
    return CMTimeGetSeconds([self.player currentTime]);
}

#pragma mark - settter
#pragma mark - playbackRate
- (void)setPlaybackRate:(float)playbackRate{
    
    _playbackRate = playbackRate;
    if (self.player && self.player.rate != playbackRate) {
        _player.rate = playbackRate;
    }
}


#pragma mark - playbackVolume
- (void)setPlaybackVolume:(float)playbackVolume{
    
    _playbackVolume = playbackVolume;
    if (self.player && self.player.volume != playbackVolume) {
        self.player.volume = playbackVolume;
    }
    BOOL muted = fabs(playbackVolume) < 1e-6;
    if (_player != nil && _player.muted != muted) {
        _player.muted = muted;
    }
    
}

- (void)setCurrentPlaybackTime:(NSTimeInterval)currentPlaybackTime{
    
    if (!self.player) return;
    self.seekingTime = currentPlaybackTime;
    self.isSeeking = YES;
    
    [self.player seekToTime:CMTimeMakeWithSeconds(currentPlaybackTime, NSEC_PER_SEC)
            toleranceBefore:kCMTimeZero
            toleranceAfter:kCMTimeZero
          completionHandler:^(BOOL finished) {
        self.isSeeking = NO;
        [self.player play];
    }];
}

#pragma mark - 设置播放的状态
- (WTPlaybackLoadState)loadState{
    
    if (!self.player) {
        return WTPlaybackLoadStateUnknown;
    }
    
    if (self.isSeeking) {
        return WTPlaybackLoadStateBuffing;
    }
    
    AVPlayerItem * playerItem = [self.player currentItem];
    if (!playerItem) return WTPlaybackLoadStateUnknown;
    
    if ([playerItem isPlaybackBufferEmpty]) {
        return WTPlaybackLoadStateBuffing;
    }
    else if (![playerItem isPlaybackLikelyToKeepUp]){
        return WTPlaybackLoadStateBuffing;
    }
    else if ([playerItem isPlaybackLikelyToKeepUp] || [playerItem isPlaybackBufferFull]){
        return WTPlaybackLoadStatePlayable;
    }
    else {
        return WTPlaybackLoadStateUnknown;
    }
}

- (UIImage *)thumbnailImageAtCurrentTime{
    
    AVAssetImageGenerator * imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.playAsset];
    CMTime expectedTime = self.playerItem.currentTime;
    CGImageRef cgImage = NULL;
    
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    cgImage = [imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
    
    if (!cgImage) {
        imageGenerator.requestedTimeToleranceBefore = kCMTimePositiveInfinity;
        imageGenerator.requestedTimeToleranceAfter = kCMTimePositiveInfinity;
        cgImage = [imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
    }
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    return image;
}

#pragma mark - app state changed
- (void)registerApplicationObservers{
    
    [_notificationManager addObserver:self selector:@selector(audioSessionInterrupt:) name:AVAudioSessionInterruptionNotification object:nil];
    
    [_notificationManager addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [_notificationManager addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [_notificationManager addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [_notificationManager addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [_notificationManager addObserver:self selector:@selector(applicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)unregisterApplicationObservers{
    
    [_notificationManager removeAllObservers:self];
}

- (void)audioSessionInterrupt:(NSNotification *)notification{
    
    int reason = [[[notification userInfo] valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
    switch (reason) {
        case AVAudioSessionInterruptionTypeBegan: {
            NSLog(@"audioSessionInterrupt: begin\n");
            switch (self.playbackState) {
                case WTPlaybackPlaybackStatePaused:
                case WTPlaybackPlaybackStateStopped:
                    _playingBeforeInterruption = NO;
                    break;
                default:
                    _playingBeforeInterruption = YES;
                    break;
            }
            [self pause];
            [[WTAudioSession sharedInstance] setActive:NO];
            break;
        }
        case AVAudioSessionInterruptionTypeEnded: {
            NSLog(@"audioSessionInterrupt: end\n");
            [[WTAudioSession sharedInstance] setActive:YES];
            if (_playingBeforeInterruption) {
                [self play];
            }
            break;
        }
    }
}

- (void)applicationWillEnterForeground{
    
    NSLog(@"applicationWillEnterForeground: %d\n", (int)[UIApplication sharedApplication].applicationState);
}

- (void)applicationDidBecomeActive{
    
    NSLog(@"applicationDidBecomeActive: %d\n", (int)[UIApplication sharedApplication].applicationState);
  
}

- (void)applicationWillResignActive{
    
    NSLog(@"applicationWillResignActive: %d\n", (int)[UIApplication sharedApplication].applicationState);
}

- (void)applicationDidEnterBackground{
    
    NSLog(@"applicationDidEnterBackground: %d\n", (int)[UIApplication sharedApplication].applicationState);
    if (_pauseInBackground) {
        [self pause];
    }
    
}

- (void)applicationWillTerminate
{
    NSLog(@"IJKAVMoviePlayerController:applicationWillTerminate: %d\n", (int)[UIApplication sharedApplication].applicationState);
}

- (void)stateDidChange{
    
    // 1.播放状态改变
    [self playbackStateDidChange];
    // 2.加载状态改变
    [self loadStateDidChange];
    // 3.开启锁屏
    [self setScreenOn:NO];
    
}
- (void)dealloc{
    NSLog(@"WTPlayback delloc");
    [self shutdown];
}
@end
