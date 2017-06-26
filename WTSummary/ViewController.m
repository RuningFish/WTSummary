//
//  ViewController.m
//  WTSummary
//
//  Created by admin on 17/6/25.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"
#import "TestViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 300, 300)];
    v.center = self.view.center;
    [self.view addSubview:v];
    //v.backgroundColor = [UIColor colorWithHexString:@"#95704f"];
    
    [v addDottedLineColor:[UIColor redColor] lineWidth:1.0 lineHeight:20 margin:10];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    [self.view addSubview:imageView];
    imageView.image = [UIImage createImageWithColor:[UIColor colorWithHexString:@"#FF4F52"]];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [imageView addGestureRecognizer:tap];
    
}

- (void)tapGesture{
    TestViewController * test = [[TestViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}


@end
