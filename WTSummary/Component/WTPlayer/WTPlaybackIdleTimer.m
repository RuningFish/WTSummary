//
//  WTPlaybackIdleTimer.m
//  123
//
//  Created by piyingke on 2017/10/10.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTPlaybackIdleTimer.h"
#import <UIKit/UIKit.h>

@implementation WTPlaybackIdleTimer

+ (instancetype)sharedIdleTimer{
    
    static WTPlaybackIdleTimer * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WTPlaybackIdleTimer alloc] init];
    });
    return instance;
}

- (void)setAppIdleTimerDisabled:(BOOL)appIdleTimerDisabled{
    
    _appIdleTimerDisabled = appIdleTimerDisabled;
    
    [self updateIdleTimer];
}

- (void)updateIdleTimer{

    [UIApplication sharedApplication].idleTimerDisabled = self.appIdleTimerDisabled;
}
@end
