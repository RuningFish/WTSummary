
//
//  WTPlaybackDownLoader.m
//  123
//
//  Created by piyingke on 2017/11/6.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTPlaybackDownLoader.h"
#import <CommonCrypto/CommonDigest.h>
/** 视频的缓存文件夹 */
#define VideoCachePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WTPlaybackVideo"]

@interface WTPlaybackDownLoader ()<NSURLSessionDataDelegate,NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSOutputStream * outputStream;
@end
@implementation WTPlaybackDownLoader

- (void)setDownLoadUrl:(NSURL *)downLoadUrl offset:(NSInteger)offset{
    
    _offset = offset;
    if ([downLoadUrl.scheme isEqualToString:@"WTPlayback"]) {
        NSURLComponents * components = [[NSURLComponents alloc] initWithURL:downLoadUrl resolvingAgainstBaseURL:YES];
        components.scheme = @"http";
        self.downLoadUrl = [components URL];
    }
    
    WTPlaybackFileManager * fileManager = [WTPlaybackFileManager fileManager];
    self.downLoadPath = [fileManager cachePathForUrl:downLoadUrl];

    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:self.downLoadUrl];
    self.outputStream = [[NSOutputStream alloc] initToFileAtPath:self.downLoadPath append:YES];
    [self.outputStream open];
    [dataTask resume];
    
    NSLog(@"setDownLoadUrl:offset");
}


#pragma mark - delegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    [self.outputStream write:data.bytes maxLength:data.length];
    self.downLoadLength += data.length;
    if ([self.delegate respondsToSelector:@selector(downLoader:didReceiveData:)]) {
        [self.delegate downLoader:self didReceiveData:data];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    
    NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
    NSDictionary * headers = urlResponse.allHeaderFields;
    if (urlResponse.statusCode == 200) {
        
        self.mimeType = [headers valueForKey:@"Content-Type"];
        self.contentLength = [[headers valueForKey:@"Content-Length"] integerValue];
    }
    NSLog(@"downLoad -> finish  %@ %@",urlResponse.allHeaderFields,[headers valueForKey:@"Content-Length"]);
//    NSDictionary * header = [];
        if (completionHandler) {
            completionHandler(NSURLSessionResponseAllow);
        }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    if (error) {
        NSLog(@"下载出错 === %@",error);
    }
    else{
        NSLog(@"下载完成");
    }
    
    if ([self.delegate respondsToSelector:@selector(downLoader:didCompleteWithError:)]) {
        [self.delegate downLoader:self didCompleteWithError:error];
    }
}

@end

@implementation WTPlaybackFileManager

+ (instancetype)fileManager{
    return [[WTPlaybackFileManager alloc] init];
}

- (NSString *)cachePathForUrl:(NSURL *)url{
    
    if (![self fileExistsAtPath:VideoCachePath]) {
        [self createDirectoryAtPath:VideoCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * cacheString = [NSString stringWithFormat:@"%@%@",url.host,url.relativePath];
    NSString * path = [VideoCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[self MD5:cacheString],url.absoluteString.pathExtension]];
    NSLog(@"视频缓存的路径 === %@",path);
    return path;
}

- (NSString *)MD5:(NSString *)input{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

- (void)cacheFileForURL:(NSURL *)url completionHandle:(void (^)(BOOL hasCached,NSString * fileUrl))completionHandler{
    if (url) {
      NSString * cachePath = [NSString stringWithFormat:@"%@.%@",[self MD5:[NSString stringWithFormat:@"%@%@",url.host,url.relativePath]],url.absoluteString.pathExtension];
      NSArray * contents = [self contentsOfDirectoryAtPath:VideoCachePath error:nil];
        [contents enumerateObjectsUsingBlock:^(NSString * fileName, NSUInteger index, BOOL * _Nonnull stop) {
            if ([cachePath isEqualToString:fileName]) {
                *stop = YES;
                NSString * filePath = [VideoCachePath stringByAppendingPathComponent:fileName];
                completionHandler(YES,filePath);
            }
            if (index == contents.count - 1 && ![fileName isEqualToString:cachePath]) {
                completionHandler(NO,nil);
            }
        }];
    }
}
@end
