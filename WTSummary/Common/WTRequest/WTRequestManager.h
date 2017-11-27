//
//  WTRequestManager.h
//  123
//
//  Created by admin on 15/10/13.
//  Copyright © 2015年 piyingke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    
    WTRequestTypeGET,
    WTRequestTypePOST,
    WTRequestTypePUT,
    WTRequestTypeHEAD,
    WTRequestTypePATCH,
    WTRequestTypeDELETE
    
}WTRequestType;

@interface WTRequestManager : NSObject

@property (nonatomic , assign) NSTimeInterval timeInterval;

@property (nonatomic , strong ,readonly) NSMutableArray *taskArray;

+ (instancetype)manager;


#pragma mark - 发起网络请求
/**
 异步网络请求
 
 @param requestType 请求类型
 @param requestURL 请求地址
 @param parameters 请求参数
 @param progress 进度
 @param taskDescription 任务描述,通过任务描述可以取消对应的请求任务,成功取消一个task后,会回调failure
 @param successHandler 成功回调
 @param failure 失败回调
 */
/** 发送异步网络请求 */
- (NSURLSessionDataTask *)sendRequestWithType:(WTRequestType)requestType
                                              requestURL:(NSString *)requestURL
                                              parameters:(NSDictionary *)parameters
                                                progress:(void (^)(NSProgress *downloadProgress))progress
                                         taskDescription:(NSString *)taskDescription
                                          successHandler:(void (^)(NSURLSessionDataTask *task, id responseObject))successHandler
                                                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 上传图片
/**上传图片*/
-(void)UPLoadImageWitRequestURL:(NSString *)requestURL
                     parameters:(NSDictionary *)parameters
                          image:(UIImage *)image
                       progress:(void (^)(NSProgress *uploadProgress))progress
                 successHandler:(void (^)(NSURLSessionDataTask *task, id responseObject))successHandler
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 上传ZIP
-(void)UPLoadFileWithRequestURL:(NSString *)requestURL
                     parameters:(NSDictionary *)parameters
                       filePath:(NSString *)filePath
                       progress:(void (^)(NSProgress *uploadProgress))progress
                 successHandler:(void (^)(NSURLSessionDataTask *task, id responseObject))successHandler
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - 取消请求任务
/**
 根据传入的taskDescription来取消对应的网络任务,正在执行的网络请求不能被取消
 */
-(void)cancelTaskWithTaskDescription:(NSString *)taskDescription;

/**
 取消所有的网络请求,正在执行的网络请求不能被取消
 */
-(void)cancelAllTask;
@end
