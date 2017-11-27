//
//  WTPersonalViewController.m
//  WTSummary
//
//  Created by piyingke on 2017/11/27.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//  类似个人主页的效果

#define KScreenSize [UIScreen mainScreen].bounds.size

#import "WTPersonalViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourViewController.h"
#import "WTPageControl.h"

@interface WTPersonalViewController ()<UIScrollViewDelegate,WTPageControlDelegate>
/** tableHeadView */
@property (nonatomic, strong) UIView * headerView;
/** scrollView */
@property (nonatomic, strong) UIScrollView * scrollView;
/** 选择的itemview */
@property (nonatomic, strong) WTPageControl * pageControl;

@property (nonatomic, assign) CGFloat lastPageControlY;

@property (nonatomic, assign) CGPoint lastPoint;
@end

@implementation WTPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    

    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.lastPageControlY = KBaseViewHeadViewH;
    
    // 添加scrollView
    [self.view addSubview:self.scrollView];
    // 添加headerView
    [self.view addSubview:self.headerView];
    // 添加pageControl
    [self.view addSubview:self.pageControl];
    
    FirstViewController * firstVC = [[FirstViewController alloc] init];
    [self addChildViewController:firstVC];
    [self addChildViewController:[[SecondViewController alloc] init]];
    [self addChildViewController:[[ThirdViewController alloc] init]];
    [self addChildViewController:[[FourViewController alloc] init]];
    
    [self.scrollView addSubview:firstVC.view];
    
    
    // 监听子控制器发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subTableViewDidScroll:) name:ChildScrollViewDidScrollNotification object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self changBaseViewControllerContentOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self changBaseViewControllerContentOffset];
}

- (void)changBaseViewControllerContentOffset{
    
    BaseViewController * viewController = self.childViewControllers[self.pageControl.selectedItemIndex];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (viewController.scrollView.contentSize.height < KScreenSize.height && [viewController isViewLoaded]) {
            [viewController.scrollView setContentOffset:CGPointMake(0, -(KBaseViewHeadViewH + KBaseViewPageControlH - KBaseViewNavigationH)) animated:YES];
        }
    });
    
}

- (void)subTableViewDidScroll:(NSNotification *)noti {
    
    // 取出当前正在滚动的tableView
    UIScrollView * scrollingScrollView = noti.userInfo[ChildScrollingView];
    CGFloat offsetDifference = [noti.userInfo[ChildScrollingOffset] floatValue];
    
    CGFloat distanceY = 0.0;
    BaseViewController * baseVc = self.childViewControllers[self.pageControl.selectedItemIndex];
    if (scrollingScrollView == baseVc.scrollView && !baseVc.isFirstViewLoaded) {
        NSLog(@"1");
        // 让悬浮菜单跟着scrollView滚动
        CGRect pageControlFrame = self.pageControl.frame;
        CGFloat topMargin = KBaseViewHeadViewH + KBaseViewPageControlH;
        if (pageControlFrame.origin.y >= KBaseViewNavigationH) {
            //            NSLog(@"2");
            // 往上移
            if (offsetDifference > 0 && scrollingScrollView.contentOffset.y + topMargin > 0) {
                //                NSLog(@"3");
                if ((scrollingScrollView.contentOffset.y + topMargin + self.pageControl.frame.origin.y >= KBaseViewHeadViewH) || scrollingScrollView.contentOffset.y + topMargin < 0) {
                    //                    NSLog(@"4");
                    pageControlFrame.origin.y += -offsetDifference;
                    if (pageControlFrame.origin.y <= KBaseViewNavigationH) {
                        pageControlFrame.origin.y = KBaseViewNavigationH;
                    }
                }
            }
            
            else{
                // 往下移
                if (scrollingScrollView.contentOffset.y+topMargin+self.pageControl.frame.origin.y < KBaseViewHeadViewH) {
                    pageControlFrame.origin.y = -scrollingScrollView.contentOffset.y - topMargin + KBaseViewHeadViewH;
                    if (pageControlFrame.origin.y >= KBaseViewHeadViewH) {
                        pageControlFrame.origin.y = KBaseViewHeadViewH;
                    }
                }
            }
        }
        
        self.pageControl.frame = pageControlFrame;
        CGRect headerViewFrame = self.headerView.frame;
        headerViewFrame.origin.y = self.pageControl.frame.origin.y - KBaseViewHeadViewH;
        self.headerView.frame = headerViewFrame;
        
        // 记录悬浮菜单的y值改变量
        distanceY = pageControlFrame.origin.y - self.lastPageControlY;
        self.lastPageControlY = self.pageControl.frame.origin.y;
        
        // 让其余的
        [self followScrollingScrollView:scrollingScrollView distanceY:distanceY];
        
    }
    baseVc.isFirstViewLoaded = NO;
}

- (void)followScrollingScrollView:(UIScrollView *)scrollingScrollView distanceY:(CGFloat)distanceY{
    BaseViewController *baseVc = nil;
    for (int i = 0; i < self.childViewControllers.count; i++) {
        baseVc = self.childViewControllers[i];
        if (baseVc.scrollView == scrollingScrollView) {
            continue;
        } else {
            CGPoint contentOffSet = baseVc.scrollView.contentOffset;
            contentOffSet.y += -distanceY;
            baseVc.scrollView.contentOffset = contentOffSet;
        }
    }
}


- (void)headerViewPanGesture:(UIPanGestureRecognizer *)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint currentPoint = [pan translationInView:pan.view];
        CGFloat distanceY = currentPoint.y - self.lastPoint.y;
        self.lastPoint = currentPoint;
        
        BaseViewController * baseViewController = self.childViewControllers[self.pageControl.selectedItemIndex];
        CGPoint offset = baseViewController.scrollView.contentOffset;
        offset.y += - distanceY;
        if (offset.y <= -(KBaseViewHeadViewH + KBaseViewPageControlH)) {
            offset.y = -(KBaseViewHeadViewH + KBaseViewPageControlH);
        }
        baseViewController.scrollView.contentOffset = offset;
    }
    else {
        [pan setTranslation:CGPointZero inView:pan.view];
        self.lastPoint = CGPointZero;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenSize.width, KBaseViewHeadViewH)];
        _headerView.backgroundColor = [UIColor purpleColor];
        UIPanGestureRecognizer * headViewPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewPanGesture:)];
        [_headerView addGestureRecognizer:headViewPan];
    }
    return _headerView;
}

- (UIView *)pageControl{
    
    if (!_pageControl) {
        
        _pageControl = [WTPageControl pageControlWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), KScreenSize.width, KBaseViewPageControlH) pageControlStyle:WTPageControlStyleLineAttachment];
        // ,@"第五页",@"第六页",@"第七页",@"第八页"
        [_pageControl setItems:@[@"第一页",@"第二页",@"第三页",@"第四页"] selectedItemIndex:0];
        _pageControl.layoutType = WTPageControlLayoutTypeEqualWidth;
        _pageControl.selectedItemTitleColor = [UIColor orangeColor];
        _pageControl.scrollView = self.scrollView;
        _pageControl.delegate = self;
        _pageControl.bottomLineHeight = 3;
        //        _pageControl.itemImageSize = CGSizeMake(17, 17);
        //        _pageControl.itemStyle = WTPageControlItemStyleNone;
        _pageControl.itemPadding = 20.0;
        _pageControl.bottomLineBgColor = [UIColor orangeColor];
    }
    return _pageControl;
}
- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(KScreenSize.width*4, 0);
        _scrollView.frame = CGRectMake(0, 0, KScreenSize.width, KScreenSize.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor yellowColor];
    }
    return _scrollView;
}

#pragma mark - WTPageControlDelegate
- (void)pageControl:(WTPageControl *)pageControl selectexItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    
    if (!self.childViewControllers.count) {
        return;
    }
    
    //
    BOOL animate = (labs(toIndex - fromIndex) >= 2)?NO:YES;
    [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * toIndex, 0) animated:animate];
    
    BaseViewController * viewController = self.childViewControllers[toIndex];
    // 已经加载过，就不再加载了
    if ([viewController isViewLoaded]) {
        return;
    }
    
    viewController.isFirstViewLoaded = YES;
    //    viewController.isNavigationBarHidden = YES;
    viewController.view.frame = CGRectMake(KScreenSize.width * toIndex, 0, KScreenSize.width, KScreenSize.height);
    UIScrollView * scrolloView = viewController.scrollView;
    CGPoint contentOffset = scrolloView.contentOffset;
    contentOffset.y = - self.headerView.frame.origin.y - (KBaseViewPageControlH + KBaseViewHeadViewH - (self.navigationController.navigationBarHidden?20:KBaseViewNavigationH));
    if (contentOffset.y + KBaseViewPageControlH + KBaseViewHeadViewH - KBaseViewNavigationH >= KBaseViewHeadViewH) {
        contentOffset.y = KBaseViewHeadViewH - (KBaseViewPageControlH + KBaseViewHeadViewH) - KBaseViewNavigationH;
    }
    scrolloView.contentOffset = contentOffset;
    [self.scrollView addSubview:viewController.view];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
