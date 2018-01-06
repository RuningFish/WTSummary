//
//  WTCardViewController.m
//  WTSummary
//
//  Created by piyingke on 2017/11/28.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTCardViewController.h"
#import "WTCardView.h"
#import "WTCardViewCell.h"
#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"
@interface WTCardViewController ()<WTCardViewDelegate,WTCardViewDataSource>
@property (nonatomic, strong) WTCardView * cardView;

@end

@implementation WTCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    NSString * net = [self internetStatus];
//    NSLog(@"net ==> %@",net);
    [self.view addSubview:self.cardView];
    [self.cardView reloadData];
}

- (NSInteger)numberOfItemsInCardView:(WTCardView *)cardView{
    return 20;
}

- (WTCardViewCell *)cardView:(WTCardView *)cardView cellAtIndex:(NSInteger)index{
    
    NSString * identifier = @"cardViewCell";
    WTCardViewCell * cell = [cardView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WTCardViewCell alloc] initWithReuseIdentifier:identifier];
        NSLog(@"新创建的 cardViewCell");
    }
    cell.label.text = [NSString stringWithFormat:@"%ld",index];
    NSLog(@"vvvvvv");
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    return cell;
    
}

- (WTCardView *)cardView{
    if (!_cardView) {
        CGFloat width = 260;
        CGFloat height = 400;
        CGFloat cardX = (self.view.frame.size.width - width)*0.5;
        CGFloat cardY = (self.view.frame.size.height - height)*0.5;
        _cardView = [[WTCardView alloc] initWithFrame:CGRectMake(cardX, cardY, width, height) andStyle:WTCardViewStyleStack];
        _cardView.delegate = self;
        _cardView.dataSource = self;
        _cardView.backgroundColor = [UIColor redColor];
    }
    return _cardView;
}

- (NSString *)internetStatus {
    
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"WIFI";
    switch (internetStatus) {
        case ReachableViaWiFi:
        {
            net = @"WIFI";
            break;
        }
        case ReachableViaWWAN:
        {
            
            net = @"蜂窝数据";
            break;
        }
        case NotReachable:
        {
            net = @"当前无网路连接";
            break;
        }
        case ReachableVia2G:
        {
            net = @"2G";
            break;
        }
        case ReachableVia3G:
        {
            net = @"3G";
            break;
        }
        case ReachableVia4G:
        {
            net = @"4G";
            break;
        }
        default:
            break;
    }
    
    return net;
}

@end
