//
//  WTResourceLoaderManager.m
//  WTSummary
//
//  Created by piyingke on 2018/1/24.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTResourceLoaderManager.h"
#import "WTResourceLoader.h"
static NSString * KResourcePrefix = @"__WTPlayback__";
@interface WTResourceLoaderManager ()<WTResourceLoaderDelegate>
/** 下载对象的容器 */
@property (nonatomic, strong) NSMutableDictionary * resourceLoaders;
@end

@implementation WTResourceLoaderManager

- (NSMutableDictionary *)resourceLoaders{
    if (!_resourceLoaders) {
        _resourceLoaders = [NSMutableDictionary dictionary];
    }
    return _resourceLoaders;
}

+ (instancetype)manager{
    static WTResourceLoaderManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       manager = [[WTResourceLoaderManager alloc] init];
    });
    return manager;
}

#pragma mark - AVAssetResourceLoaderDelegate
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{
//    NSLog(@"shouldWait %@  ",loadingRequest);
//     NSLog(@"%s === %@",__func__,[NSDate date]);
    NSURL * requestURL = [loadingRequest.request URL];
    if ([requestURL.absoluteString hasPrefix:KResourcePrefix]) {
        WTResourceLoader * loader = [self resourceLoaderForURL:requestURL];
        if (!loader) {
            NSString * requestString = [requestURL.absoluteString stringByReplacingOccurrencesOfString:KResourcePrefix withString:@""];
            NSURL * resourceURL = [NSURL URLWithString:requestString];
            loader = [[WTResourceLoader alloc] initWithURL:resourceURL];
            self.resourceLoaders[requestURL.absoluteString] = loader;
            loader.delegate = self;
        }
        [loader addRequrest:loadingRequest];
        return YES;
    }
    return NO;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    NSURL * requestURL = [loadingRequest.request URL];
    WTResourceLoader * loader = [self resourceLoaderForURL:requestURL];
    [loader removeRequest:loadingRequest];
}

#pragma mark - WTResourceLoaderDelegate
- (void)resourceLoader:(WTResourceLoader *)loader didCompleteWithError:(NSError *)error{
    __block NSString * loaderKey = nil;
    [self.resourceLoaders enumerateKeysAndObjectsUsingBlock:^(NSString * key, WTResourceLoader * obj, BOOL * _Nonnull stop) {
        if (loader == obj) {
            loaderKey = key;
            *stop = YES;
        }
    }];
    [self.resourceLoaders removeObjectForKey:loaderKey];
}

- (WTResourceLoader *)resourceLoaderForURL:(NSURL *)requestURL{
    NSString * resourceKey = requestURL.absoluteString;
    WTResourceLoader * resourceLoader = self.resourceLoaders[resourceKey];
    return resourceLoader;
}

- (NSURL *)resourceLoaderURL:(NSURL *)url{
    if (!url) {
        NSLog(@"url is nil");
        return nil;
    }
   return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KResourcePrefix,url.absoluteString]];
}

- (AVURLAsset *)assetWithURL:(NSURL *)url{
    if (!url) {
        NSLog(@"url is nil");
        return nil;
    }
    NSURL * assetURL = url;
    if (![assetURL.absoluteString hasPrefix:KResourcePrefix]) {
        assetURL = [self resourceLoaderURL:url];
    }
    AVURLAsset * asset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    [asset.resourceLoader setDelegate:self queue:dispatch_get_main_queue()];
    return asset;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
