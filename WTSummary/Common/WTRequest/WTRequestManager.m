//
//  WTRequestManager.m
//  123
//
//  Created by admin on 17/10/13.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTRequestManager.h"
#import "AFNetworking.h"

@interface WTRequestManager ()
@property (nonatomic, strong) NSMutableDictionary * taskCache;
//@property (nonatomic, assign) NSTimeInterval timeInterval;
@end

@implementation WTRequestManager

+ (instancetype) manager{
    
    return [[self alloc] init];
}

- (instancetype)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

- (NSURLSessionDataTask *)sendRequestWithType:(WTRequestType)requestType requestURL:(NSString *)requestURL parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *))progress taskDescription:(NSString *)taskDescription successHandler:(void (^)(NSURLSessionDataTask *, id))successHandler failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    
    NSURLSessionDataTask * dataTask = nil;
    
    AFHTTPSessionManager * manager = [self setManager];
    
    if (requestType == WTRequestTypeGET) {
        
       dataTask = [manager GET:requestURL parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successHandler) {
                successHandler(dataTask,responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(task,error);
            }
        }];
    }
    
    [dataTask resume];
    
    return dataTask;
    
}

- (AFHTTPSessionManager *)setManager{
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager * sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [sessionManager.requestSerializer setTimeoutInterval:60];
    
    return sessionManager;
}
@end
