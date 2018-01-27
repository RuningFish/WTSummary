//
//  WTControlBottomView.m
//  123
//
//  Created by admin on 17/10/15.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTControlBottomView.h"

@interface WTControlBottomView ()

@end

@implementation WTControlBottomView

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self installSubviews];
        
    }
    return self;
}

- (void)installSubviews{
    
    /** 当前的播放时间 */
    UILabel * currentTime = [[UILabel alloc] init];
    self.currentTime = currentTime;
    [self addSubview:currentTime];
    currentTime.textColor = [UIColor whiteColor];
    currentTime.font = [UIFont systemFontOfSize:14];
    
    /** 视频的总时长 */
    UILabel * totalTime = [[UILabel alloc] init];
    self.totalTime = totalTime;
    [self addSubview:totalTime];
    totalTime.textColor = [UIColor whiteColor];
    totalTime.font = [UIFont systemFontOfSize:14];
    
    self.currentTime.textAlignment = NSTextAlignmentCenter;
    self.totalTime.textAlignment = NSTextAlignmentRight;
    
    /** 全屏按钮 */
    UIButton * fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fullScreenBtn = fullScreenBtn;
    [fullScreenBtn setImage:[UIImage imageNamed:WTPlaybackBundle(@"Fullscreen")] forState:UIControlStateNormal];
    [self addSubview:fullScreenBtn];
    fullScreenBtn.adjustsImageWhenHighlighted = NO;
    self.fullScreenBtn.selected = NO;
    [fullScreenBtn addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];

    WTCustomSlider * bottomSlider = [[WTCustomSlider alloc] init];
    self.bottomSlider = bottomSlider;
    [self addSubview:bottomSlider];
    bottomSlider.minimumValue = 0.0;
    bottomSlider.maximumValue = 1.0;
    bottomSlider.thumbBallSize = CGSizeMake(10, 10);
    bottomSlider.backProgressColor = [UIColor lightGrayColor];
    bottomSlider.playedProgressColor = [UIColor redColor];
    bottomSlider.bufferProgressColor = [UIColor whiteColor];
    [bottomSlider setThumbBallColor:[UIColor whiteColor]];
    
    [self addNotification];
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
        self.fullScreenBtn.selected = YES;
        [self.fullScreenBtn setImage:[UIImage imageNamed:WTPlaybackBundle(@"Fullscreen")] forState:UIControlStateNormal];
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.fullScreenBtn.selected = NO;
        [self.fullScreenBtn setImage:[UIImage imageNamed:WTPlaybackBundle(@"Fullscreen_exit")] forState:UIControlStateNormal];
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.fullScreenBtn.selected = NO;
        [self.fullScreenBtn setImage:[UIImage imageNamed:WTPlaybackBundle(@"Fullscreen_exit")] forState:UIControlStateNormal];
    }
    
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.offset(0);
        make.width.mas_equalTo(40);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.bottom.offset(0);
        make.width.mas_equalTo(self.fullScreenBtn.mas_width);
    }];
    
    [self.totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.right.mas_equalTo(self.fullScreenBtn.mas_left).offset(-10);
        make.width.mas_equalTo(self.currentTime.mas_width);
    }];
    
    [self.bottomSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTime.mas_right).offset(5);
        make.right.equalTo(self.totalTime.mas_left).offset(-5);
        make.top.bottom.offset(0);
    }];
    
}

- (void)fullScreenButtonClick{
    self.fullScreenBtn.selected = !self.fullScreenBtn.selected;
    if (self.fullScreenBlock) {
        self.fullScreenBlock(self.fullScreenBtn);
    }
}
@end
