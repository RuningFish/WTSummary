//
//  WTCustomTextView.h
//  HighlightTextView
//
//  Created by admin on 17/3/23.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTCustomTextView;
/** textView的输入长度发生改变的delegate */
@protocol WTCustomTextViewDelegate <NSObject>
- (void)customTextViewDidChange:(WTCustomTextView *)textView;

/** textView输入 @ 字符时的代理方法*/
- (void)customTextViewHasAtString:(WTCustomTextView *)textView;

- (void)customTextViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)customTextViewBeginEditing:(UIScrollView *)scrollView;
@end

@interface WTCustomTextView : UITextView 
/** 占位的提示文字 */
@property (nonatomic,copy) NSString * placeHolder;
/** 占位文字的颜色 */
@property (nonatomic,strong) UIColor * placeColor;
/** 占位文字的大小*/
@property (nonatomic,assign) UIFont * placeFont;
/** 占位的文字label */
@property (nonatomic, weak) UILabel * placeHolderLabel;

/** 是否隐藏占位文字 */
@property (nonatomic,assign) BOOL isHiddenPlaceHoder;
@property (nonatomic, weak) id<WTCustomTextViewDelegate> myDelegate;
@end
