//
//  WTControlTopView.h
//  123
//
//  Created by admin on 17/10/16.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoInfo.h"
@interface WTControlTopView : UIView
/** videoInfo */
@property (nonatomic, strong) VideoInfo  * videoInfo;
/** 是否是全屏 */
@property (nonatomic, assign) BOOL isFullscreen;
@end
