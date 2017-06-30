//
//  UIView+Category.h
//  OC与JS交互之UIWebView
//
//  Created by admin on 17/6/18.
//  Copyright © 2017年 rrcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    UIViewLineTypeTop = 1 << 1, // 上
    UIViewLineTypeLeft = 1 << 2, // 左
    UIViewLineTypeBottom = 1 << 3, // 下
    UIViewLineTypeRight = 1 << 4, // 右
}UIViewLineType;

@interface UIView (Category)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

/** 获取当前view所在的控制器 */
- (UIViewController *)getCurrentViewController;

/**
 * 给view添加圆角
 * cornerRadius：圆角的大小
 */
- (void)addCornerWithCornerType:(UIRectCorner)cornerType andCornerRadius:(CGFloat)cornerRadius;
/**
 * 给view添加边线
 * lineColor：线条的颜色
 * lineHeight：线条的高度
 */
- (void)addLineWithType:(UIViewLineType)lineType andColor:(UIColor *)lineColor height:(CGFloat)lineHeight;

/**
 * 给view添加虚线框
 * color  线条的颜色
 * lineWidth 虚线的宽度
 * lineHeight 虚线的长度
 * margin  虚线之间的间距
 */

- (void)addDottedLineColor:(UIColor *)color lineWidth:(CGFloat)lineWidth lineHeight:(CGFloat)lineHeight margin:(CGFloat)margin;
@end
