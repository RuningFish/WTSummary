//
//  WTResourceCacheManager.h
//  WTSummary
//
//  Created by piyingke on 2018/1/24.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTResourceCacheManager : NSObject

+ (instancetype)manager;
- (NSString *)cachePathWithURL:(NSURL *)url;

- (void)cleanAllCache;
- (void)cleanCacheWithURL:(NSURL *)url;

- (void)cacheFileForURL:(NSURL *)url completionHandle:(void (^)(BOOL hasCached,NSString * fileUrl))completionHandler;
+ (void)calculateCachedResourceSizeWithCompletionHandle:(void(^)(NSInteger fileCount,unsigned long long cacheSize))completionHandle;
- (NSString *)fileNameWithURL:(NSURL *)url;

- (void)saveResourceInfo:(NSMutableDictionary *)info;
// 读取缓存资源的信息文件{url(md5):文件的大小}
- (NSMutableDictionary *)resourceInfo;
@end
