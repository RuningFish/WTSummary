//
//  UIBarButtonItem+Extension.m
//  123
//
//  Created by piyingke on 17/6/27.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (instancetype)itemWithType:(UIBarButtonItemType)type Image:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{
    
    return [self itemWithType:type Title:nil highTitle:nil Image:image highImage:highImage target:target action:action];
}

+ (instancetype)itemWithType:(UIBarButtonItemType)type Title:(NSString *)title highTitle:(NSString *)highTitle Image:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 0, 60, 44);
    if (type == UIBarButtonItemTypeLeft) {
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }else if (type == UIBarButtonItemTypeRight){
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    }

    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:highTitle forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

@end
