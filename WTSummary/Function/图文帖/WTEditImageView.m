//
//  WTEditImageView.m
//  WTSummary
//
//  Created by piyingke on 17/7/7.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTEditImageView.h"

typedef enum {
    ButtonTypeEdit = 0,
    ButtonTypeDelete,
    ButtonTypeMove,
    ButtonTypeShow
}ButtonType;

@interface WTEditImageView ()

/** 图片 */
@property (nonatomic, strong) YYAnimatedImageView * imageView;
@property (nonatomic, strong) UILabel  * titleLabel;
@property (nonatomic, strong) UIButton * showButton;
@property (nonatomic, strong) UIButton * editButton;
@property (nonatomic, strong) UIButton * deleteButton;
/** uiview */
@property (nonatomic , strong) UIView * contentView;

@end

@implementation WTEditImageView

- (instancetype)initWithDataSourece:(id<WTEditImageViewDataSource>)dataSource{
    
    if (self = [super init]) {
        
        // 图片
        _imageView = [[YYAnimatedImageView alloc] init];
        [self addSubview:_imageView];
        
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        
        // 显示按钮
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * mormalImage = [UIImage imageNamed:@"ic_close_white"];
        UIImage * selectImage = [mormalImage imageRotatedByRadians:M_PI * 0.25];
        _showButton.tag = ButtonTypeShow;
        [_showButton setImage:selectImage forState:UIControlStateNormal];
        [_showButton setImage:mormalImage forState:UIControlStateSelected];
        [_showButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_showButton];
        _showButton.backgroundColor = WTRandomColor;
        
        // 编辑按钮
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_editButton];
        _editButton.tag = ButtonTypeEdit;
        [_editButton setImage:[UIImage imageNamed:@"ic_edit"] forState:UIControlStateNormal];
//        _editButton.hidden = !_showButton.selected;
        [_editButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _editButton.backgroundColor = WTRandomColor;
        
        // 删除按钮
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_deleteButton];
        _deleteButton.tag = ButtonTypeDelete;
        [_deleteButton setImage:[UIImage imageNamed:@"ic_trash_shadow"] forState:UIControlStateNormal];
//        _deleteButton.hidden = !_showButton.selected;
        [_deleteButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.backgroundColor = WTRandomColor;
        
        
    }
    
    return self;
}

- (void)ButtonClick:(UIButton *)button{
    
    switch (button.tag) {
        case ButtonTypeShow:
        {          
            _editButton.hidden = _deleteButton.hidden = self.showButton.selected;
            button.selected = !button.selected;

        }
            break;
        case ButtonTypeDelete:
        {
            if (self.deleteBlock) self.deleteBlock(self);
        }
            break;
        case ButtonTypeEdit:
        {
            if (self.editBlock) self.editBlock(self);
        }
            break;
        case ButtonTypeMove:
        {
//            if (self.moveBlock) self.moveBlock(self);
        }
            break;
            
        
    }
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGFloat itemWH = 30;
    CGFloat margin = 15;
    CGFloat y = self.frame.size.height - margin - itemWH;
    
    CGFloat contentviewW = itemWH * 3 + margin * 2;
    NSLog(@"777 ");
  
    self.contentView.frame = CGRectMake(self.frame.size.width - contentviewW - margin, y, contentviewW, itemWH);
    self.editButton.layer.cornerRadius = self.deleteButton.layer.cornerRadius = self.showButton.layer.cornerRadius = itemWH / 2;
    self.editButton.layer.masksToBounds = self.deleteButton.layer.masksToBounds = self.showButton.layer.masksToBounds = YES;
    self.editButton.frame = CGRectMake(0, 0, itemWH, itemWH);
    self.deleteButton.frame = CGRectMake(CGRectGetMaxX(self.editButton.frame) + margin, 0, itemWH, itemWH);
    self.showButton.frame = CGRectMake(CGRectGetMaxX(self.deleteButton.frame) + margin , 0, itemWH, itemWH);


}

- (void)setImage:(id)image{
    
    _image = image;
    if ([image isKindOfClass:[UIImage class]]) {
        self.imageView.image = image;
    }
}


@end
