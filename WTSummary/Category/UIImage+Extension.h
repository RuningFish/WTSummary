//
//  UIImage+Extension.h
//  WTSummary
//
//  Created by admin on 17/6/25.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/** 生成一张纯色的图片 */
+ (UIImage *)createImageWithColor:(UIColor *)color;


/****************************** 旋转相关 *************************************/
/** 将图片旋转弧度radians */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
/** 纠正图片的方向 */
- (UIImage *)fixOrientation;
/** 按给定的方向旋转图片 */
- (UIImage*)rotate:(UIImageOrientation)orient;
/** 垂直翻转 */
- (UIImage *)flipVertical;
/** 水平翻转 */
- (UIImage *)flipHorizontal;


+ (UIImage *)captureImageWithView:(UIView *)view;
/** 裁成一张圆形图片 */
- (UIImage *)clipCircleImage;
/****************************** 视频截图相关 *************************************/
+ (UIImage *)getImageFormVideoUrl:(NSURL *)videoUrl atIndex:(CFTimeInterval)index;
@end
