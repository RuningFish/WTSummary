//
//  WTBrightnessView.m
//
//  Created by piyingke on 2017/10/27.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTBrightnessView.h"

@interface WTBrightnessView ()
/** 显示亮度图片 */
@property (nonatomic, strong) UIImageView * brightnessImageView;
/** 亮度 */
@property (nonatomic, strong) UILabel * brightnessTitle;
/** 亮度 */
@property (nonatomic, strong) UIView * brightnessValueView;
/** valueImage */
@property (nonatomic, strong) NSMutableArray * valueArray;

@end

static CGFloat brightnessWidth = 155;
@implementation WTBrightnessView

- (NSMutableArray *)valueArray{
    if (!_valueArray) {
       _valueArray = [NSMutableArray array];
    }
    return _valueArray;
}

+ (instancetype)sharedBrightnessView{
    
    static WTBrightnessView * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WTBrightnessView alloc] init];
    });
    return instance;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, brightnessWidth, brightnessWidth);
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        UIToolbar * toolbar = [[UIToolbar alloc] init];
        toolbar.frame = self.bounds;
        toolbar.alpha = 0.97;
        [self addSubview:toolbar];
        
        // 亮度图片
        self.brightnessImageView = [[UIImageView alloc] init];
        self.brightnessImageView.image = [UIImage imageNamed:WTPlaybackBundle(@"ios_light@2x")];//[UIImage imageNamed:@"playback_brightness"];
        self.brightnessImageView.frame = CGRectMake(0, 0, 79, 79);
        [self addSubview:self.brightnessImageView];
        
        // 亮度
        self.brightnessTitle = [[UILabel alloc] init];
        self.brightnessTitle.frame = CGRectMake(0, 5, self.frame.size.width, 30);
        self.brightnessTitle.font = [UIFont boldSystemFontOfSize:16];
        self.brightnessTitle.textColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.0f];
        self.brightnessTitle.textAlignment = NSTextAlignmentCenter;
        self.brightnessTitle.text = @"亮度";
        [self addSubview:self.brightnessTitle];
        
        // 存放亮度值的view
        self.brightnessValueView = [[UIView alloc] init];
        CGFloat brightValueH = 7;
        CGFloat brightValueX = 13;
        CGFloat brightValueY = self.frame.size.width - 10 - brightValueH;
        CGFloat brightValueW = self.frame.size.width - brightValueX * 2;
        self.brightnessValueView.frame = CGRectMake(brightValueX, brightValueY, brightValueW, brightValueH);
        [self addSubview:self.brightnessValueView];
        self.brightnessValueView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.0f];
        
        // 添加value的值
        CGFloat valueW = (self.brightnessValueView.frame.size.width - 17)/16;
        CGFloat valueH = 5;
        CGFloat valueY = (brightValueH - valueH)/2;
        
        for (int i = 0; i < 16; i ++) {
            CGFloat valueX = i * (valueW + 1) + 1;
            UIView * valueView = [[UIView alloc] init];
            valueView.frame = CGRectMake(valueX, valueY, valueW, valueH);
            valueView.backgroundColor = [UIColor whiteColor];
            [self.brightnessValueView addSubview:valueView];
            [self.valueArray addObject:valueView];
            
        }
        
        // 在屏幕发生旋转的时候 更新约束
        [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(layoutSubviews)
                                     name:UIDeviceOrientationDidChangeNotification
                                           object:nil];
        // 监听屏幕亮度的变化
        [[UIScreen mainScreen] addObserver:self
                            forKeyPath:@"brightness"
                               options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;

    if (currentOrientation == UIDeviceOrientationPortrait) {
        self.transform = CGAffineTransformIdentity;
        self.center = CGPointMake(screenSize.width/2, screenSize.height/2);
    }
    else{
        CGFloat angle = (currentOrientation == UIDeviceOrientationLandscapeLeft)?M_PI_2:-M_PI_2;
        if (currentOrientation == UIDeviceOrientationLandscapeLeft) {
             [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        }
        else if (currentOrientation == UIDeviceOrientationLandscapeRight){
             [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
        }
        self.transform = CGAffineTransformMakeRotation(angle);
       
        self.center = CGPointMake(screenSize.height/2, screenSize.width/2);
    }
    
    self.brightnessImageView.center = CGPointMake(brightnessWidth/2, brightnessWidth/2);
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    CGFloat sound = [change[@"new"] floatValue];
    [self updateLongView:sound];
}

- (void)updateLongView:(CGFloat)sound {
    CGFloat stage = 1 / 15.0;
    NSInteger level = sound / stage;
    for (int i = 0; i < self.valueArray.count; i++) {
        UIView * value = self.valueArray[i];
        value.hidden = i <= level?NO:YES;
    }
}

- (void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 1.0;
    [self layoutSubviews];
}

- (void)dismiss{

    [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self dismissAtOnce];
    }];
}

- (void)dismissAtOnce{
    
    [self removeFromSuperview];
}
@end
