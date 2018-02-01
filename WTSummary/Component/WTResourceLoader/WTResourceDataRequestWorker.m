//
//  WTResourceDataRequestWorker.m
//  WTSummary
//
//  Created by piyingke on 2018/1/24.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTResourceDataRequestWorker.h"
#import "WTResourceDownLoader.h"
#import "WTResourceCacheManager.h"
@interface WTResourceDataRequestWorker ()<WTResourceDownLoaderDelegate>
@property (nonatomic, strong, readwrite) AVAssetResourceLoadingRequest * request;
@end
@implementation WTResourceDataRequestWorker

- (instancetype)initWithRequest:(AVAssetResourceLoadingRequest *)request resourceDownLoader:(WTResourceDownLoader *)resourceDownLoader{
    if (self = [super init]) {
        self.request = request;
        self.resourceDownLoader = resourceDownLoader;
        self.resourceDownLoader.delegate = self;
//        [self fillContentInfo];
    }
    return self;
}

- (void)start{
    AVAssetResourceLoadingDataRequest * dataRequest = self.request.dataRequest;
    long long offset = dataRequest.requestedOffset;
    NSInteger length = dataRequest.requestedLength;
    if (dataRequest.currentOffset != 0) {
        offset = dataRequest.currentOffset;
    }
    
    BOOL end = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        if (dataRequest.requestsAllDataToEndOfResource) {
            end = YES;
        }
    }
    
    [self.resourceDownLoader downLoadFromOffset:offset length:length toEnd:end];
    NSLog(@"%s",__func__);
}

- (void)cancel{
    NSLog(@"%s",__func__);
}

- (void)dealloc{
     NSLog(@"%s",__func__);
}

- (void)finish{
//    if (!self.request.isFinished) {
        NSError * error = [[NSError alloc] initWithDomain:@"com.resourceloader"
                                                     code:-3
                                                 userInfo:@{NSLocalizedDescriptionKey:@"Resource loader cancelled"}];
        [self.request finishLoadingWithError:error];
        NSLog(@"%s",__func__);
//    }
}

//- (void)setResourceDownLoader:(WTResourceDownLoader *)resourceDownLoader{
//    
//     resourceDownLoader.delegate = self;
//    _resourceDownLoader = resourceDownLoader;
//}

- (void)resourceDownLoader:(WTResourceDownLoader *)downLoader didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSLog(@"%s",__func__);
    [self fillContentInfo];
}

- (void)resourceDownLoader:(WTResourceDownLoader *)downLoader didReceiveData:(NSData *)data{
    NSLog(@"%s",__func__);
    [self.request.dataRequest respondWithData:data];

}

- (void)resourceDownLoader:(WTResourceDownLoader *)downLoader didCompleteWithError:(NSError *)error{
    NSLog(@"%s",__func__);
    if (!error) {
        [self.request finishLoading];
    }
    else{
        [self.request finishLoadingWithError:error];
    }
    
    if ([self.delegate respondsToSelector:@selector(resourceDataRequestWorker:didCompleteWithError:)]) {
        [self.delegate resourceDataRequestWorker:self didCompleteWithError:error];
    }
}

- (void)fillContentInfo{
    AVAssetResourceLoadingContentInformationRequest * content = self.request.contentInformationRequest;
    content.contentType = self.resourceDownLoader.info.contentType;
    content.contentLength = self.resourceDownLoader.info.contentLength;
    content.byteRangeAccessSupported = YES;
    NSLog(@"contentType - (%@) , contentLength (%lld) %@ f ",self.resourceDownLoader.info.contentType,self.resourceDownLoader.info.contentLength,self.resourceDownLoader);
}

@end
