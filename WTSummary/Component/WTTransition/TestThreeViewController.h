//
//  TestThreeViewController.h
//  WTSummary
//
//  Created by piyingke on 17/7/7.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTTableViewCell;
@interface TestThreeViewController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic, assign) CGRect cellFrame;

@property (nonatomic, strong) UIColor * color;

@property (nonatomic ,strong) UIImageView * imageView;

/** <#desc#> */
@property (nonatomic , strong) UIColor * imageViewColor;

@property (nonatomic , strong) WTTableViewCell * cell;
@end
