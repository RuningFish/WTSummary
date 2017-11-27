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

- (NSString *)cachePathForUrl:(NSURL *)url;

@end
