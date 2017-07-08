//
//  TestThreeViewController.m
//  WTSummary
//
//  Created by piyingke on 17/7/7.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "TestThreeViewController.h"

@interface TestThreeViewController ()
@property (nonatomic ,strong) UIImageView * imageView;
@property (nonatomic ,strong) UILabel * label;

@end

@implementation TestThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.label];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
        
    } completion:^(BOOL finished) {
        NSLog(@"完成");
        self.label.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 20, self.view.frame.size.width, 30);
        self.label.hidden = NO;
    }];
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - self.cellFrame.size.height, self.cellFrame.size.width, self.cellFrame.size.height)];
        _imageView.backgroundColor = [UIColor greenColor];
    }
    return _imageView;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.text = @"回复 i 都是废话 i 史蒂夫 i 上班看见方便快捷地方就是大家反馈就是你放假开始动脑筋";
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor redColor];
        _label.hidden = YES;
    }
    return _label;
}
@end
