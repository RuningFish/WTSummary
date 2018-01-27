//
//  WTPlaybackDownLoader.h
//  123
//
//  Created by piyingke on 2017/11/6.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WTPlaybackDownLoader;
@protocol WTPlaybackDownLoaderDelegate <NSObject>
@optional
- (void)downLoader:(WTPlaybackDownLoader *)downLoader didReceiveData:(NSData *)data;
- (void)downLoader:(WTPlaybackDownLoader *)downLoader didCompleteWithError:(NSError *)error;

@end
@interface WTPlaybackDownLoader : NSObject
/** 下载的地址 */
@property(nonatomic, strong) NSURL * downLoadUrl;
/** 下载的路径 */
@property(nonatomic, copy) NSString * downLoadPath;
/** 已下载的大小 */
@property(nonatomic, assign) NSInteger downLoadLength;
/** 文件的大小 */
@property(nonatomic, assign) NSInteger contentLength;
/** 文件的类型 */
@property(nonatomic, copy) NSString * mimeType;
@property(nonatomic, assign) NSUInteger offset;
/** delegate */
@property(nonatomic, weak) id<WTPlaybackDownLoaderDelegate> delegate;

- (void)setDownLoadUrl:(NSURL *)downLoadUrl offset:(NSInteger)offset;

@end

@interface WTPlaybackFileManager : NSFileManager
+ (instancetype)fileManager;

/** 视频的缓存路径 */
- (NSString *)cachePathForUrl:(NSURL *)url;
/** 本地是否有对应的缓存视频
 *  url:视频的url
 *  hasCached:YES,本地有缓存,fileUrl:对应的返回地址,反之
 */
- (void)cacheFileForURL:(NSURL *)url completionHandle:(void (^)(BOOL hasCached,NSString * fileUrl))completionHandler;
@end
