//
//  WTControlMiddleView.m
//  123
//
//  Created by admin on 17/10/16.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTControlMiddleView.h"

@interface WTControlMiddleView ()

@property (nonatomic, strong) UIButton * playOrPause;

@end
static CGFloat playOrPauseH = 45.0f;

@implementation WTControlMiddleView

- (instancetype)init{
    
    if (self = [super init]) {
        
        UIButton * playOrPause = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playOrPause = playOrPause;
        [self addSubview:playOrPause];
        [playOrPause setImage:[UIImage imageNamed:WTPlaybackBundle(@"PauseDown@2x")] forState:UIControlStateNormal];
        playOrPause.layer.cornerRadius = playOrPauseH*0.5;
        playOrPause.layer.masksToBounds = YES;
        playOrPause.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
        playOrPause.layer.borderWidth = 1.0;
        [playOrPause addTarget:self action:@selector(playOrPauseClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.playOrPause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.offset(0);
        make.width.height.mas_equalTo(playOrPauseH);
    }];
}

- (void)playOrPauseClick{
    
    // 0.取消隐藏
    SEL cancelHidden = NSSelectorFromString(@"mediaControlHidden");
    [NSObject cancelPreviousPerformRequestsWithTarget:self.superview selector:cancelHidden object:nil];
    
    // 1.改变暂停、播放
    WTPlaybackManager * playerManager = [WTPlaybackManager sharedManager];
    if (playerManager.containterView.playbackView.playbackState == WTPlaybackPlaybackStatePlaying) {
        [playerManager pause];
        [self.playOrPause setImage:[UIImage imageNamed:WTPlaybackBundle(@"playMiniNormal@2x")] forState:UIControlStateNormal];
    }
    else if (playerManager.containterView.playbackView.playbackState == WTPlaybackPlaybackStatePaused){
        [playerManager play];
        [self.playOrPause setImage:[UIImage imageNamed:WTPlaybackBundle(@"PauseDown@2x")] forState:UIControlStateNormal];
        // 2.隐藏
        [self.superview performSelector:cancelHidden withObject:nil afterDelay:3.0];
    }
    
   
}
@end
