//
//  WTPlaybackControlView.m
//
//  Created by piyingke on 2017/10/11.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTPlaybackControlView.h"
#import "Masonry.h"
#import "WTBrightnessView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WTPlaybackSeekingView.h"

typedef enum {
    UIViewPanMoveTypeHorizontal = 0,
    UIViewPanMoveTypeVertical
}UIViewPanMoveType;

@interface WTPlaybackControlView ()
@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;

/** 手势滑动的类型 */
@property (nonatomic, assign) UIViewPanMoveType moveType;
/** volumeSlider */
@property (nonatomic, strong) UISlider * volumeSlider;
/** 开始滑动的时间 */
@property (nonatomic, assign) CGFloat beginTime;

@end

@implementation WTPlaybackControlView

- (instancetype)init{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self installSubviews];
    }
    return self;
}

- (void)installSubviews{
    
    WTControlTopView * topView = [[WTControlTopView alloc] init];
    self.topView = topView;
    [self addSubview:topView];
    
    WTControlMiddleView * middleView = [[WTControlMiddleView alloc] init];
    self.middleView = middleView;
    [self addSubview:middleView];
    
    WTControlBottomView * bottomView = [[WTControlBottomView alloc] init];
    self.bottomView = bottomView;
    [self addSubview:bottomView];

    UITapGestureRecognizer * controlTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mediaControlTap:)];
    [self addGestureRecognizer:controlTap];
    
    WTCustomSlider * bottomSlider = [[WTCustomSlider alloc] init];
    [self addSubview:bottomSlider];
    bottomSlider.showThumbBall = NO;
    self.bottomSlider = bottomSlider;
    self.bottomSlider.backgroundColor = [UIColor clearColor];
    self.bottomSlider.playedProgressColor = [UIColor redColor];
    self.bottomSlider.bufferProgressColor = [UIColor lightGrayColor];
    
    self.topView.alpha = 0;
    self.middleView.alpha = 0;
    self.bottomView.alpha = 0;
    
    [self addNotification];
    
    MPVolumeView * volumeView = [[MPVolumeView alloc] init];
    
    // 如果不需要显示系统的音量调节 ，将下面代码打开
//    [self addSubview:volumeView];
//    volumeView.frame = CGRectMake(0, 0, 0, 0);
    
    self.volumeSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeSlider = (UISlider *)view;
            break;
        }
    }

}

- (void)addNotification{
    
    // 监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                     selector:@selector(onDeviceOrientationChange)
                                        name:UIDeviceOrientationDidChangeNotification
                                       object:nil];
}

- (void)onDeviceOrientationChange{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        [self removePanGesture];
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        [self addPanGesture];
    }
    
    self.topView.isFullscreen = interfaceOrientation == UIInterfaceOrientationPortrait?NO:YES;
    [self.topView layoutIfNeeded];
    [self layoutIfNeeded];
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIDeviceOrientationPortrait) {
        [self removePanGesture];
    }
    else{
        [self addPanGesture];
    }
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.right.offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.topView.mas_bottom).offset(0);
        make.bottom.equalTo(self.bottomView.mas_top).offset(0);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_equalTo(30);
    }];
    
    [self.bottomSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_equalTo(2);
    }];
    
}

- (void)setVideoInfo:(VideoInfo *)videoInfo{
    
    _videoInfo =videoInfo;
    self.topView.videoInfo = videoInfo;
    self.middleView.videoInfo = videoInfo;
    self.bottomView.totalTime.text = videoInfo.videoDuraton;
    
}

- (void)mediaControlTap:(UITapGestureRecognizer *)controlTap{
    
    if (!self.topView.alpha) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.topView.alpha = self.middleView.alpha = self.bottomView.alpha = 1.0;
            self.bottomSlider.hidden = YES;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(mediaControlHidden) withObject:nil afterDelay:5.0];
        }];
    }
    else{
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(mediaControlHidden) object:nil];
        [UIView animateWithDuration:0.25 animations:^{
            // 隐藏大进度条、暂停按钮
            self.topView.alpha = self.bottomView.alpha = self.middleView.alpha = 0.0;
        } completion:^(BOOL finished) {
            // 显示小进度条
            self.bottomSlider.hidden = NO;
        }];
    }

}

- (void)mediaControlHidden{
    
    self.topView.alpha = self.middleView.alpha = self.bottomView.alpha = 0.0;
    self.bottomSlider.hidden = NO;
}

- (void)cancelHidden{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(mediaControlHidden) object:nil];
}

#pragma mark - 添加滑动手势
- (void)addPanGesture{
    
    // 全屏给controlView添加调节亮度和音量的手势
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mediaControlViewPan:)];
    self.panGesture = panGesture;
    [self addGestureRecognizer:panGesture];
//    NSLog(@"添加手势");
}
#pragma mark - 去除滑动手势
- (void)removePanGesture{
    // 竖屏去掉手势
    [self removeGestureRecognizer:self.panGesture];
//    NSLog(@"去除手势");
}

// MARK :手势处理 音量／亮度／快进／快退
- (void)mediaControlViewPan:(UIPanGestureRecognizer *)panGesture{
    
    // location
    CGPoint locationPoint = [panGesture locationInView:panGesture.view];
    CGPoint velocityPoint = [panGesture velocityInView:panGesture.view];
    
    WTPlaybackSeekingView * seekingView = [WTPlaybackSeekingView seekingView];
    
    // 开始滑动
    if(panGesture.state == UIGestureRecognizerStateBegan){
        CGFloat x = fabs(velocityPoint.x);
        CGFloat y = fabs(velocityPoint.y);
        
        if (x > y) {
            self.moveType = UIViewPanMoveTypeHorizontal;
            NSLog(@"水平移动 === ");
            seekingView.currentTime = [WTPlaybackManager sharedManager].containterView.playbackView.currentPlaybackTime;
            seekingView.duration = [WTPlaybackManager sharedManager].containterView.playbackView.duration;
            [seekingView show];
            self.beginTime = seekingView.currentTime;
        }
        else if (x < y){
            self.moveType = UIViewPanMoveTypeVertical;
            NSLog(@"垂直移动 === ");
            if (locationPoint.x >= panGesture.view.frame.size.width/2) {
                [[WTBrightnessView sharedBrightnessView] dismissAtOnce];
                [[WTBrightnessView sharedBrightnessView] show];
            }
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged){
        if (self.moveType == UIViewPanMoveTypeVertical) {
            if (locationPoint.x <= panGesture.view.frame.size.width/2) {
                NSLog(@"屏幕的左半边 ");
                self.volumeSlider.value -= velocityPoint.y/10000;
            }
            else{
                NSLog(@"屏幕的右半边 ");
                [UIScreen mainScreen].brightness -= velocityPoint.y / 10000;
            }
        }
        else if (self.moveType == UIViewPanMoveTypeHorizontal){
            
            NSString * image = (velocityPoint.x < 0)?@"back_video@2x":@"forward_video@2x";
            
            [WTPlaybackSeekingView seekingView].seekingImageView.image = [UIImage imageNamed:WTPlaybackBundle(image)];
            
            self.beginTime += velocityPoint.x/66;
            if (self.beginTime <= 0) {
                self.beginTime = 0.0f;
            }
            else if (self.beginTime >= [WTPlaybackManager sharedManager].containterView.playbackView.duration){
                self.beginTime = [WTPlaybackManager sharedManager].containterView.playbackView.duration;
            }
            
            seekingView.currentTime = self.beginTime;
            NSLog(@"水平移动 %lf",self.beginTime);
        }
    }
    // 结束滑动
    else if (panGesture.state == UIGestureRecognizerStateEnded){
        
        // 水平
        if (self.moveType == UIViewPanMoveTypeHorizontal) {
            [[WTPlaybackSeekingView seekingView] remove];
//            NSLog(@"self.beginTime = %lf",self.beginTime);
            [[WTPlaybackManager sharedManager].containterView.playbackView seekToTime:self.beginTime completionHandler:nil];
            self.beginTime = 0.0f;
        }
        // 垂直
        else if (self.moveType == UIViewPanMoveTypeVertical){
            // 调节亮度
            if (locationPoint.x >= panGesture.view.frame.size.width/2) {
                [[WTBrightnessView sharedBrightnessView] dismissAtOnce];
            }
            else{
                
            }
        }
    }
    
}
@end
