//
//  WTPlaybackBottomView.h
//  
//  Created by piyingke on 2017/10/11.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTPlaybackBottomView : UIView
/** 是否为全屏 */
@property (nonatomic, assign) BOOL isFullScreen;
/***/
@property (nonatomic,strong) UIView * bottomSuperView;
/**
 * fullscreen: yes 全屏
*/
- (void)switchFullscreen:(BOOL)fullscreen success:(void(^)())success;

@end
