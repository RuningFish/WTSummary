//
//  WTAlertController.h
//  WTSummary
//
//  Created by admin on 17/6/28.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTAlertAction;
typedef enum {
    WTAlertActionStyleDefault = 0,
    WTAlertActionStyleCancel,
    WTAlertActionStyleDestructive
}WTAlertActionStyle;

/** 样式 */
typedef enum {
    WTAlertControllerStyleActionSheet = 0,
    WTAlertControllerStyleAlert
}WTAlertControllerStyle;

@interface WTAlertController : UIView

+ (instancetype _Nullable )alertControllerWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message preferredStyle:(WTAlertControllerStyle)alertStyle;

- (void)addAction:(WTAlertAction *_Nullable)action;

- (void)show;
@end

@interface WTAlertAction : NSObject
+ (instancetype _Nullable )actionWithTitle:(NSString *_Nullable)title style:(WTAlertActionStyle)style handler:(void (^_Nullable)(WTAlertAction * _Nullable action))handler;
@property (nullable, nonatomic, readonly) NSString * title;
@property (nonatomic, readonly) WTAlertActionStyle style;
@end
