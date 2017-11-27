//
//  VideoInfo.m
//  123
//
//  Created by admin on 17/10/15.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "VideoInfo.h"

@implementation VideoInfo

+ (instancetype)videoInfoWithDictionary:(NSDictionary *)dict{
    
    return [[self alloc] initWithVideoDictionary:dict];
}

- (instancetype)initWithVideoDictionary:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
