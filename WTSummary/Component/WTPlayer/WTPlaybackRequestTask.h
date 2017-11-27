//
//  WTPlaybackRequestTask.h
//  123
//
//  Created by piyingke on 2017/11/4.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WTPlaybackRequestTask;
@protocol WTPlaybackRequestTaskDelegate <NSObject>

- (void)task:(WTPlaybackRequestTask *)task didReceiveVideoLength:(NSUInteger)ideoLength mimeType:(NSString *)mimeType;
- (void)didReceiveVideoDataWithTask:(WTPlaybackRequestTask *)task;
- (void)didFinishLoadingWithTask:(WTPlaybackRequestTask *)task;
- (void)didFailLoadingWithTask:(WTPlaybackRequestTask *)task WithError:(NSInteger )errorCode;

@end

@interface WTPlaybackRequestTask : NSObject

@property (nonatomic, strong, readonly) NSURL                      *url;
@property (nonatomic, readonly        ) NSUInteger                 offset;

@property (nonatomic, readonly        ) NSUInteger                 videoLength;
@property (nonatomic, readonly        ) NSUInteger                 downLoadingOffset;
@property (nonatomic, strong, readonly) NSString                   * mimeType;
@property (nonatomic, assign)           BOOL                       isFinishLoad;

@property (nonatomic, weak            ) id <WTPlaybackRequestTaskDelegate> delegate;


- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset;

- (void)cancel;

- (void)continueLoading;

- (void)clearData;

@end
