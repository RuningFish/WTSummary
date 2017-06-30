//
//  UIView+Category.m
//  OC与JS交互之UIWebView
//
//  Created by admin on 17/6/18.
//  Copyright © 2017年 rrcc. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

#pragma mark -----------------------------------
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)addCornerWithCornerType:(UIRectCorner)cornerType andCornerRadius:(CGFloat)cornerRadius{
    
    // 给view添加圆角
    UIBezierPath * bezierpath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:cornerType cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc] init];
    shapLayer.frame = self.bounds;
    shapLayer.path = bezierpath.CGPath;
    self.layer.mask = shapLayer;
}


- (void)addLineWithType:(UIViewLineType)lineType andColor:(UIColor *)lineColor height:(CGFloat)lineHeight{
    
    if (lineHeight >= 100 || lineHeight == 0) lineHeight = 1;
    
    if (lineType & UIViewLineTypeTop) {
        CALayer * layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, lineHeight);
        layer.backgroundColor = lineColor.CGColor;
        [self.layer addSublayer:layer];
    }
    
    if (lineType & UIViewLineTypeLeft) {
        CALayer * layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, lineHeight, self.frame.size.height);
        layer.backgroundColor = lineColor.CGColor;
        [self.layer addSublayer:layer];
    }
    
    if (lineType & UIViewLineTypeBottom) {
        CALayer * layer = [CALayer layer];
        layer.frame = CGRectMake(0, self.frame.size.height - lineHeight, self.frame.size.width,lineHeight);
        layer.backgroundColor = lineColor.CGColor;
        [self.layer addSublayer:layer];
    }
    
    if (lineType & UIViewLineTypeRight) {
        CALayer * layer = [CALayer layer];
        layer.frame = CGRectMake(self.frame.size.width - lineHeight, 0, lineHeight,self.frame.size.height);
        layer.backgroundColor = lineColor.CGColor;
        [self.layer addSublayer:layer];
    }
    
}

- (void)addDottedLineColor:(UIColor *)color lineWidth:(CGFloat)lineWidth lineHeight:(CGFloat)lineHeight margin:(CGFloat)margin{
    CAShapeLayer * border = [CAShapeLayer layer];
    border.strokeColor = color.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    border.frame = self.bounds;
    border.lineWidth = lineWidth>10?1.0:lineWidth;
    border.lineCap = @"butt";// `butt', `round' and `square'
    border.lineDashPattern = @[@(lineHeight), @(margin)];
    [self.layer addSublayer:border];
}
@end
