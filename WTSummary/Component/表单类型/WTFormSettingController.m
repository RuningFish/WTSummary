//
//  WTFormSettingController.m
//  WTSummary
//
//  Created by piyingke on 2018/1/17.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//  账号设置的页面 (用于展示各种类型的样式)

#import "WTFormSettingController.h"
#import "WTFormBaseItem.h"
#import "WTFormEditItem.h"
#import "WTFormDefaultCell.h"
#import "WTFormEditCell.h"
#import "WTFormSelectCell.h"
#import "WTFormSelectItem.h"
#import "WTFormTextViewEditCell.h"
#import "WTFormTextViewEditItem.h"
#import "WTFormSectionItem.h"

@interface WTFormSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) NSMutableArray * data;
//@property (nonatomic ,assign) CGFloat offsetY; // 键盘弹起时需要移动的offset
//@property (nonatomic ,assign) BOOL keyboardShow; // 记录键盘是否弹起
@end

@implementation WTFormSettingController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray * data = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    WTFormBaseItem * item0 = [WTFormBaseItem itemWithImage:[UIImage imageNamed:@"profile_setting"] title:@"设置" arrowImage:[UIImage imageNamed:@"go"] cellType:WTFormCellTypeDefault];
    item0.selectBlock = ^(WTFormBaseItem * item){
      NSLog(@"item.title %@",item.title);
    };
    
    WTFormBaseItem * item1 = [WTFormBaseItem itemWithImage:[UIImage imageNamed:@"profile_feedback"] title:@"意见反馈" arrowImage:[UIImage imageNamed:@"go"] cellType:WTFormCellTypeDefault];
    item1.selectBlock = ^(WTFormBaseItem * item){
        NSLog(@"item.title %@",item.title);
    };
    
    WTFormEditItem * item2 = [WTFormEditItem itemWithImage:[UIImage imageNamed:@"profile_feedback"] title:@"个性签名" arrowImage:[UIImage imageNamed:@"go"] cellType:WTFormCellTypeEdit];
    item2.placeholder = @"请输入签名";
    item2.selectBlock = ^(WTFormBaseItem * item){
        NSLog(@"item.title %@",item.title);
    };
    
    WTFormSelectItem * item3 = [WTFormSelectItem itemWithImage:[UIImage imageNamed:@"profile_feedback"] title:@"性别" arrowImage:[UIImage imageNamed:@"go"] cellType:WTFormCellTypeSelect];

    WTFormTextViewEditItem * item4 = [WTFormTextViewEditItem itemWithImage:nil title:@"个人简介" arrowImage:nil cellType:WTFormCellTypeTextViewEdit];
    item4.placeholder = @"请输入你的简介";
    item4.placeholderColor = [UIColor lightGrayColor];
    
    [data addObject:item0];
    [data addObject:item1];
    [data addObject:item2];
    [data addObject:item3];
    [data addObject:item4];
    
    for (int i = 0; i < 5; i ++) {
        WTFormSectionItem * sectionItem = [[WTFormSectionItem alloc] init];
        sectionItem.cellItems = data;
        sectionItem.headerHeight = 40;
        sectionItem.headerColor = WTRandomColor;
//        sectionItem.footerHeight = 30;
        sectionItem.headerTitleColor = [UIColor whiteColor];
        sectionItem.footerColor = [UIColor redColor];
        sectionItem.headerTitle = [NSString stringWithFormat:@"这是第%d组头 --- ",i];
        sectionItem.footerTitle = [NSString stringWithFormat:@"这是第%d组尾 --- ",i];
        [self.data addObject:sectionItem];
    }

    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidhide:) name:UIKeyboardDidHideNotification object:nil];
}

- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)keyboardDidShow:(NSNotification *)noti{
    
    NSDictionary * userInfo = noti.userInfo;
    NSValue * value = [userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGRect keyboardRect = [value CGRectValue];
    CGSize contentSize = self.tableView.contentSize;
    // 键盘的高度
    CGFloat keyboardHeight = keyboardRect.size.height;
    if (!keyboardHeight) return;
    // 需要移动的高度
    CGFloat offsetY = self.view.frame.size.height - keyboardHeight - contentSize.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.contentOffset = CGPointMake(0, fabs(offsetY));
    }];
}

- (void)keyboardDidhide:(NSNotification *)noti{
    NSDictionary * userInfo = noti.userInfo;
    NSValue * value = [userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGRect keyboardRect = [value CGRectValue];
    CGSize contentSize = self.tableView.contentSize;
    // 键盘的高度
    CGFloat keyboardHeight = keyboardRect.size.height;
    // 需要移动的高度
    CGFloat offsetY = self.view.frame.size.height - keyboardHeight - contentSize.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.contentOffset = CGPointMake(0, -fabs(offsetY));
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    WTFormSectionItem * sectionItem = self.data[section];
    return sectionItem.cellItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    WTFormSectionItem * sectionItem = self.data[indexPath.section];
    WTFormBaseItem * item = sectionItem.cellItems[indexPath.row];
    NSString * reuseIdentifier = @"";
    if (item.formCellType == WTFormCellTypeDefault) {
        reuseIdentifier = @"defaultCell";
        WTFormBaseCell * cell = [[WTFormBaseCell alloc] initWithTableView:tableView reuseIdentifier:reuseIdentifier item:item];
        return cell;
    }
    else if (item.formCellType == WTFormCellTypeEdit){
        reuseIdentifier = @"editCell";
        WTFormEditCell * cell = [[WTFormEditCell alloc] initWithTableView:tableView reuseIdentifier:reuseIdentifier item:item];
        return cell;
    }
    else if (item.formCellType == WTFormCellTypeSelect){
        reuseIdentifier = @"selectCell";
        WTFormSelectCell * cell = [[WTFormSelectCell alloc] initWithTableView:tableView reuseIdentifier:reuseIdentifier item:item];
        return cell;
    }
    else if (item.formCellType == WTFormCellTypeTextViewEdit){
        reuseIdentifier = @"TextViewCell";
        WTFormTextViewEditCell * cell = [[WTFormTextViewEditCell alloc] initWithTableView:tableView reuseIdentifier:reuseIdentifier item:item];
        return cell;
    }
    else{
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__func__);
    WTFormSectionItem * sectionItem = self.data[indexPath.section];
    WTFormBaseItem * item = sectionItem.cellItems[indexPath.row];
    if (item.selectBlock) {
        item.selectBlock(item);
    }
    
    if ([item.title isEqualToString:@"性别"]) {
        [self.view endEditing:YES];
        WTFormSelectCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        WTFormSelectItem * selectItem = (WTFormSelectItem *)item;
            NSLog(@"item.title %@",item.title);
            WTAlertController * alert = [WTAlertController alertControllerWithTitle:nil message:nil preferredStyle:WTAlertControllerStyleActionSheet];
            WTAlertAction * action1 = [WTAlertAction actionWithTitle:@"男" style:WTAlertActionStyleDefault handler:^(WTAlertAction * _Nullable action) {
                selectItem.selectTitle = action.title;
                cell.item = selectItem;
                NSLog(@"select - > %@",action.title);
            }];
            
            WTAlertAction * action2 = [WTAlertAction actionWithTitle:@"女" style:WTAlertActionStyleDefault handler:^(WTAlertAction * _Nullable action) {
                selectItem.selectTitle = action.title;
                cell.item = selectItem;
                NSLog(@"select - > %@",action.title);
            }];
            
            WTAlertAction * cancel = [WTAlertAction actionWithTitle:@"取消" style:WTAlertActionStyleCancel handler:nil];
            
            [alert addAction:action1];
            [alert addAction:action2];
            [alert addAction:cancel];
            [alert show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WTFormSectionItem * sectionItem = self.data[indexPath.section];
    WTFormBaseItem * item = sectionItem.cellItems[indexPath.row];
    CGFloat cellHeight = 50;
    if (item.formCellType == WTFormCellTypeTextViewEdit) {
        cellHeight = 150;
    }
    
    return cellHeight;
}

#pragma mark - header and footer
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    WTFormSectionItem * sectionItem = self.data[section];
    return sectionItem.headerHeight > 0?sectionItem.headerHeight:0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    WTFormSectionItem * sectionItem = self.data[section];
    return sectionItem.footerHeight > 0?sectionItem.footerHeight:0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WTFormSectionItem * sectionItem = self.data[section];
    UIView * headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, sectionItem.headerHeight);
    headerView.backgroundColor = sectionItem.headerColor;
    if (sectionItem.headerTitle) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width - 20, headerView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"%@",sectionItem.headerTitle];
        label.textColor = sectionItem.headerTitleColor;
        label.backgroundColor = [UIColor clearColor];
        [headerView addSubview:label];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    WTFormSectionItem * sectionItem = self.data[section];
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, sectionItem.footerHeight);
    footerView.backgroundColor = sectionItem.footerColor;
    if (sectionItem.footerTitle) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, footerView.frame.size.width - 20, footerView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"%@",sectionItem.headerTitle];
        label.textColor = sectionItem.headerTitleColor;
        label.backgroundColor = [UIColor clearColor];
        [footerView addSubview:label];
    }
    return footerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
     WTFormSectionItem * sectionItem = self.data[section];
    return sectionItem.headerTitle?sectionItem.headerTitle:@"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    WTFormSectionItem * sectionItem = self.data[section];
    return sectionItem.footerTitle?sectionItem.footerTitle:@"";
}
@end
