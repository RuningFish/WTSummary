//
//  WTAlertController.m
//  WTSummary
//
//  Created by admin on 17/6/28.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#define KScreenSize [UIScreen mainScreen].bounds.size
/** 距屏幕左边的距离 */
#define KLeftMargin 10
/** 组间的间距 */
#define KSectionMargin 10
/** 粗体 */
#define KPingFangMedium @"PingFangSC-Medium"
#define KTextColor [UIColor colorWithRed:51/255.0 green:94/255.0 blue:247/255.0 alpha:1.0]
#define KDevideLineColor [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]
#define IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#import "WTAlertController.h"
#import <objc//runtime.h>
@interface WTAlertController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIView * tableHeadView;
/** 标题 */
@property (nonatomic , copy)   NSString * title;
/** 提示语 */
@property (nonatomic , copy)   NSString * message;
/** 弹框的样式 actionSheet alert */
@property (nonatomic , assign) WTAlertControllerStyle alertStyle;
/** 黑色的背景框 */
@property (nonatomic , strong) UIView * backgroundView;
/** 用于展示的tableview */
@property (nonatomic , strong) UITableView * tableView;
/** 存放 WTAlertActionStyleDefault 类型的item */
@property (nonatomic , strong) NSMutableArray * listArray;
/** 存放除 WTAlertActionStyleCancel 类型的item */
@property (nonatomic , strong) NSMutableArray * cancelArray;

/** 样式为alert时的alertView */
@property (nonatomic , strong) UIView * alertView;
/** 样式为alert时的alertView 的宽度*/
@property (nonatomic , assign) CGFloat alertViewWidth;

@end

static NSString * const reuseIdentifier = @"cell";
/** alert / actionSheet cell的行高 */
static CGFloat const cellHeight = 50;

@implementation WTAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(WTAlertControllerStyle)alertStyle{
    
    WTAlertController * alert = [[self alloc] init];
    return [alert initWithTitle:title message:message preferredStyle:alertStyle];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(WTAlertControllerStyle)alertStyle{
    
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.alertStyle = alertStyle;
        
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews{
    
    self.frame = CGRectMake(0, 0, KScreenSize.width, KScreenSize.height);
    [self addSubview:self.backgroundView];
    
    // sheet 样式
    if (self.alertStyle == WTAlertControllerStyleActionSheet) {
        [self addSubview:self.tableView];
    }else if (self.alertStyle == WTAlertControllerStyleAlert){
        // alert 样式
        self.alertViewWidth = IPAD?300:260;
        [self addSubview:self.alertView];
    }
    
}

#pragma mark - 黑色的背景
- (UIView *)backgroundView{
    
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.5;
        _backgroundView.userInteractionEnabled = YES;
    }
    return _backgroundView;
}

#pragma mark - 用于展示 sheet样式的tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 10;
        _tableView.clipsToBounds = YES;
        _tableView.rowHeight = cellHeight;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = self.tableHeadView;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}

#pragma mark - tableView的相关方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.cancelArray.count ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (self.cancelArray.count == 0 ?self.listArray.count:(section == 0 ? self.listArray.count:1));
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.textColor = KTextColor;
    
    if (self.cancelArray.count == 0) {
        // 一组
        WTAlertAction * action = self.listArray[indexPath.row];
        cell.textLabel.text = action.title;
        if (action.style == WTAlertActionStyleDestructive) {
            cell.textLabel.textColor = [UIColor redColor];
        }
        if (indexPath.row == self.listArray.count - 1) {
            [self addCornerRadius:cell];
        }
        
        // 添加分隔线
        UIView * devideLine = [[UIView alloc] init];
        [cell.contentView addSubview:devideLine];
        devideLine.backgroundColor = KDevideLineColor;
        devideLine.frame = CGRectMake(0, self.tableView.rowHeight - 0.5, self.tableView.frame.size.width, 0.5);
        
    }else if (self.cancelArray.count == 1){
        // 有取消类型 两组
        WTAlertAction * action;
        NSInteger cancelIndex = 0;
        if (indexPath.section == 0) {
            
            // 添加分隔线
            UIView * devideLine = [[UIView alloc] init];
            [cell.contentView addSubview:devideLine];
            devideLine.backgroundColor = KDevideLineColor;
            devideLine.frame = CGRectMake(0, self.tableView.rowHeight - 0.5, self.tableView.frame.size.width, 0.5);
            
            action = self.listArray[indexPath.row];
            cell.textLabel.text = action.title;
            // WTAlertActionStyleDestructive 类型的将文字颜色变红
            if (action.style == WTAlertActionStyleDestructive) {
                cell.textLabel.textColor = [UIColor redColor];
            }
            // 最后一个添加圆角
            if (indexPath.row == self.listArray.count - 1) {
                [self addCornerRadius:cell];
            }
        }else if (indexPath.section == 1){
            // 取消
            action = self.cancelArray[cancelIndex];
            cell.textLabel.text = action.title;
            cell.layer.cornerRadius = 10;
            cell.textLabel.font = [UIFont fontWithName:KPingFangMedium size:18];
            cell.layer.masksToBounds = YES;
        }
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - actionSheet样式的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WTAlertAction * action;
    if (indexPath.section == 0) {
        action = self.listArray[indexPath.row];
    }else if (indexPath.section == 1){
        if (self.cancelArray.count) {
            action = self.cancelArray[indexPath.row];
        }
    }
    
    [self alertControllerItemClickwithAction:action];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return KSectionMargin;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, KSectionMargin)];
    return footerView;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    //    [self show];
}

- (void)show {
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    if (self.alertStyle == WTAlertControllerStyleActionSheet) {
        _tableView.frame = CGRectMake(KLeftMargin, KScreenSize.height, KScreenSize.width - (KLeftMargin * 2), _tableView.rowHeight * (self.listArray.count + self.cancelArray.count) + self.tableHeadView.bounds.size.height + (KSectionMargin * 2));
        [UIView animateWithDuration:.25 animations:^{
            CGRect rect = _tableView.frame;
            rect.origin.y -= _tableView.bounds.size.height;
            _tableView.frame = rect;
        }];
    }else if (self.alertStyle == WTAlertControllerStyleAlert){
        CGFloat alertViewCellH = cellHeight;
        
        // alertView的总高度
        CGFloat alertViewH = (self.listArray.count <= 2)?self.tableHeadView.frame.size.height + alertViewCellH :(self.listArray.count * alertViewCellH + self.tableHeadView.frame.size.height);
        _alertView.frame = CGRectMake(0, 0, self.alertViewWidth, alertViewH);
        
        _alertView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        
        void (^alertViewCellBlock)(UIButton * alertViewCell,WTAlertAction * action) = ^(UIButton * alertViewCell,WTAlertAction * action){
            
            if (action.style == WTAlertActionStyleDestructive) {
                [alertViewCell setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }else{
                [alertViewCell setTitleColor:KTextColor forState:UIControlStateNormal];
            }
            alertViewCell.titleLabel.font = [UIFont systemFontOfSize:18];
            [alertViewCell addTarget:self action:@selector(alertViewCellClick:) forControlEvents:UIControlEventTouchUpInside];
            
        };
        
        // 创建 self.listArray 个数为2要单独处理布局
        if (self.listArray.count != 2) {
            for (int i = 0; i < self.listArray.count; i ++) {
                UIButton * alertViewCell = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.alertView addSubview:alertViewCell];
                CGFloat alertViewCellY = self.tableHeadView.frame.size.height + i * alertViewCellH;
                alertViewCell.frame = CGRectMake(0, alertViewCellY, self.alertViewWidth, alertViewCellH);
                WTAlertAction * action = self.listArray[i];
                alertViewCell.tag = i;
                [alertViewCell setTitle:[NSString stringWithFormat:@"%@",action.title] forState:UIControlStateNormal];
                alertViewCell.layer.borderColor = KDevideLineColor.CGColor;
                alertViewCell.layer.borderWidth = 0.4;
                alertViewCellBlock(alertViewCell,action);
            }
        }else{
            // 个数为2的情况排在一行
            CGFloat alertViewCellY = self.tableHeadView.frame.size.height;
            CGFloat alertViewCellWidth = self.alertViewWidth / 2;
            
            for (int i = 0; i < self.listArray.count; i ++) {
                UIButton * alertViewCell = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.alertView addSubview:alertViewCell];
                CGFloat alertViewCellX = alertViewCellWidth * i;
                alertViewCell.frame = CGRectMake(alertViewCellX, alertViewCellY, alertViewCellWidth, alertViewCellH);
                WTAlertAction * action = self.listArray[i];
                alertViewCell.tag = i;
                [alertViewCell setTitle:[NSString stringWithFormat:@"%@",action.title] forState:UIControlStateNormal];
                
                alertViewCellBlock(alertViewCell,action);
            }
            
            // 添加中间的分割线
            UIView * devideLine = [[UIView alloc] initWithFrame:CGRectMake(alertViewCellWidth, alertViewCellY, 0.5, alertViewCellH)];
            [self.alertView addSubview:devideLine];
            devideLine.backgroundColor = KDevideLineColor;
        }
        
    }
    
}

#pragma mark - alert样式中item的点击事件
- (void)alertViewCellClick:(UIButton *)button{
    
    WTAlertAction * action = self.listArray[button.tag];
    [self alertControllerItemClickwithAction:action];
}

#pragma mark - alert / actionSheet 中item的点击事件
- (void)alertControllerItemClickwithAction:(WTAlertAction *)action{
    
    Ivar ivar = class_getInstanceVariable([action class], "_actionBlock");
    id block = object_getIvar(action, ivar);
    if (block) {
        void (^WTAlertActionBlock)(WTAlertAction *) = block;
        WTAlertActionBlock(action);
    }
    
    [self dismiss];
}

- (void)dismiss {
    
    if (self.alertStyle == WTAlertControllerStyleActionSheet) {
        [UIView animateWithDuration:.25 animations:^{
            CGRect rect = _tableView.frame;
            rect.origin.y += _tableView.bounds.size.height;
            _tableView.frame = rect;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else if (self.alertStyle == WTAlertControllerStyleAlert){
        [self removeFromSuperview];
    }
    
    [self.listArray removeAllObjects];
    [self.cancelArray removeAllObjects];
}


- (UIView *)tableHeadView {
    
    if (!_tableHeadView) {
        CGFloat headHeight = 0.0f;
        CGFloat headWidth = (self.alertStyle == WTAlertControllerStyleActionSheet)? self.frame.size.width - KLeftMargin * 2 : self.alertViewWidth;
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, headWidth, headHeight)];
        _tableHeadView.backgroundColor = [UIColor whiteColor];
        
        // 0.标题的高度
        CGFloat titleH = (self.title.length > 0) ? 30 : 0;
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KLeftMargin, 10, self.tableHeadView.frame.size.width - KLeftMargin * 2, titleH)];
        titleLabel.text = self.title;
        titleLabel.font = [UIFont fontWithName:KPingFangMedium size:self.alertStyle == WTAlertControllerStyleActionSheet? 13.0:16];
        titleLabel.textColor = self.alertStyle == WTAlertControllerStyleActionSheet?[UIColor colorWithRed:73/255.0 green:75/255.0 blue:90/255.0 alpha:1]:[UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_tableHeadView addSubview:titleLabel];
        
        UIFont * messageFont = self.alertStyle == WTAlertControllerStyleActionSheet?[UIFont systemFontOfSize:16.0]:[UIFont systemFontOfSize:14.0];
        
        // 1.message的高度
        CGFloat messageWidth = titleLabel.frame.size.width - KLeftMargin * 2;
        CGFloat messageH = 0;
        if (self.message.length > 0) {
            messageH = [self.message boundingRectWithSize:CGSizeMake(messageWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:messageFont} context:nil].size.height;
        }
        
        CGFloat messageLabelX = CGRectGetMinX(titleLabel.frame);
        UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageLabelX + KLeftMargin, CGRectGetMaxY(titleLabel.frame), messageWidth, messageH)];
        messageLabel.text = self.message;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = [UIColor colorWithRed:173/255.0 green:174/255.0 blue:173/255.0 alpha:1.0];
        messageLabel.font = messageFont;
        messageLabel.numberOfLines = 0;
        [_tableHeadView addSubview:messageLabel];
        
        headHeight = CGRectGetMaxY(messageLabel.frame) + KSectionMargin;
        
        if (!self.title && !self.message) headHeight = 0;
        // line
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headHeight - 0.5, headWidth, 0.5)];
        line.backgroundColor = KDevideLineColor;
        [_tableHeadView addSubview:line];
        _tableHeadView.frame = CGRectMake(0, 0, headWidth, headHeight);
    }
    
    return _tableHeadView;
}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)cancelArray{
    if (!_cancelArray) {
        _cancelArray = [NSMutableArray array];
    }
    return _cancelArray;
}

#pragma mark - 给cell添加圆角
- (void)addCornerRadius:(UITableViewCell *)cell{
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:
                               CGRectMake(0, 0, KScreenSize.width - (KLeftMargin * 2), self.tableView.rowHeight) byRoundingCorners:
                               UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:
                               CGSizeMake(10, 10)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = cell.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.layer.mask = maskLayer;
}

- (void)addAction:(WTAlertAction *)action{
    
    if (self.alertStyle == WTAlertControllerStyleActionSheet) {
        if (action.style != WTAlertActionStyleCancel) {
            [self.listArray addObject:action];
        }else{
            if (self.cancelArray.count) return;
            [self.cancelArray addObject:action];
        }
    }else if (self.alertStyle == WTAlertControllerStyleAlert){
        [self.listArray addObject:action];
    }
    
}

#pragma mark - alertView相关
- (UIView *)alertView{
    if (!_alertView) {
        
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.alertViewWidth, 100)];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [_alertView addSubview:self.tableHeadView];
        _alertView.layer.cornerRadius = 10;
        _alertView.layer.masksToBounds = YES;
        UITapGestureRecognizer * alertViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertViewTap)];
        [_alertView addGestureRecognizer:alertViewTap];
        
    }
    return _alertView;
}
- (void)alertViewTap{}
@end

typedef void (^WTAlertActionBlock)(WTAlertAction *);
@interface WTAlertAction ()
@property (nullable, nonatomic, readwrite) NSString * title;
@property (nonatomic, readwrite) WTAlertActionStyle style;
@property (nonatomic ,copy) WTAlertActionBlock actionBlock;
@end

@implementation WTAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(WTAlertActionStyle)style handler:(void (^)(WTAlertAction *))handler{
    WTAlertAction * action = [[WTAlertAction alloc] init];
    action.title = title;
    action.style = style;
    if (handler) {
        action.actionBlock = handler;
    }
    return action;
}

@end

