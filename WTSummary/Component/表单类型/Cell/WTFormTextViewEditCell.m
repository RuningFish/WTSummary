//
//  WTFormTextViewEditCell.m
//  WTSummary
//
//  Created by piyingke on 2018/1/18.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTFormTextViewEditCell.h"
#import "WTFormTextViewEditItem.h"
#import "UITextView+Placeholder.h"
@implementation WTFormTextViewEditCell

- (instancetype)initWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier item:(WTFormTextViewEditItem *)item{
    if (self = [super initWithTableView:tableView reuseIdentifier:identifier item:item]) {
        self.textView = [[UITextView alloc] init];
        [self.contentView addSubview:self.textView];
        self.textView.backgroundColor = [UIColor yellowColor];
        [self.textView resignFirstResponder];
        self.textView.font = [UIFont systemFontOfSize:15];
//        [self.textView setPlaceholder:item.placeholder placeholderColor:item.placeholderColor];
        self.textView.placeholder = item.placeholder;
        self.textView.placeholderColor = item.placeholderColor;
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(10, 10, 100, 20);
    CGFloat textViewY = CGRectGetMaxY(self.titleLabel.frame) + 5;
    self.textView.frame = CGRectMake(10, textViewY, self.frame.size.width - 20, self.frame.size.height - textViewY - 10);
}
@end
