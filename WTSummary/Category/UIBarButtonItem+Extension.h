//
//  UIBarButtonItem+Extension.h
//  123
//
//  Created by piyingke on 17/6/27.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger,UIBarButtonItemType){
    UIBarButtonItemTypeLeft = 0,
    UIBarButtonItemTypeRight
};
@interface UIBarButtonItem (Extension)
+ (instancetype)itemWithType:(UIBarButtonItemType)type Image:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

+ (instancetype)itemWithType:(UIBarButtonItemType)type Title:(NSString *)title highTitle:(NSString *)highTitle Image:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
