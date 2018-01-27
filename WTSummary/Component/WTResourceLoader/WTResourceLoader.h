//
//  WTResourceLoader.h
//  WTSummary
//
//  Created by piyingke on 2018/1/24.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;
@class WTResourceLoader;
@protocol WTResourceLoaderDelegate <NSObject>
- (void)resourceLoader:(WTResourceLoader *)loader didCompleteWithError:(NSError *)error;
@end
@interface WTResourceLoader : NSObject
@property (nonatomic, strong, readonly) NSURL * url;
@property (nonatomic, weak) id<WTResourceLoaderDelegate> delegate;
- (instancetype)initWithURL:(NSURL *)url;

- (void)addRequrest:(AVAssetResourceLoadingRequest *)request;
- (void)removeRequest:(AVAssetResourceLoadingRequest *)request;

@end
