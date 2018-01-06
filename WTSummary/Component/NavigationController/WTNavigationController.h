//
//  WTNavigationController.h
//  WTSummary
//
//  Created by admin on 17/6/25.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTNavigationController : UINavigationController

@end

/** 开始侧滑 */
extern NSString * const KHandleNavigationStateBegin;
/** 正在侧滑 */
extern NSString * const KHandleNavigationStateChange;
/** 侧滑结束 */
extern NSString * const KHandleNavigationStateEnd;
