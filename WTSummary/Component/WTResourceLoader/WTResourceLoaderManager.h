//
//  WTResourceLoaderManager.h
//  WTSummary
//
//  Created by piyingke on 2018/1/24.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;
@interface WTResourceLoaderManager : NSObject <AVAssetResourceLoaderDelegate>
+ (instancetype)manager;
- (NSURL *)resourceLoaderURL:(NSURL *)url;
- (AVURLAsset *)assetWithURL:(NSURL *)url;
@end
