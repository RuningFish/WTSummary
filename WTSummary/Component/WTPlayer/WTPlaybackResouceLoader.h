//
//  WTPlaybackResouceLoader.h
//  123
//
//  Created by piyingke on 2017/11/3.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "WTPlaybackDownLoader.h"
@class WTPlaybackRequestTask;

@interface WTPlaybackResouceLoader : NSObject<AVAssetResourceLoaderDelegate>
/** request */
@property(nonatomic, copy) NSString * request;
/** task */
@property (nonatomic, strong) WTPlaybackRequestTask * task;
/** task */
@property (nonatomic, strong) WTPlaybackDownLoader * downLoader;
@end
