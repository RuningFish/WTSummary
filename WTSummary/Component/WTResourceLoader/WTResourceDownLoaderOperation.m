//
//  WTResourceDownLoaderOperation.m
//  WTSummary
//
//  Created by piyingke on 2018/1/27.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTResourceDownLoaderOperation.h"
@interface WTResourceDownLoaderOperation ()<NSURLSessionDataDelegate,NSURLSessionTaskDelegate>
@property (nonatomic, strong, readwrite) NSURL * url;
@property (nonatomic, strong) NSURLSession * session;
@property (nonatomic, strong) NSURLSessionDataTask * dataTask;
@end
@implementation WTResourceDownLoaderOperation
- (instancetype)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        _url = url;
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        _dataTask = [_session dataTaskWithURL:self.url];
    }
    return self;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)main{
    [_dataTask resume];
}

- (void)cancel{
    if (_session) {
        [self.session invalidateAndCancel];
    }
}
- (void)setDownLoading:(BOOL)downLoading{
    _downLoading = downLoading;
}

#pragma mark - Session delegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    if ([self.delegate respondsToSelector:@selector(operation:didReceiveData:)]) {
        [self.delegate operation:self didReceiveData:data];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
    if ([self.delegate respondsToSelector:@selector(operation:didReceiveResponse:completionHandler:)]) {
        [self.delegate operation:self didReceiveResponse:response completionHandler:completionHandler];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    self.downLoading = NO;
    if ([self.delegate respondsToSelector:@selector(operation:didCompleteWithError:)]) {
        [self.delegate operation:self didCompleteWithError:error];
    }
//     NSLog(@"%s === %@",__func__,[NSDate date]);
}
@end
