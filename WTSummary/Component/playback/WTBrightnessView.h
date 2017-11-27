//
//  WTBrightnessView.h
//
//  Created by piyingke on 2017/10/27.
//  Copyright © 2017年 piyingke. All rights reserved.
//  屏幕亮度显示的view

#import <UIKit/UIKit.h>

@interface WTBrightnessView : UIView

+ (instancetype)sharedBrightnessView;

- (void)show;
- (void)dismiss;
- (void)dismissAtOnce;
@end
