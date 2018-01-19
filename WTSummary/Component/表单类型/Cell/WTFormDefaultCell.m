//
//  WTFormDefaultCell.m
//  WTSummary
//
//  Created by piyingke on 2018/1/17.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTFormDefaultCell.h"

@implementation WTFormDefaultCell

- (instancetype)initWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier item:(WTFormBaseItem *)item{
    WTFormDefaultCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [super initWithTableView:tableView reuseIdentifier:identifier item:item];
        self.item = item;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    CGFloat margin = 10;
//    CGFloat imageY = (self.frame.size.height - self.baseImageSize.height)*0.5;
//    CGRect  imageRect = {margin,imageY,self.baseImageSize};
//    CGFloat arrowY = (self.frame.size.height - self.arrowImageSize.height)*0.5;
//    CGRect  arrowRect = {self.frame.size.width - self.arrowImageSize.width - margin,arrowY,self.arrowImageSize};
//    CGFloat titleHeight = 25;
//    CGFloat titleY = (self.frame.size.height - titleHeight)*0.5;
//    if (self.item.image) {
//        self.baseCellImage.frame = imageRect;
//        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.baseCellImage.frame) + margin, titleY, 100, titleHeight);
//        if (self.item.arrowImage) {
//            self.arrowImage.frame = arrowRect;
//        }
//    }
//    else{
//        self.titleLabel.frame = CGRectMake(margin, titleY, 100, titleHeight);
//        if (self.item.arrowImage) {
//            self.arrowImage.frame = arrowRect;
//        }
//    }
//    NSLog(@"layoutSubviews");
}

- (void)setItem:(WTFormBaseItem *)item{
    _item = item;
    self.baseCellImage.image = item.image;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",item.title];
    self.arrowImage.image = item.arrowImage;
    NSLog(@"setFormItem");
}
@end
