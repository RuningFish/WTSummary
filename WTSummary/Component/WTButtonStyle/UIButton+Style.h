//
//  UIButton+Style.h
//  123
//
//  Created by piyingke on 2017/11/20.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WTButtonImageStyleLeft = 0, // 图片在左，文字在右
    WTButtonImageStyleRight ,   // 图片在右，文字在左
    WTButtonImageStyleBottom ,  // 图片在下，文字在上
    WTButtonImageStyleTop       // 图片在上，文字在下
}WTButtonImageStyle;

@interface UIButton (Style)

- (void)setButtonStyle:(WTButtonImageStyle)style space:(CGFloat)space;
- (void)setButtonStyle:(WTButtonImageStyle)style imageSize:(CGSize)imageSize space:(CGFloat)space;
@end
