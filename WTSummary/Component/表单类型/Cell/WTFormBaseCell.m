//
//  WTFormBaseCell.m
//  WTSummary
//
//  Created by piyingke on 2018/1/17.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTFormBaseCell.h"
#import "WTFormBaseItem.h"
@implementation WTFormBaseCell
{
    WTFormBaseItem *_item;
}
- (UIImageView *)baseCellImage{
    if (!_baseCellImage) {
        _baseCellImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_baseCellImage];
//         _baseCellImage.backgroundColor = [UIColor redColor];
    }
    return _baseCellImage;
}

- (UIImageView *)arrowImage{
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc] init];
        _arrowImage.contentMode = UIViewContentModeRight;
        [self.contentView addSubview:_arrowImage];
//        _arrowImage.backgroundColor = [UIColor blueColor];
    }
    return _arrowImage;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
//        _titleLabel.backgroundColor = [UIColor greenColor];
    }
    return _titleLabel;
}

- (UIView *)devideLine{
    if (!_devideLine) {
        _devideLine = [[UIView alloc] init];
        [self.contentView addSubview:_devideLine];
    }
    return _devideLine;
}

- (void)setDevideLineColor:(UIColor *)devideLineColor{
    _devideLineColor = devideLineColor;
    self.devideLine.backgroundColor = devideLineColor;
}

- (instancetype)initWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier item:(WTFormBaseItem *)item{
    
    WTFormBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
   
    _item = item;
    self.baseCellImage.image = item.image;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",item.title];
    self.arrowImage.image = item.arrowImage;
    
    self.devideLineColor = [UIColor lightGrayColor];
    self.baseImageSize = CGSizeMake(20, 20);
    self.arrowImageSize = CGSizeMake(20, 20);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin = 10;
    self.devideLine.frame = CGRectMake(margin/2, self.frame.size.height - 0.5, self.frame.size.width - margin, 0.5);
    
    CGFloat imageY = (self.frame.size.height - self.baseImageSize.height)*0.5;
    CGRect  imageRect = {margin,imageY,self.baseImageSize};
    CGFloat arrowY = (self.frame.size.height - self.arrowImageSize.height)*0.5;
    CGRect  arrowRect = {self.frame.size.width - self.arrowImageSize.width - margin,arrowY,self.arrowImageSize};
    CGFloat titleHeight = 25;
    CGFloat titleY = (self.frame.size.height - titleHeight)*0.5;
    if (_item.image) {
        self.baseCellImage.frame = imageRect;
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.baseCellImage.frame) + margin, titleY, 100, titleHeight);
        if (_item.arrowImage) {
            self.arrowImage.frame = arrowRect;
        }
    }
    else{
        self.titleLabel.frame = CGRectMake(margin, titleY, 100, titleHeight);
        if (_item.arrowImage) {
            self.arrowImage.frame = arrowRect;
        }
    }
//    NSLog(@"layoutSubviews");
}
@end
