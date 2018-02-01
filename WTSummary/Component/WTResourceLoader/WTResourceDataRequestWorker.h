//
//  WTResourceDataRequestWorker.h
//  WTSummary
//
//  Created by piyingke on 2018/1/24.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;
@class WTResourceDownLoader,WTResourceDataRequestWorker;
@protocol WTResourceDataRequestWorkerDelegate <NSObject>
- (void)resourceDataRequestWorker:(WTResourceDataRequestWorker *)requestWorker didCompleteWithError:(NSError *)error;
@end
@interface WTResourceDataRequestWorker : NSObject
@property (nonatomic, strong) WTResourceDownLoader * resourceDownLoader;
@property (nonatomic, strong, readonly) AVAssetResourceLoadingRequest * request;
@property (nonatomic, weak)  id<WTResourceDataRequestWorkerDelegate> delegate;

- (instancetype)initWithRequest:(AVAssetResourceLoadingRequest *)request resourceDownLoader:(WTResourceDownLoader *)resourceDownLoader;
- (void)start;
- (void)cancel;
- (void)finish;
@end
