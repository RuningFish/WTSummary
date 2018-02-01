//
//  WTResourceLoader.m
//  WTSummary
//
//  Created by piyingke on 2018/1/24.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTResourceLoader.h"
#import "WTResourceDownLoader.h"
#import "WTResourceCacheManager.h"
@interface WTResourceLoader ()<WTResourceDownLoaderDelegate>
@property (nonatomic, strong, readwrite) NSURL * url;
@property (nonatomic, strong) WTResourceDownLoader * resourceDownLoader;
@property (nonatomic, strong) NSMutableArray * requestWorkers;
@end
@implementation WTResourceLoader

- (instancetype)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        self.url = url;
        _requestWorkers = [NSMutableArray array];
        _resourceDownLoader = [[WTResourceDownLoader alloc] initWithURL:url];
        _resourceDownLoader.delegate = self;
    }
    return self;
}

- (void)addRequrest:(AVAssetResourceLoadingRequest *)request{
    [self startWorkerWithRequest:request];
    
}

- (void)removeRequest:(AVAssetResourceLoadingRequest *)request{
    [self.requestWorkers removeObject:request];
}

- (void)startWorkerWithRequest:(AVAssetResourceLoadingRequest *)request{
    [self.requestWorkers addObject:request];
    [self.resourceDownLoader start];
}

- (void)dealloc{
//     NSLog(@"%s",__func__);
}
- (void)resourceDownLoader:(WTResourceDownLoader *)downLoader didReceiveData:(NSData *)data{
    [self processPendingRequests];
}

- (void)resourceDownLoader:(WTResourceDownLoader *)downLoader didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    // 将文件的大小写入本地
     NSMutableDictionary * info = [[WTResourceCacheManager manager] resourceInfo];
     NSString * fileName = [[WTResourceCacheManager manager] fileNameWithURL:self.url];
     [info setValue:@(downLoader.info.contentLength) forKey:fileName];
     [[WTResourceCacheManager manager] saveResourceInfo:info];
}

- (void)resourceDownLoader:(WTResourceDownLoader *)downLoader didCompleteWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(resourceLoader:didCompleteWithError:)]) {
        [self.delegate resourceLoader:self didCompleteWithError:error];
    }
    if(!error){
        NSLog(@"缓存完成");
    }
}

- (void)processPendingRequests{
    NSString * path = [[WTResourceCacheManager manager] cachePathWithURL:self.url];
    NSError *error;
    NSData *tempVideoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path] options:NSDataReadingMappedIfSafe error:&error];
    if (!error) {
        NSMutableArray *requestsCompleted = [NSMutableArray array];
        @autoreleasepool {
            [self.requestWorkers enumerateObjectsUsingBlock:^(AVAssetResourceLoadingRequest *loadingRequest, NSUInteger idx, BOOL * _Nonnull stop) {
                [self fillInContentInformation:loadingRequest.contentInformationRequest];
                BOOL finished = [self respondWithDataForRequest:loadingRequest andTempVideoData:tempVideoData];
                if (finished) {
                    [requestsCompleted addObject:loadingRequest];
                    [loadingRequest finishLoading];
                }
            }];
        }
        if (requestsCompleted.count) {
            [self.requestWorkers removeObjectsInArray:[requestsCompleted copy]];
        }
    }
}

- (void)fillInContentInformation:(AVAssetResourceLoadingContentInformationRequest *)contentInformationRequest{
    contentInformationRequest.byteRangeAccessSupported = YES;
    contentInformationRequest.contentType = self.resourceDownLoader.info.contentType;
    contentInformationRequest.contentLength = self.resourceDownLoader.info.contentLength;
}

- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingRequest *)loadingRequest andTempVideoData:(NSData * _Nullable)tempVideoData{
    AVAssetResourceLoadingDataRequest *dataRequest = loadingRequest.dataRequest;
    NSUInteger startOffset = (NSUInteger)dataRequest.requestedOffset;
    if (dataRequest.currentOffset!=0) {
        startOffset = (NSUInteger)dataRequest.currentOffset;
    }
    startOffset = MAX(0, startOffset);
    // Don't have any data at all for this reques
    if (self.resourceDownLoader.info.downLoadLength<startOffset) {
        return NO;
    }
    NSUInteger unreadBytes = self.resourceDownLoader.info.downLoadLength - startOffset;
    unreadBytes = MAX(0, unreadBytes);
    NSUInteger numberOfBytesToRespondWith = MIN((NSUInteger)dataRequest.requestedLength, unreadBytes);
    NSRange respondRange = NSMakeRange(startOffset, numberOfBytesToRespondWith);
    if (tempVideoData.length>=numberOfBytesToRespondWith) {
        [dataRequest respondWithData:[tempVideoData subdataWithRange:respondRange]];
    }
    long long endOffset = startOffset + dataRequest.requestedLength;
    if (self.resourceDownLoader.info.downLoadLength >= endOffset) {
        return YES;
    }
    return NO;
}
@end
