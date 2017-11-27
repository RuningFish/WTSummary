//
//  BaseViewController.h
//  123
//
//  Created by piyingke on 2017/11/11.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import <UIKit/UIKit.h>

/** headView的高度 */
#define KBaseViewHeadViewH 200
/** pageControl的高度 */
#define KBaseViewPageControlH 40
/** 导航栏的高度 */
#define KBaseViewNavigationH 64

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, assign) CGPoint lastContentOffset;

@property (nonatomic, assign) BOOL isFirstViewLoaded;

@property (nonatomic, assign) BOOL refreshState;
@end

extern NSString * const ChildScrollViewDidScrollNotification;
extern NSString * const ChildScrollingView;
extern NSString * const ChildScrollingOffset;
