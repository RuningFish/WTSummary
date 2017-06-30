//
//  UIBarButtonItem+Extension.h
//  123
//
//  Created by piyingke on 17/6/27.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

+ (instancetype)itemWithTitle:(NSString *)title highTitle:(NSString *)highTitle Image:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
