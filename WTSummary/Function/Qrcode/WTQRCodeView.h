//
//  WTQRCodeView.h
//  WTSummary
//
//  Created by piyingke on 17/7/1.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CornerLocation) {
    CornerLocationDefault, // 与边线对齐
    CornerLocationInside,  // 在边线内部
    CornerLocationOutside  // 在边线外部
};
@interface WTQRCodeView : UIView
@property (nonatomic, assign) CornerLocation cornerLocation; // 边角位置
@property (nonatomic, strong) UIColor *borderColor;        // 边线颜色 default white
@property (nonatomic, strong) UIColor *cornerColor;        // 边角颜色
@property (nonatomic, assign) CGFloat cornerWidth;         // 边角宽度 default 2.0
@property (nonatomic, assign) CGFloat backgroundAlpha;      // 扫描区域周围alpha值 ,default 0.4
@property (nonatomic, assign) CGFloat animationTimeInterval; // 扫描动画间隔时间,default 0.05
@property (nonatomic, strong) UIImage *scanLineImage;       // 扫描线图片
@property (nonatomic, copy)  NSString *describe;          // 扫描框下方提示语

- (void)addTimer;
- (void)removeTimer;
@end
