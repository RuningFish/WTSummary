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

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(WTAlertControllerStyle)alertStyle;

- (void)addAction:(WTAlertAction *)action;

- (void)show;
@end

@interface WTAlertAction : NSObject
+ (instancetype)actionWithTitle:(NSString *)title style:(WTAlertActionStyle)style handler:(void (^)(WTAlertAction * action))handler;
@property (nullable, nonatomic, readonly) NSString * title;
@property (nonatomic, readonly) WTAlertActionStyle style;
@end
