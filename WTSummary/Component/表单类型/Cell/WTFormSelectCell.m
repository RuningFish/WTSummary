//
//  WTFormSelectCell.m
//  WTSummary
//
//  Created by piyingke on 2018/1/18.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTFormSelectCell.h"
#import "WTFormSelectItem.h"
@implementation WTFormSelectCell

- (instancetype)initWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier item:(WTFormSelectItem *)item{
    if (self = [super initWithTableView:tableView reuseIdentifier:identifier item:item]) {
        self.selectLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.selectLabel];
        self.selectLabel.font = [UIFont systemFontOfSize:15];
        self.selectLabel.textColor = [UIColor blackColor];
        self.selectLabel.textAlignment = NSTextAlignmentRight;
        self.selectLabel.backgroundColor = [UIColor greenColor];
        self.selectLabel.textAlignment = NSTextAlignmentRight;
        
        self.item = item;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat selectHeight = 25;
    CGFloat selectY = (self.frame.size.height - selectHeight)*0.5;
    CGFloat selectWidth = 50;
    CGFloat selectX = CGRectGetMinX(self.arrowImage.frame) - selectWidth;
    
    self.selectLabel.frame = CGRectMake(selectX, selectY, selectWidth, selectHeight);
}

- (void)setItem:(WTFormSelectItem *)item{
    _item = item;
    if (item.selectTitle) {
       self.selectLabel.text = [NSString stringWithFormat:@"%@",item.selectTitle];
    }
}
@end
