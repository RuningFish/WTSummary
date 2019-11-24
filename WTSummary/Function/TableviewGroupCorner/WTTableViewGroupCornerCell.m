//
//  WTTableViewGroupCornerCell.m
//  WTSummary
//
//  Created by wangtian on 2019/11/24.
//  Copyright © 2019 飞奔的小鲨鱼. All rights reserved.
//

#import "WTTableViewGroupCornerCell.h"

@interface WTTableViewGroupCornerCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation WTTableViewGroupCornerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"WTTableViewGroupCornerCell";
    WTTableViewGroupCornerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WTTableViewGroupCornerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]){

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor orangeColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize: 16];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(10);
            make.right.offset(-10);
            make.bottom.offset(-10);
        }];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setFrame:(CGRect)frame{
    CGFloat margin = 10;
    frame.origin.x = margin;
    frame.size.width = frame.size.width-margin*2;
    [super setFrame:frame];
}

@end
