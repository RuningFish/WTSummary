//
//  WTToolbar.h
//  WTSummary
//
//  Created by piyingke on 17/7/6.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTToolbar;
typedef enum {
    WTToolbarButtonTypeImage = 0, // 选择图片
    WTToolbarButtonTypeAt         // @好友
}WTToolbarButtonType;

@protocol WTToolbarDelegate <NSObject>

- (void)toolbar:(WTToolbar *)discussToolbar didClickWithType:(WTToolbarButtonType)type;

@end

@interface WTToolbar : UIView
/** delegate */
@property (nonatomic , weak) id<WTToolbarDelegate> delegate;
@end
