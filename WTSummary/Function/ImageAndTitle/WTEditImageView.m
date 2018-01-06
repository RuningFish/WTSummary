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
/** 标题 */
@property (nonatomic, strong) UILabel  * titleLabel;
/** 展开按钮 */
@property (nonatomic, strong) UIButton * showButton;
/** 编辑 */
@property (nonatomic, strong) UIButton * editButton;
/** 删除 */
@property (nonatomic, strong) UIButton * deleteButton;
/** uiview */
@property (nonatomic , strong) UIView * contentView;

@end

@implementation WTEditImageView

- (instancetype)initWithDataSourece:(id<WTEditImageViewDataSource>)dataSource{
    
    if (self = [super init]) {
        
        // 图片
        _imageView = [[YYAnimatedImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewLongPress)];
        [_imageView addGestureRecognizer:longPress];
        
        // 存放按钮的view
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        [_imageView addSubview:self.contentView];
        
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
        _editButton.hidden = !_showButton.selected;
        [_editButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _editButton.backgroundColor = WTRandomColor;
        
        // 删除按钮
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_deleteButton];
        _deleteButton.tag = ButtonTypeDelete;
        [_deleteButton setImage:[UIImage imageNamed:@"ic_trash_shadow"] forState:UIControlStateNormal];
        _deleteButton.hidden = !_showButton.selected;
        [_deleteButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.backgroundColor = WTRandomColor;
        
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _title = @"";
        self.margin = 5;
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        _uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
    }
    
    return self;
}

- (void)ButtonClick:(UIButton *)button{
    
    switch (button.tag) {
        case ButtonTypeShow:
        {          
            _editButton.hidden = _deleteButton.hidden = self.showButton.selected;
            button.selected = !button.selected;
            NSLog(@"Show");

        }
            break;
        case ButtonTypeDelete:
        {
            if (self.deleteBlock) self.deleteBlock(self);
            NSLog(@"deleteBlock");
        }
            break;
        case ButtonTypeEdit:
        {
            if (self.editBlock) self.editBlock(self);
            NSLog(@"editBlock");
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
    
    
    // 图片与图片之间的间距
    
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.imageH);
    
    if (self.title.length > 0) {
        
        CGFloat titleLabelY = CGRectGetMaxY(self.imageView.frame) + self.margin;
        // 有文字
        self.titleLabel.frame = CGRectMake(30, titleLabelY, self.frame.size.width - 60, self.frame.size.height - titleLabelY - self.margin);
    }else{
        // 没有图片的描述
        self.titleLabel.frame = CGRectZero;
    }
    
    CGFloat itemWH = 30;
    CGFloat margin = 15;
    
    CGFloat y = CGRectGetMaxY(self.imageView.frame) - margin - itemWH;
    
    CGFloat contentviewW = itemWH * 3 + margin * 2;
  
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

- (void)setTitle:(NSString *)title{
    
    _title = title;
    self.titleLabel.text = title;
}

- (void)imageViewLongPress{}
@end
