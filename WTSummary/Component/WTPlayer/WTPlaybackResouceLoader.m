//
//  WTPlaybackResouceLoader.m
//  123
//
//  Created by piyingke on 2017/11/3.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTPlaybackResouceLoader.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WTPlaybackRequestTask.h"
#import "WTPlaybackDownLoader.h"
@interface WTPlaybackResouceLoader ()<WTPlaybackRequestTaskDelegate,WTPlaybackDownLoaderDelegate>
@property (nonatomic, strong, nullable) NSMutableArray * loadingRequests;

@property (nonatomic, assign) NSUInteger expectedSize;

@property (nonatomic, assign) NSUInteger receivedSize;

@property (nonatomic, copy) NSString * videoPath;

@property (nonatomic, strong) AVAssetResourceLoadingRequest * loadingRequest;
@end

static NSString *JPVideoPlayerMimeType = @"video/mp4";

@implementation WTPlaybackResouceLoader

- (instancetype)init{
    if (self = [super init]) {
        _loadingRequests = [NSMutableArray array];
    }
    return self;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    if (resourceLoader && loadingRequest) {
        self.loadingRequest = loadingRequest;
        [self.loadingRequests addObject:loadingRequest];
        NSLog(@"shouldWaitForLoadingOfRequestedResource === %@",loadingRequest);
        [self dealWithLoadingRequest:loadingRequest];
//    <AVAssetResourceLoadingRequest: 0x145537130, URL request = <NSMutableURLRequest: 0x145537190> { URL: WTPlayback://flv1.bn.netease.com/videolib3/1708/21/epDOJ5082/SD/epDOJ5082-mobile.mp4 }, request ID = 4, content information request = (null), data request = <AVAssetResourceLoadingDataRequest: 0x1455362b0, requested offset = 0, requested length = 1279651, requests all data to end of resource = YES, current offset = 0>>
//
//    <AVAssetResourceLoadingRequest: 0x14550cb70, URL request = <NSMutableURLRequest: 0x14550cb30> { URL: WTPlayback://flv1.bn.netease.com/videolib3/1708/21/epDOJ5082/SD/epDOJ5082-mobile.mp4 }, request ID = 6, content information request = (null), data request = <AVAssetResourceLoadingDataRequest: 0x14550d5f0, requested offset = 36654, requested length = 1242997, requests all data to end of resource = YES, current offset = 36654>>
    }
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(nonnull AVAssetResourceLoadingRequest *)loadingRequest{
    
    NSLog(@"didCancelLoadingRequest");
//    [self.loadingRequests removeObject:loadingRequest];
}


//- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingRequest *)loadingRequest andTempVideoData:(NSData * _Nullable)tempVideoData{
//
//    // Thanks for @DrunkenMouse(http://www.jianshu.com/users/5d853d21f7da/latest_articles) submmit a bug that my mistake of calculate "endOffset".
//    // Thanks for Nick Xu Mark.
//
//    AVAssetResourceLoadingDataRequest *dataRequest = loadingRequest.dataRequest;
//
//    NSUInteger startOffset = (NSUInteger)dataRequest.requestedOffset;
//    if (dataRequest.currentOffset!=0) {
//        startOffset = (NSUInteger)dataRequest.currentOffset;
//    }
//    startOffset = MAX(0, startOffset);
//
//    // Don't have any data at all for this reques
//    if (self.downLoader.downLoadLength<startOffset) {
//        return NO;
//    }
//
//    NSUInteger unreadBytes = self.downLoader.downLoadLength - startOffset;
//    unreadBytes = MAX(0, unreadBytes);
//    NSUInteger numberOfBytesToRespondWith = MIN((NSUInteger)dataRequest.requestedLength, unreadBytes);
//    NSRange respondRange = NSMakeRange(startOffset, numberOfBytesToRespondWith);
//    if (tempVideoData.length>=numberOfBytesToRespondWith) {
//        [dataRequest respondWithData:[tempVideoData subdataWithRange:respondRange]];
//    }
//
//    long long endOffset = startOffset + dataRequest.requestedLength;
//
//    // if the received data greater than the requestLength.
//    if (self.downLoader.downLoadLength >= endOffset) {
//        return YES;
//    }
//    // if the received data less than the requestLength.
//    return NO;
//}

- (void)dealWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    NSURL *interceptedURL = [loadingRequest.request URL];
    NSRange range = NSMakeRange((NSUInteger)loadingRequest.dataRequest.currentOffset, NSUIntegerMax);
    
    if (self.downLoader.downLoadLength > 0) {
        [self processPendingRequests];
    }
    
    if (!self.downLoader) {
//        self.task = [[WTPlaybackRequestTask alloc] init];
//        self.task.delegate = self;
//        [self.task setUrl:interceptedURL offset:0];
        
        self.downLoader = [[WTPlaybackDownLoader alloc] init];
        self.downLoader.delegate = self;
        [self.downLoader setDownLoadUrl:interceptedURL offset:0];
        
    }
//    else {
//        // 如果新的rang的起始位置比当前缓存的位置还大300k，则重新按照range请求数据
//        if (self.downLoader.offset + self.downLoader.downLoadLength + 1024 * 300 < range.location ||
//            // 如果往回拖也重新请求
//            range.location < self.downLoader.offset) {
////            [self.downLoader setUrl:interceptedURL offset:range.location];
//             [self.downLoader setDownLoadUrl:interceptedURL offset:range.location];
//        }
//    }
    
    
}

- (void)processPendingRequests
{
    NSMutableArray *requestsCompleted = [NSMutableArray array];  //请求完成的数组
    //每次下载一块数据都是一次请求，把这些请求放到数组，遍历数组
    [self.loadingRequests enumerateObjectsUsingBlock:^(AVAssetResourceLoadingRequest *loadingRequest, NSUInteger idx, BOOL * _Nonnull stop) {
        [self fillInContentInformation:loadingRequest.contentInformationRequest]; //对每次请求加上长度，文件类型等信息
        
        BOOL didRespondCompletely = [self respondWithDataForRequest:loadingRequest.dataRequest]; //判断此次请求的数据是否处理完全
        if (didRespondCompletely) {
            
            [requestsCompleted addObject:loadingRequest];  //如果完整，把此次请求放进 请求完成的数组
            [loadingRequest finishLoading];
            NSLog(@"8888888888888");
            
        }
    }];
    
    [self.loadingRequests removeObjectsInArray:requestsCompleted];   //在所有请求的数组中移除已经完成的
    
}

- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingDataRequest *)dataRequest
{
    long long startOffset = dataRequest.requestedOffset;
    
    if (dataRequest.currentOffset != 0) {
        startOffset = dataRequest.currentOffset;
    }
    
    if ((self.downLoader.offset +self.downLoader.downLoadLength) < startOffset)
    {
        NSLog(@"< startOffset");
        return NO;
    }
    
    if (startOffset < self.downLoader.offset) {
        NSLog(@"self.downLoader.offset");
        return NO;
    }
    
    NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:_videoPath] options:NSDataReadingMappedIfSafe error:nil];
    
    // This is the total data we have from startOffset to whatever has been downloaded so far
    NSUInteger unreadBytes = self.downLoader.downLoadLength - ((NSInteger)startOffset - self.downLoader.offset);
    
    // Respond with whatever is available if we can't satisfy the request fully yet
    NSUInteger numberOfBytesToRespondWith = MIN((NSUInteger)dataRequest.requestedLength, unreadBytes);
    
    NSLog(@"self.task.offset === %ld , %ld",self.downLoader.offset,self.downLoader.downLoadLength);
    [dataRequest respondWithData:[filedata subdataWithRange:NSMakeRange((NSUInteger)startOffset- self.downLoader.offset, (NSUInteger)numberOfBytesToRespondWith)]];
    
    
    
    long long endOffset = startOffset + dataRequest.requestedLength;
    BOOL didRespondFully = (self.downLoader.offset + self.downLoader.downLoadLength) >= endOffset;
    
    return didRespondFully;
    
    
}

- (void)fillInContentInformation:(AVAssetResourceLoadingContentInformationRequest *)contentInformationRequest
{
    NSString *mimeType = self.downLoader.mimeType;
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(mimeType), NULL);
    contentInformationRequest.byteRangeAccessSupported = YES;
    contentInformationRequest.contentType = CFBridgingRelease(contentType);
    contentInformationRequest.contentLength = self.downLoader.contentLength;
}


- (void)didReceiveVideoDataWithTask:(WTPlaybackRequestTask *)task
{
    [self processPendingRequests];
    
}

#pragma mark - WTPlaybackDownLoaderDelegate
- (void)downLoader:(WTPlaybackDownLoader *)downLoader didReceiveData:(NSData *)data{
    
    if (!self.videoPath) {
        self.videoPath = downLoader.downLoadPath;
    }
//    [self.loadingRequest.dataRequest respondWithData:data];
    NSLog(@"didReceiveData");
      [self processPendingRequests];
}
@end
