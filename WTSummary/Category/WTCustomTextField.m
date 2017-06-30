//
//  WTCustomTextField.m
//  123
//
//  Created by piyingke on 16/12/26.
//  Copyright © 2016年 piyingke. All rights reserved.
//

#import "WTCustomTextField.h"

@interface WTCustomTextField ()<UITextFieldDelegate>

@end
static CGFloat leftMargin = 3;
@implementation WTCustomTextField

- (instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder font:(UIFont *)font placeTextColor:(UIColor *)placeTextColor keyboardType:(UIKeyboardType)keyboardType returnKeyType:(UIReturnKeyType)returnKeyType secureTextEntry:(BOOL)secureTextEntry leftImage:(UIImage *)leftImage topRadius:(CGFloat)topRadius bottomRadius:(CGFloat)bottomRadius textFont:(UIFont *)textFont textColor:(UIColor *)textColor{
    
    if (self = [super init]) {
        
        [self textFieldWithFrame:frame placeHolder:placeHolder font:font placeTextColor:placeTextColor keyboardType:keyboardType returnKeyType:returnKeyType secureTextEntry:secureTextEntry leftImage:leftImage topRadius:topRadius bottomRadius:bottomRadius textFont:textFont textColor:textColor];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder font:(UIFont *)font placeTextColor:(UIColor *)placeTextColor textFont:(UIFont *)textFont textColor:(UIColor *)textColor secureTextEntry:(BOOL)secureTextEntry{
    
   return [self initWithFrame:frame placeHolder:placeHolder font:font placeTextColor:placeTextColor keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyDone secureTextEntry:secureTextEntry leftImage:nil topRadius:0 bottomRadius:0 textFont:textFont textColor:textColor];
    
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect rect;
    if (self.leftView) {
        rect = CGRectMake(CGRectGetMaxX(self.leftView.frame) + 5, 0, self.frame.size.width - self.leftView.frame.size.width, self.frame.size.height);
       
    }else{
        rect = CGRectMake(leftMargin + 3,0, self.frame.size.width,self.frame.size.height);
    }
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    CGRect rect;
    if (self.leftView) {
        rect = CGRectMake(CGRectGetMaxX(self.leftView.frame) + leftMargin, 0, self.frame.size.width - self.leftView.frame.size.width, self.frame.size.height);
    }else{
        rect = CGRectMake(leftMargin,0, self.frame.size.width,self.frame.size.height);
    }
    return rect;
}

/**
 * frame:位置
 * placeHolder:占位文字
 * font:占位文字的font
 * placeTextColor:占位文字的颜色
 * keyboardType:键盘类型
 * returnKeyType:returnKeyType类型
 * secureTextEntry:明文／暗文
 *
 *
 */
- (void)textFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder font:(UIFont *)font placeTextColor:(UIColor *)placeTextColor keyboardType:(UIKeyboardType)keyboardType returnKeyType:(UIReturnKeyType)returnKeyType secureTextEntry:(BOOL)secureTextEntry leftImage:(UIImage *)leftImage topRadius:(CGFloat)topRadius bottomRadius:(CGFloat)bottomRadius textFont:(UIFont *)textFont textColor:(UIColor *)textColor{
    
    self.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    self.font = textFont;
    self.textColor = textColor;
    self.borderStyle = UITextBorderStyleNone;
    self.tintColor = [UIColor lightGrayColor];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.placeholder = placeHolder;
    self.keyboardType = keyboardType;
    self.returnKeyType = returnKeyType;
    self.secureTextEntry = secureTextEntry;
    [self setValue:placeTextColor forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:font forKeyPath:@"_placeholderLabel.font"];
  
    self.delegate = self;
    if (leftImage) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:leftImage];
        imageView.frame = CGRectMake(0, 0,leftImage.size.width, leftImage.size.height);
        self.leftView = imageView;
        imageView.contentMode = UIViewContentModeCenter;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
   
    void (^rectCornerBlock)(UIRectCorner rectCorner,CGFloat cornerRadius) = ^(UIRectCorner rectCorner,CGFloat cornerRadius){
        
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    };
    
    // 设置圆角
    UIRectCorner rectCorner;
    CGFloat cornerRadius;
    if (topRadius) {
        rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight;
        cornerRadius = topRadius;
        rectCornerBlock(rectCorner,cornerRadius);
    }
    if (bottomRadius){
        rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        cornerRadius = bottomRadius;
        rectCornerBlock(rectCorner,cornerRadius);
    }
    
    if (topRadius && bottomRadius) {
        rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
        cornerRadius = bottomRadius;
        rectCornerBlock(rectCorner,cornerRadius);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignFirstResponder];
    return YES;
}


- (void)textFieldTextDidChange:(NSNotification *)noti{
    if (self.text.length > 0) {
        self.textColor = [UIColor blackColor];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
