//
//  UIColor+HexStr.h
//
//
//  Created by admin on 16/4/20.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIColor (HexStr)
/** 将十六进制转化为UIColor */
+ (UIColor *)colorWithHexString:(NSString *)HexStr;

+ (UIColor *)colorWithHexString:(NSString *)HexStr alpha:(CGFloat)alpha;
@end
