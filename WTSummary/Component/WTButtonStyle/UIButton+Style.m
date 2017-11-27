//
//  UIButton+Style.m
//  123
//
//  Created by piyingke on 2017/11/20.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "UIButton+Style.h"
#import <objc/runtime.h>

/** 样式 */
static const NSString * WTButtonImageStyle_key;
/** 图片的大小 */
static const NSString * WTButtonImageSize_key;
/** 图片文字间距 */
static const NSString * WTButtonImageSpace_key;

@implementation UIButton (Style)

- (void)setButtonStyle:(WTButtonImageStyle)style space:(CGFloat)space{
    [self setButtonStyle:style imageSize:CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height) space:space];
}

- (void)setButtonStyle:(WTButtonImageStyle)style imageSize:(CGSize)imageSize space:(CGFloat)space {
    
    objc_setAssociatedObject(self, &WTButtonImageStyle_key, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &WTButtonImageSpace_key, @(space), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &WTButtonImageSize_key, NSStringFromCGSize(imageSize), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

+ (void)load{
    
    Method m1 = class_getInstanceMethod([self class], @selector(layoutSubviews));
    Method m2 = class_getInstanceMethod([self class], @selector(myLayoutSubviews));
    method_exchangeImplementations(m1, m2);
}

- (void)myLayoutSubviews{
    
    [self myLayoutSubviews];
    
    NSNumber * style = objc_getAssociatedObject(self, &WTButtonImageStyle_key);
    if (style) {
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        NSNumber * space = objc_getAssociatedObject(self, &WTButtonImageSpace_key);
        NSString * imageSizeString = objc_getAssociatedObject(self, &WTButtonImageSize_key);
        CGSize imageSize = self.currentImage?CGSizeFromString(imageSizeString):CGSizeZero;
        CGSize labelSize = self.currentTitle.length ? [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size : CGSizeZero;
        
        // 间距
        CGFloat margin = (self.currentImage && self.currentTitle.length)? space.floatValue : 0;
        labelSize.width = labelSize.width > width ? width : labelSize.width;
//        self.titleLabel.backgroundColor = [UIColor greenColor];
        CGFloat imageX = 0.0 ,imageY = 0.0 , labelX = 0.0 ,labelY = 0.0;
        
        switch (style.integerValue) {
                // 图片在上，文字在下
            case WTButtonImageStyleTop:
                {
                    imageX = (width - imageSize.width)*0.5;
                    imageY = (height - imageSize.height - margin - labelSize.height)*0.5;
                    labelX = (width - labelSize.width)*0.5;
                    labelY = imageY + imageSize.height + margin;
                    self.imageView.contentMode = UIViewContentModeBottom;
                }
                break;
                
                 // 图片在左，文字在右
                case WTButtonImageStyleLeft:
                {
                    imageX = (width - imageSize.width - labelSize.width - margin)*0.5;
                    imageY = (height - imageSize.height)*0.5;
                    labelX = imageX + imageSize.width + margin;
                    labelY = (height - labelSize.height)*0.5;
                    self.imageView.contentMode = UIViewContentModeRight;
                }
                break;
                
                 // 图片在下，文字在上
                case WTButtonImageStyleBottom:
                {
                    labelX = (width - labelSize.width)*0.5;
                    labelY = (height - labelSize.height - imageSize.height - margin)*0.5;
                    imageX = (width - imageSize.width)*0.5;
                    imageY = labelY + labelSize.height + margin;
                    self.imageView.contentMode = UIViewContentModeTop;
                }
                break;
                
                 // 图片在右，文字在左
                case WTButtonImageStyleRight:
                {
                    labelX = (width - imageSize.width - labelSize.width - margin)*0.5;
                    labelY = (height - labelSize.height)*0.5;
                    imageX = labelX + labelSize.width + margin;
                    imageY = (height - imageSize.height)*0.5;
                    self.imageView.contentMode = UIViewContentModeLeft;
                }
                break;
           
        }
        
        self.imageView.frame = CGRectMake(imageX, imageY, imageSize.width, imageSize.height);
        self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
    }
}


@end
