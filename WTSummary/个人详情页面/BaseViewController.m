//
//  BaseViewController.m
//  123
//
//  Created by piyingke on 2017/11/11.
//  Copyright © 2017年 piyingke. All rights reserved.
//

// 子控制器滚动发出的通知
NSString * const ChildScrollViewDidScrollNotification = @"ChildScrollViewDidScrollNotification";
NSString * const ChildScrollingView = @"ChildScrollingView";
NSString * const ChildScrollingOffset = @"ChildScrollingOffset";

#import "BaseViewController.h"

@interface BaseViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger rowCount;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.scrollView = self.tableView;
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetDifference = scrollView.contentOffset.y - self.lastContentOffset.y;
    // 滚动时发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ChildScrollViewDidScrollNotification object:nil userInfo:@{ChildScrollingView:scrollView,ChildScrollingOffset:@(offsetDifference)}];
    self.lastContentOffset = scrollView.contentOffset;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID = @"PersonalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行",indexPath.row];
    return cell;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];

        // 如果隐藏系统的导航栏 则减去状态栏的高度,如果没有隐藏，则需要减去状态栏和导航栏的高度
        CGFloat topMargin = KBaseViewHeadViewH + KBaseViewPageControlH - KBaseViewNavigationH;
        _tableView.contentInset = UIEdgeInsetsMake(topMargin, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}


@end
