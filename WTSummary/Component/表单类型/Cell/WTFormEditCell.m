//
//  WTFormEditCell.m
//  WTSummary
//
//  Created by piyingke on 2018/1/18.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//  编辑的样式

#import "WTFormEditCell.h"
#import "WTFormEditItem.h"
@implementation WTFormEditCell

- (instancetype)initWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier item:(WTFormEditItem *)item{
    if (self = [super initWithTableView:tableView reuseIdentifier:identifier item:item]) {
        self.editField = [[UITextField alloc] init];
        [self.contentView addSubview:self.editField];
        self.editField.textAlignment = NSTextAlignmentRight;
        self.editField.textColor = [UIColor blackColor];
        self.editField.font = [UIFont systemFontOfSize:15];
        self.editField.backgroundColor = [UIColor yellowColor];
        self.item = item;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat editHeight = 25;
    CGFloat editY = (self.frame.size.height - editHeight)*0.5;
    CGFloat editMinx = CGRectGetMaxX(self.titleLabel.frame) + 10;
    CGFloat editMaxX = CGRectGetMinX(self.arrowImage.frame);
    CGFloat editWidth = editMaxX - editMinx;
    self.editField.frame = CGRectMake(editMinx, editY, editWidth, editHeight);
}

- (void)setItem:(WTFormEditItem *)item{
    _item = item;
    self.baseCellImage.image = item.image;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",item.title];
    self.arrowImage.image = item.arrowImage;
    self.editField.placeholder = [NSString stringWithFormat:@"%@",item.placeholder];
}
@end
