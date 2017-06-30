//
//  WTCustomTextField.h
//  123
//
//  Created by piyingke on 16/12/26.
//  Copyright © 2016年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTCustomTextField : UITextField

-(instancetype)initWithFrame:(CGRect)frame
              placeHolder:(NSString *)placeHolder
                     font:(UIFont *)font
              placeTextColor:(UIColor *)placeTextColor
                keyboardType:(UIKeyboardType)keyboardType
               returnKeyType:(UIReturnKeyType)returnKeyType
             secureTextEntry:(BOOL)secureTextEntry
                   leftImage:(UIImage *)leftImage
                   topRadius:(CGFloat)topRadius
                bottomRadius:(CGFloat)bottomRadius
                    textFont:(UIFont *)textFont
                    textColor:(UIColor *)textColor;

/**
 * 占位文字的颜色大小／输入文字的颜色大小
 */
- (instancetype)initWithFrame:(CGRect)frame
                 placeHolder:(NSString *)placeHolder
                        font:(UIFont *)font
              placeTextColor:(UIColor *)placeTextColor
                    textFont:(UIFont *)textFont
                   textColor:(UIColor *)textColor
             secureTextEntry:(BOOL)secureTextEntry;
@end
