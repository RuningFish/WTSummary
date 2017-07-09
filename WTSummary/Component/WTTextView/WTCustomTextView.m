//
//  WTCustomTextView.m
//  HighlightTextView
//
//  Created by admin on 17/3/23.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTCustomTextView.h"
#import "WTCustomTextStorage.h"

@interface WTCustomTextView ()<UITextViewDelegate>

/** 光标的位置 */
@property (nonatomic, assign) NSInteger location;
@end

@implementation WTCustomTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer{
    
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        
        // 光标的颜色
        self.tintColor = [UIColor grayColor];
        NSLog(@"AAAAA");
        // 占位文字
        UILabel * placeHolderLabel = [[UILabel alloc] init];
        self.placeHolderLabel = placeHolderLabel;
        placeHolderLabel.font = self.font;
        placeHolderLabel.textColor = self.textColor;
        placeHolderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:placeHolderLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textviewChange) name:UITextViewTextDidChangeNotification object:nil];
        
        self.delegate = self;
    
        [self becomeFirstResponder];
    }
    return self;
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
}

- (void)setPlaceColor:(UIColor *)placeColor{
    
    _placeColor = placeColor;
    self.placeHolderLabel.textColor = placeColor;
    
}

- (void)setPlaceFont:(UIFont *)placeFont{
    
    _placeFont = placeFont;
    self.placeHolderLabel.font = placeFont;
}

- (void)setIsHiddenPlaceHoder:(BOOL)isHiddenPlaceHoder{
    
    _isHiddenPlaceHoder = isHiddenPlaceHoder;
    self.placeHolderLabel.hidden = isHiddenPlaceHoder;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = 25;
    self.placeHolderLabel.frame = CGRectMake(8, 5, w, h);
    
}

- (void)textviewChange{
    
    self.placeHolderLabel.hidden = (self.text.length != 0);
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    //NSLog(@"光标开始的位置 －－－ %zd --- %zd",self.selectedRange.location, self.text.length);
    if ([self.myDelegate respondsToSelector:@selector(customTextViewBeginEditing:)]) {
        [self.myDelegate customTextViewBeginEditing:self];
    }

}
- (void)textViewDidChange:(UITextView *)textView{
    
    // 有时候在选择完@好友后 输入的文字会变小 所以要重新设置一下字体的大小
    self.font = [UIFont systemFontOfSize:15];
    
    //NSLog(@"textView text -%@",textView.text);
    if ([self.myDelegate respondsToSelector:@selector(customTextViewDidChange:)]) {
        [self.myDelegate customTextViewDidChange:self];
    }
    
    NSLog(@"光标的位置 －－－－－ %@ %@",NSStringFromRange(self.selectedRange),textView.text);
    
}

#pragma mark - 检测输入的字符 yes 可以输入 no禁止输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSLog(@"bbbbb - %@ --- %@",NSStringFromRange(range),text);

    if ([text isEqualToString:@"@"]) {
         NSLog(@"输入@");
        if ([self.myDelegate respondsToSelector:@selector(customTextViewHasAtString:)]) {
            [self.myDelegate customTextViewHasAtString:self];
        }
        // return NO;
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    // 一进来就检测一下文字的字数限制
    if ([self.myDelegate respondsToSelector:@selector(customTextViewDidChange:)]) {
        [self.myDelegate customTextViewDidChange:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if ([self.myDelegate respondsToSelector:@selector(customTextViewWillBeginDragging:)]) {
        [self.myDelegate customTextViewWillBeginDragging:self];
    }
}
@end
