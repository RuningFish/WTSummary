//
//  WTImageTextViewController.m
//  WTSummary
//
//  Created by piyingke on 17/7/6.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTImageTextViewController.h"

@interface WTImageTextViewController ()<YYTextViewDelegate>
@property (nonatomic, strong) YYTextView * textView;

@property (nonatomic, strong) UIView * toolBar;
@end

@implementation WTImageTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布图文帖";
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.toolBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti{
    
    NSDictionary* userInfo = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    NSLog(@"555 %@",NSStringFromCGRect(keyboardFrame));
    [UIView animateWithDuration:animationDuration animations:^{
        self.toolBar.transform = CGAffineTransformTranslate(self.toolBar.transform, 0, -keyboardFrame.size.height);
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)noti{
    [UIView animateWithDuration:0.25 animations:^{
        self.toolBar.transform = CGAffineTransformIdentity;
    }];
}

- (void)textViewDidChange:(YYTextView *)textView{
    
  
}

- (YYTextView *)textView{
    if (!_textView) {
        _textView = [[YYTextView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        _textView.placeholderText = @"请输入内容";
        _textView.placeholderFont = [UIFont systemFontOfSize:15];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.tintColor = [UIColor lightGrayColor];
        _textView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
        _textView.delegate = self;
        NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 10;
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:_textView.text];
        [att addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, _textView.text.length)];
        
    }
    return _textView;
}

- (UIView *)toolBar{
    if (!_toolBar) {
        CGFloat toolbarH = 50;
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - toolbarH, self.view.frame.size.width, toolbarH)];
        _toolBar.backgroundColor = [UIColor redColor];
        CGFloat width = self.view.frame.size.width / 5;
        
        for (int i = 0; i < 2; i ++) {
            UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(i * width, 0, width, toolbarH);
            item.backgroundColor = WTRandomColor;
            [_toolBar addSubview:item];
        }
        
    }
    return _toolBar;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//- (NSMutableAttributedString *)atHighlightStringWithString:(NSString *)string{
//    
//    NSString * mentionPattern = @"(@[^\\s@]+)";
//    
//    NSRegularExpression * expression = [NSRegularExpression regularExpressionWithPattern:mentionPattern options:NSRegularExpressionCaseInsensitive error:nil];
//    
//    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
//    [expression enumerateMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
//        
//        NSString * atString = [string substringWithRange:result.range];
//        
//        if (![atString isEqualToString:@""]) {
//            
//            NSRange atRange = result.range;
//            
//            // @颜色
//            NSDictionary * atDict =   @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#4990E2"],
//                                        NSFontAttributeName:[UIFont systemFontOfSize:15]};
//            
//            [attributeStr addAttributes:atDict range:atRange];
//        }
//    }];
//    
//    return attributeStr;
//}

@end
