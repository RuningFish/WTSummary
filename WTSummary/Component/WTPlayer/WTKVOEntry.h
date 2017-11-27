//
//  WTKVOEntry.h
//  123
//
//  Created by piyingke on 17/9/29.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTKVOEntry : NSObject
@property (nonatomic , weak) id observer;
@property (nonatomic , copy) NSString * keyPath;
@end
