//
//  WTPlaybackManager.h
//  123
//
//  Created by piyingke on 2017/10/11.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTPlaybackContainerView.h"
@interface WTPlaybackManager : NSObject
/** containterView */
@property (nonatomic, strong) WTPlaybackContainerView * containterView;
/** 记录当前播放的下标 */
@property (nonatomic, assign) NSInteger playIndex;

+ (instancetype)sharedManager;

- (void)setContentUrl:(NSString *)contentUrl;

- (void)prepareToPlay;
- (void)play;
- (void)pause;
- (void)shutdown;
- (BOOL)isPlaying;


@end
