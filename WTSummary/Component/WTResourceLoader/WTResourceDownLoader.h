//
//  WTResourceDownLoader.h
//  WTSummary
//
//  Created by piyingke on 2018/1/24.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WTResourceInfo : NSObject
/** 文件的大小 */
@property (nonatomic, assign) long long contentLength;
/** 文件的类型 */
@property (nonatomic, copy) NSString * contentType;
/** 已下载的大小 */
@property (nonatomic, assign) NSInteger downLoadLength;
@end

@class WTResourceDownLoader;
@protocol WTResourceDownLoaderDelegate <NSObject>
- (void)resourceDownLoader:(WTResourceDownLoader *)downLoader
                             didReceiveResponse:(NSURLResponse *)response
                             completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler;
- (void)resourceDownLoader:(WTResourceDownLoader *)downLoader didReceiveData:(NSData *)data;
- (void)resourceDownLoader:(WTResourceDownLoader *)downLoader didCompleteWithError:(NSError *)error;
@end
@interface WTResourceDownLoader : NSObject
@property (nonatomic, strong, readonly) NSURL * url;
@property (nonatomic, weak) id<WTResourceDownLoaderDelegate> delegate;
@property (nonatomic, strong, readonly) WTResourceInfo * info;
- (instancetype)initWithURL:(NSURL *)url;
- (void)start;
@end


