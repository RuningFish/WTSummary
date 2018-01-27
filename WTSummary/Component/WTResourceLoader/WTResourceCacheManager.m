//
//  WTResourceCacheManager.m
//  WTSummary
//
//  Created by piyingke on 2018/1/24.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTResourceCacheManager.h"
#import <CommonCrypto/CommonDigest.h>
@interface WTResourceCacheManager ()
@property (nonatomic, strong) NSFileManager * fileManager;
@property (nonatomic, copy) NSString * resourcePath;
@end

@implementation WTResourceCacheManager
+ (instancetype)manager{
    static WTResourceCacheManager * cacheManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheManager = [[self alloc] init];
        cacheManager.fileManager = [NSFileManager defaultManager];
    });
    return cacheManager;
}

- (NSString *)resourcePath{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WTPlaybackResource"];
}

- (NSString *)cachePathWithURL:(NSURL *)url{
    if (![self.fileManager fileExistsAtPath:self.resourcePath]) {
        [self.fileManager createDirectoryAtPath:self.resourcePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * cachePath = [self.resourcePath stringByAppendingPathComponent:[self fileNameWithURL:url]];
    return cachePath;
}

- (NSString *)fileNameWithURL:(NSURL *)url{
    NSString * md5 = [self MD5:url.absoluteString];
    return [NSString stringWithFormat:@"%@.%@",md5,url.absoluteString.pathExtension];
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
        NSString * cachePath = [self fileNameWithURL:url];
        NSArray * contents = [self.fileManager contentsOfDirectoryAtPath:self.resourcePath error:nil];
        [contents enumerateObjectsUsingBlock:^(NSString * fileName, NSUInteger index, BOOL * _Nonnull stop) {
            if ([cachePath isEqualToString:fileName]) {
                *stop = YES;
                NSString * filePath = [self.resourcePath stringByAppendingPathComponent:fileName];
                completionHandler(YES,filePath);
            }
            if (index == contents.count - 1 && ![fileName isEqualToString:cachePath]) {
                completionHandler(NO,nil);
            }
        }];
    }
}

- (void)cleanAllCache{
    [self.fileManager removeItemAtPath:self.resourcePath error:nil];
}

- (void)cleanCacheWithURL:(NSURL *)url{
    if (url) {
        NSString * cachePath = [self fileNameWithURL:url];
        NSArray * contents = [self.fileManager contentsOfDirectoryAtPath:self.resourcePath error:nil];
        [contents enumerateObjectsUsingBlock:^(NSString * fileName, NSUInteger index, BOOL * _Nonnull stop) {
            if ([cachePath isEqualToString:fileName]) {
                *stop = YES;
                NSString * filePath = [self.resourcePath stringByAppendingPathComponent:fileName];
                [self.fileManager removeItemAtPath:filePath error:nil];
            }
        }];
    }
}

+ (void)calculateCachedResourceSizeWithCompletionHandle:(void (^)(NSInteger fileCount,unsigned long long))completionHandle{
    WTResourceCacheManager * manager = [WTResourceCacheManager manager];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error;
       NSArray * fileArray = [manager.fileManager contentsOfDirectoryAtPath:manager.resourcePath error:&error];
       __block unsigned long long size = 0;
        [fileArray enumerateObjectsUsingBlock:^(NSString * filePath, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString * cachePath = [manager.resourcePath stringByAppendingPathComponent:filePath];
                NSError *err;
                NSDictionary *attribute = [manager.fileManager attributesOfItemAtPath:cachePath error:&err];
                if (!err) {
                    size += [attribute fileSize];
                }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandle) {
                completionHandle(fileArray.count,size);
            }
//        });
    });
}
@end
