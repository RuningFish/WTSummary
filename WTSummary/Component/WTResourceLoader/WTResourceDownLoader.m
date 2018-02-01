//
//  WTResourceDownLoader.m
//  WTSummary
//
//  Created by piyingke on 2018/1/24.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTResourceDownLoader.h"
#import "WTResourceCacheManager.h"
#import "WTResourceDownLoaderOperation.h"
@implementation WTResourceInfo
@end
@interface WTResourceDownLoader ()<WTResourceDownLoaderOperationDelegate>
@property (nonatomic, strong, readwrite) NSURL * url;
@property (nonatomic, strong) NSOutputStream * outputStream;
@property (nonatomic, strong) WTResourceCacheManager * cacheManager;
@property (nonatomic, strong ,readwrite) WTResourceInfo * info;
@property (nonatomic, strong) NSOperationQueue * downLoadQueue;
@property (nonatomic, strong) WTResourceDownLoaderOperation * operation;
@end

@implementation WTResourceDownLoader
- (instancetype)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        self.url = url;
        _cacheManager = [WTResourceCacheManager manager];
        _downLoadQueue = [[NSOperationQueue alloc] init];
        _downLoadQueue.name = @"WTPlaybackDownLoaderQueue";
        _downLoadQueue.maxConcurrentOperationCount = 1;
        _outputStream = [[NSOutputStream alloc] initToFileAtPath:[_cacheManager cachePathWithURL:url] append:YES];
        [_outputStream open];
        _operation = [[WTResourceDownLoaderOperation alloc] initWithURL:url];
        _operation.delegate = self;
    }
    return self;
}
- (void)dealloc{
//    NSLog(@"%s",__func__);
}

- (void)start{
    if (!self.operation.downLoading) {
        [self.downLoadQueue addOperation:self.operation];
        self.operation.downLoading = YES;
    }
}

#pragma mark - WTResourceDownLoaderOperationDelegate
- (void)operation:(WTResourceDownLoaderOperation *)operation didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
    NSDictionary * headers = urlResponse.allHeaderFields;
    if (urlResponse.statusCode == 200) {
        if (!self.info) {
            self.info = [[WTResourceInfo alloc] init];
            self.info.contentType = [headers valueForKey:@"Content-Type"];
            self.info.contentLength = [[headers valueForKey:@"Content-Length"] integerValue];
        }
    }
    if ([self.delegate respondsToSelector:@selector(resourceDownLoader:didReceiveResponse:completionHandler:)]) {
        [self.delegate resourceDownLoader:self didReceiveResponse:response completionHandler:completionHandler];
    }
}

- (void)operation:(WTResourceDownLoaderOperation *)operation didReceiveData:(NSData *)data{
    [self.outputStream write:data.bytes maxLength:data.length];
    self.info.downLoadLength += data.length;
    if ([self.delegate respondsToSelector:@selector(resourceDownLoader:didReceiveData:)]) {
        [self.delegate resourceDownLoader:self didReceiveData:data];
    }
}

- (void)operation:(WTResourceDownLoaderOperation *)operation didCompleteWithError:(NSError *)error{
    [self.outputStream close];
    if ([self.delegate respondsToSelector:@selector(resourceDownLoader:didCompleteWithError:)]) {
        [self.delegate resourceDownLoader:self didCompleteWithError:error];
    }
}
@end
