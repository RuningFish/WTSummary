//
//  WTPlaybackIdleTimer.h
//  123
//
//  Created by piyingke on 2017/10/10.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTPlaybackIdleTimer : NSObject

+ (instancetype)sharedIdleTimer;

@property (nonatomic, assign) BOOL appIdleTimerDisabled;
//@property (nonatomic, assign) BOOL appIdleTimerDisabled;

@end
