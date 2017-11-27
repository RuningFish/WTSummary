//
//  WTPlaybackContainerView.h
//  
//
//  Created by piyingke on 2017/10/11.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTPlaybackBottomView.h"
#import "WTPlaybackControlView.h"
#import "WTPlaybackView.h"

@interface WTPlaybackContainerView : UIView

- (instancetype)initWithContentUrl:(NSString *)url;

- (void)prepareToPlay;
- (void)play;
- (void)pause;
- (void)shutdown;
- (BOOL)isPlaying;

/** videoInfo */
@property (nonatomic, strong) VideoInfo  * videoInfo;

@property (nonatomic, strong) WTPlaybackView      * playbackView;
@property (nonatomic, strong) WTPlaybackBottomView * bottomView;
@property (nonatomic, strong) WTPlaybackControlView * mediaControlView;
@end
