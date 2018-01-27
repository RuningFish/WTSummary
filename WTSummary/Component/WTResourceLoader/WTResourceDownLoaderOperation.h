//
//  WTResourceDownLoaderOperation.h
//  WTSummary
//
//  Created by piyingke on 2018/1/27.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTResourceDownLoaderOperation;
@protocol WTResourceDownLoaderOperationDelegate <NSObject>
- (void)operation:(WTResourceDownLoaderOperation *)operation
        didReceiveResponse:(NSURLResponse *)response
         completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler;
- (void)operation:(WTResourceDownLoaderOperation *)operation didReceiveData:(NSData *)data;
- (void)operation:(WTResourceDownLoaderOperation *)operation didCompleteWithError:(NSError *)error;
@end
@interface WTResourceDownLoaderOperation : NSOperation
@property (nonatomic, strong, readonly) NSURL * url;
@property (nonatomic, weak) id<WTResourceDownLoaderOperationDelegate> delegate;
@property (nonatomic, assign) BOOL downLoading;
- (instancetype)initWithURL:(NSURL *)url;
@end
