//
//  WTDisplayViewController.m
//  WTSummary
//
//  Created by piyingke on 2018/1/8.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTDisplayViewController.h"
#import "WTDisplayView.h"

@interface WTDisplayViewController ()<WTDisplayViewDelegate>

@end

@implementation WTDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray * imageUrl = @[
                           @"http://dingyue.nosdn.127.net/t=prgpYvGxliwgCAxRynPRtCyiato1AYjF8D2zzhQCpVo1515069797558compressflag.jpeg",
                         @"http://dingyue.nosdn.127.net/NLQohuCc3xMbptePsU6NUmf4Jbcj098nMRinJFu5wBTY21515200911906compressflag.jpeg",
                         @"http://cms-bucket.nosdn.127.net/d7bb520b22234925b8ba3a914b63651a20180108101134.jpeg",
                         @"http://dingyue.nosdn.127.net/YwLMg3vXIB2mx6hBZH0JTU7N=qOjVMhlp7Rx9j=pXdiz81515114292886compressflag.png",
                         @"http://dingyue.nosdn.127.net/mgDinSuHFAllFvciZZ1hM5g2xr=s1pxhVLbXfs2pPubpS1515135072608compressflag.jpeg"
                       ];
    
    NSArray * titles = @[@"蛋糕 ～～哈哈",@"新款passat 隆重上市！",@"",@"斗鱼主播陈一发",@"刚出锅的玉米喽～"];
    CGFloat disWidth = self.view.frame.size.width;
    CGFloat disHeight = disWidth/16*9;
    WTDisplayView * displayView = [WTDisplayView displayViewWithFrame:CGRectMake(0, 80, disWidth, disHeight) delegate:self placeholderImage:nil];
    displayView.images = imageUrl;
    displayView.titles = titles;
    [self.view addSubview:displayView];
//    displayView.pageAligment = WTDisplayViewPageControlAligmentRight;
//    displayView.scrollDirection = UICollectionViewScrollDirectionVertical;
    displayView.clickItemAtIndexBlock = ^(NSInteger selectIndex){
        NSLog(@"点击了 ===== %ld",selectIndex);
    };
    
    WTDisplayView * displayView2 = [WTDisplayView displayViewWithFrame:CGRectMake(0, CGRectGetMaxY(displayView.frame) + 20, disWidth, 40) delegate:self placeholderImage:nil];
    [self.view addSubview:displayView2];
    displayView2.backgroundColor = [UIColor greenColor];
    NSArray * titles2 = @[@"蛋糕 ～～哈哈",@"新款passat 隆重上市！",@"titles2",@"斗鱼主播陈一发",@"刚出锅的玉米喽～"];
    displayView2.titles = titles2;
    displayView2.displayText = YES;
    displayView2.scrollDirection = UICollectionViewScrollDirectionVertical;
    [displayView2 disableScroll];
    
    displayView2.clickItemAtIndexBlock = ^(NSInteger selectIndex){
        NSLog(@"点击了 ===== %ld",selectIndex);
    };
    
    NSArray * images3 = @[@"image_1.jpg",@"image_2.jpg",@"image_3.jpg",@"image_4.jpg",@"image_5.jpg",@"image_6.jpg",@"image_7.jpg",@"image_8.jpg",@"image_9.jpg"];
    
    WTDisplayView * displayView3 = [WTDisplayView displayViewWithFrame:CGRectMake(0, CGRectGetMaxY(displayView2.frame) + 20, disWidth, disHeight) imageStringArray:images3];
    [self.view addSubview:displayView3];
    displayView3.backgroundColor = [UIColor greenColor];
    
    displayView3.pageTintColor = [UIColor redColor];
    displayView3.currentPageTintColor = [UIColor greenColor];
    displayView3.clickItemAtIndexBlock = ^(NSInteger selectIndex){
        NSLog(@"点击了 ===== %ld",selectIndex);
    };
}

@end
