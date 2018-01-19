//
//  WTFormBaseItem.m
//  WTSummary
//
//  Created by piyingke on 2018/1/17.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTFormBaseItem.h"


@implementation WTFormBaseItem

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title arrowImage:(UIImage *)arrowImage cellType:(WTFormCellType)cellType{
    return [[self alloc] initWithImage:image title:title arrowImage:arrowImage cellType:cellType];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title arrowImage:(UIImage *)arrowImage cellType:(WTFormCellType)cellType{
    if (self = [super init]) {
        self.image = image;
        self.title = title;
        self.arrowImage = arrowImage;
        self.formCellType = cellType;
    }
    return self;
}
@end
