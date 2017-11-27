//
//  WTPageControl.m
//  123
//
//  Created by piyingke on 2017/11/13.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#define  KPageControlTag 100
#define  KMaxTextScale 0.2
#define  KPageControlContentOffset @"contentOffset"

#import "WTPageControl.h"
@interface WTPageControlBottomLine : UIView

@end

@implementation WTPageControlBottomLine

@end

@interface WTPageControlItem : UIButton
/** 样式 */
@property (nonatomic, assign) WTPageControlItemStyle itemStyle;
/** 图片和文字之间的间距 */
@property (nonatomic, assign) CGFloat space;
/** 图片的大小 */
@property (nonatomic, assign) CGSize imageSize;
@end

@implementation WTPageControlItem

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){

    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{}

- (void)setItemStyle:(WTPageControlItemStyle)itemStyle{
    _itemStyle = itemStyle;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSpace:(CGFloat)space{
    _space = space;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setImageSize:(CGSize)imageSize{
    _imageSize = imageSize;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];

    if (self.itemStyle == WTPageControlItemStyleNone) return;
    
    CGFloat itemWidth  = self.frame.size.width;
    CGFloat itemHeight = self.frame.size.height;
    
    CGSize imageSize =  (self.imageSize.width) ? self.imageSize : self.imageView.frame.size;
    CGSize labelSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, itemHeight) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    labelSize.width = labelSize.width > itemWidth ? itemWidth : labelSize.width;
    
    CGFloat margin = self.space?self.space:0;

    CGFloat imageX = 0.0 ,imageY = 0.0 , labelX = 0.0 ,labelY = 0.0;
    
    switch (self.itemStyle) {
        case WTPageControlItemStyleTop:
            {
                imageX = (itemWidth - imageSize.width)*0.5;
                imageY = (itemHeight - imageSize.height - margin - labelSize.height)*0.5;
                labelX = (itemWidth - labelSize.width)*0.5;
                labelY = imageY + imageSize.height + margin;
                self.imageView.contentMode = UIViewContentModeBottom;
            }
            break;
            
        case WTPageControlItemStyleLeft:
            {
                
                imageX = (itemWidth - imageSize.width - labelSize.width - margin)*0.5;
                imageY = (itemHeight - imageSize.height)*0.5;
                labelX = imageX + imageSize.width + margin;
                labelY = (itemHeight - labelSize.height)*0.5;
                self.imageView.contentMode = UIViewContentModeRight;
            }
            break;
        case WTPageControlItemStyleBottom:
            {
                labelX = (itemWidth - labelSize.width)*0.5;
                labelY = (itemHeight - labelSize.height - imageSize.height - margin)*0.5;
                imageX = (itemWidth - imageSize.width)*0.5;
                imageY = labelY + labelSize.height + margin;
                self.imageView.contentMode = UIViewContentModeTop;
            }
            break;
        case WTPageControlItemStyleRight:
            {
                labelX = (itemWidth - imageSize.width - labelSize.width - margin)*0.5;
                labelY = (itemHeight - labelSize.height)*0.5;
                imageX = labelX + labelSize.width + margin;
                imageY = (itemHeight - imageSize.height)*0.5;
                self.imageView.contentMode = UIViewContentModeLeft;
            }
            break;
        case WTPageControlItemStyleImage:
        {
            // 只有图片
            imageX = (itemWidth - imageSize.width)*0.5;
            imageY = (itemHeight - imageSize.height)*0.5;
            self.imageView.contentMode = UIViewContentModeCenter;
        }
            break;
        case WTPageControlItemStyleTitle:
        {
            // 只有文字
            labelX = (itemWidth - labelSize.width)*0.5;
            labelY = (itemHeight - labelSize.height)*0.5;
            if (labelX < 0) labelX = 0;
        }
            break;
        case WTPageControlItemStyleNone:
        {
        }
            break;
            
    }
    
    self.imageView.frame = CGRectMake(imageX, imageY, imageSize.width, imageSize.height);
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
}
@end


@interface WTPageControl ()
@property (nonatomic, assign) WTPageControlStyle pageControlStyle;
@property (nonatomic, strong) NSArray * items;
/** */
@property (nonatomic, strong) NSMutableArray * pageControlItems;

/** contentView */
@property (nonatomic, weak)   UIView * contentView;
/** scrollView */
@property (nonatomic, weak)   UIScrollView * pageScrollView;
/** 选中的item */
@property (nonatomic, strong) WTPageControlItem * selectedItem;
/** 起始偏移量 */
@property (nonatomic, assign) CGFloat beginOffsetX;

/** 起始颜色 0 ～ 1*/
@property (nonatomic, assign) CGFloat beginR;
@property (nonatomic, assign) CGFloat beginG;
@property (nonatomic, assign) CGFloat beginB;
/** 结束颜色 0 ～ 1*/
@property (nonatomic, assign) CGFloat endR;
@property (nonatomic, assign) CGFloat endG;
@property (nonatomic, assign) CGFloat endB;

@end
@implementation WTPageControl

+ (instancetype)pageControlWithFrame:(CGRect)frame pageControlStyle:(WTPageControlStyle)pageControlStyle{
    return [[WTPageControl alloc] initWithFrame:frame pageControlStyle:pageControlStyle];
}

- (instancetype)initWithFrame:(CGRect)frame pageControlStyle:(WTPageControlStyle)pageControlStyle{
    
    if (self = [super init]) {
        self.frame = frame;
        self.pageControlStyle = pageControlStyle;
        self.itemColorGradient = YES;
        // 设置初始颜色
        [self setBeginColor:self.selectedItemTitleColor];
        // 设置结束颜色
        [self setEndColor:self.normalItemTitleColor];
        
    }
    return self;
}

- (void)setItems:(NSArray *)items selectedItemIndex:(NSUInteger)selectedItemIndex{
    _items = items;
    _selectedItemIndex = selectedItemIndex;
    
    for (int i = 0; i < items.count; i++) {
        id item = items[i];
        NSAssert(([item isKindOfClass:[NSString class]] || [item isKindOfClass:[UIImage class]]), @"items只能是NSString或UIImage类型的数组");
        [self addItemWithIndex:i item:item animated:NO];
    }
    

    if (self.pageControlItems.count) {
        WTPageControlItem * selectedItem = [self.pageControlItems objectAtIndex:selectedItemIndex];
        self.selectedItem = selectedItem;
        [self pageControlItemClick:selectedItem];
        
        [self.pageScrollView insertSubview:self.bottomLine atIndex:0];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (void)addItemWithIndex:(NSInteger)index item:(id)item animated:(BOOL)animated{
    
    // 插入
    
    WTPageControlItem * pageControlItem = [WTPageControlItem buttonWithType:UIButtonTypeCustom];
    [pageControlItem setTitleColor:_normalItemTitleColor forState:UIControlStateNormal];
    pageControlItem.titleLabel.font = _itemFont;
    [pageControlItem addTarget:self action:@selector(pageControlItemClick:) forControlEvents:UIControlEventTouchUpInside];
    pageControlItem.tag = KPageControlTag + index;
    
    if ([item isKindOfClass:[NSString class]]) {
        [pageControlItem setTitle:item forState:UIControlStateNormal];
    }
    else if ([item isKindOfClass:[UIImage class]]){
        [pageControlItem setImage:item forState:UIControlStateNormal];
    }
    
    
    [self.pageControlItems insertObject:pageControlItem atIndex:index];
    
//    pageControlItem.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    
    [self.pageScrollView addSubview:pageControlItem];
}

- (void)pageControlItemClick:(WTPageControlItem *)pageControlItem{
   
    [self.selectedItem setTitleColor:_normalItemTitleColor forState:UIControlStateNormal];
    [pageControlItem setTitleColor:_selectedItemTitleColor forState:UIControlStateNormal];
    
    CGFloat fromIndex = self.selectedItem ? self.selectedItem.tag - KPageControlTag : pageControlItem.tag - KPageControlTag;
    CGFloat toIndex = pageControlItem.tag - KPageControlTag;
    // 更新下item对应的下标,必须在代理之前，否则外界在代理方法中拿到的不是最新的,必须用下划线，用self.会造成死循环
    _selectedItemIndex = toIndex;
    
    [self performDelegateMethodFromIndex:fromIndex toIndex:toIndex];

    [self moveItemScrollViewWithSelectedButton:pageControlItem];
    
    if (self.pageControlStyle == WTPageControlStyleTextZoom) {
        pageControlItem.itemStyle = WTPageControlItemStyleNone;
        self.selectedItem.transform = CGAffineTransformIdentity;
        pageControlItem.transform = CGAffineTransformMakeScale(1+KMaxTextScale, 1+KMaxTextScale);
    } else {
        if (fromIndex != toIndex) { // 如果相等，说明是第一次进来，或者2次点了同一个，此时不需要动画
            [UIView animateWithDuration:0.25 animations:^{
                [self changeBottomLineFrameWithSelectedButton:pageControlItem];
            }];
        }
    }
    
    self.selectedItem = pageControlItem;
    
}

// 点击button让itemScrollView发生偏移
- (void)moveItemScrollViewWithSelectedButton:(WTPageControlItem *)selectedItem {
    if (CGRectEqualToRect(self.contentView.frame, CGRectZero)) {
        return;
    }
    // 转换点的坐标位置
    CGPoint centerInPageMenu = [self.contentView convertPoint:selectedItem.center toView:self];
    // CGRectGetMidX(self.backgroundView.frame)指的是屏幕水平中心位置，它的值是固定不变的
    CGFloat offSetX = centerInPageMenu.x - CGRectGetMidX(self.contentView.frame);
    
    // itemScrollView的容量宽与自身宽之差(难点)
    CGFloat maxOffsetX = self.pageScrollView.contentSize.width - self.pageScrollView.frame.size.width;
    // 如果选中的button中心x值小于或者等于itemScrollView的中心x值，或者itemScrollView的容量宽度小于itemScrollView本身，此时点击button时不发生任何偏移，置offSetX为0
    if (offSetX <= 0 || maxOffsetX <= 0) {
        offSetX = 0;
    }
    // 如果offSetX大于maxOffsetX,说明itemScrollView已经滑到尽头，此时button也发生任何偏移了
    else if (offSetX > maxOffsetX){
        offSetX = maxOffsetX;
    }
    
    [self.pageScrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

#pragma mark - 一些初始化的操作
- (void)initialize{
    
    self.backgroundColor = [UIColor whiteColor];
    _itemPadding = 30.0f;
    _itemFont = [UIFont systemFontOfSize:15];
    _normalItemTitleColor = [UIColor blackColor];
    _selectedItemTitleColor = [UIColor redColor];
    _contentInset = UIEdgeInsetsZero;
    _selectedItemIndex  = 0;
    _bottomLineHeight = 3.0f;
    
    UIView * contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    self.contentView = contentView;

    UIScrollView * pageScrollView = [[UIScrollView alloc] init];
    pageScrollView.showsVerticalScrollIndicator = NO;
    pageScrollView.showsHorizontalScrollIndicator = NO;
    [contentView addSubview:pageScrollView];
    self.pageScrollView = pageScrollView;
    
    contentView.backgroundColor = [UIColor clearColor];
    pageScrollView.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // contentView
    CGFloat contentViewX = self.bounds.origin.x + self.contentInset.left;
    CGFloat contentViewY = self.bounds.origin.y + self.contentInset.top;
    CGFloat contentViewW = self.bounds.size.width - (self.contentInset.left + self.contentInset.right);
    CGFloat contentViewH = self.bounds.size.height - (self.contentInset.top + self.contentInset.bottom);
    self.contentView.frame = CGRectMake(contentViewX, contentViewY, contentViewW, contentViewH);
    
    // bottomLine
    CGFloat bottomLineW = self.frame.size.width;
    CGFloat bottomLineH = (self.bottomLine.hidden || self.bottomLine.alpha == 0.0)? 0: self.bottomLineHeight;
    CGFloat bottomLineX = 0;
    CGFloat bottomLineY = self.frame.size.height - bottomLineH;
    self.bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
    
    // scrollView
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = contentViewW;
    CGFloat scrollViewH = self.frame.size.height;//contentViewH - bottomLineH;
    self.pageScrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    
    // 按钮的宽度
   __block CGFloat itemWidth = 0.0f;
   __block CGFloat lastItemMaxX = 0.0f;
    
    CGFloat contentWidth = 0.0f;
    CGFloat contentWidth_sum = 0.0f;
    NSMutableArray * tempWidths = [NSMutableArray array];
    for (int index = 0; index < self.pageControlItems.count; index ++) {
        WTPageControlItem * controlItem = [self.pageControlItems objectAtIndex:index];
        CGFloat textWidth = [controlItem.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, scrollViewH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.itemFont} context:nil].size.width;
        CGFloat imageWidth = controlItem.currentImage.size.width;
        if (controlItem.currentTitle && !controlItem.currentImage) {// 有文字,无图片
            contentWidth = textWidth;
        }
        else if (!controlItem.currentTitle && controlItem.currentImage){// 无文字,有图片
            contentWidth = imageWidth;
        }
        else if (controlItem.currentTitle && controlItem.currentImage){
            if (controlItem.itemStyle == WTPageControlItemStyleLeft || controlItem.itemStyle == WTPageControlItemStyleRight) {
                contentWidth = textWidth + imageWidth + controlItem.space;
            }
            
            else if (controlItem.itemStyle == WTPageControlItemStyleTop || controlItem.itemStyle == WTPageControlItemStyleBottom){
                contentWidth = MAX(textWidth, imageWidth);
            }
        }
        
        contentWidth_sum += contentWidth;
        [tempWidths addObject:@(contentWidth)];
    }
    
    CGFloat diff = scrollViewW - contentWidth_sum;
    
    [self.pageControlItems enumerateObjectsUsingBlock:^(WTPageControlItem * item, NSUInteger index, BOOL * _Nonnull stop) {
        
        if (self.layoutType == WTPageControlLayoutTypeAdaptContent) {
            itemWidth = [tempWidths[index] floatValue];
            if (index == 0) {
                item.frame = CGRectMake(_itemPadding * 0.5 + lastItemMaxX, 0, itemWidth, bottomLineY);
            }
            else{
                item.frame = CGRectMake(_itemPadding + lastItemMaxX, 0, itemWidth, bottomLineY);
            }
//            NSLog(@"index %ld frame = %@",index,NSStringFromCGRect(item.frame));
        }
        else if (self.layoutType == WTPageControlLayoutTypeEqualWidth){
            itemWidth = (scrollViewW - _itemPadding * self.pageControlItems.count) / self.pageControlItems.count;
            if (itemWidth < 0) itemWidth = 0;
            if (index == 0) {
                item.frame = CGRectMake(_itemPadding * 0.5 + lastItemMaxX, 0, itemWidth, bottomLineY);
            }
            else{
                item.frame = CGRectMake(_itemPadding + lastItemMaxX, 0, itemWidth, bottomLineY);
            }
        }
        
        else{
            _itemPadding = diff/self.pageControlItems.count;
            itemWidth = [[tempWidths objectAtIndex:index] floatValue];
            if (index == 0) {
                item.frame = CGRectMake(self.itemPadding * 0.5 + lastItemMaxX, 0, itemWidth, bottomLineY);
            }
            else{
                item.frame = CGRectMake(self.itemPadding + lastItemMaxX, 0, itemWidth, bottomLineY);
            }
        }

        lastItemMaxX = CGRectGetMaxX(item.frame);
        
    }];
    
    [self changeBottomLineFrameWithSelectedButton:self.selectedItem];
    
    self.pageScrollView.contentSize = CGSizeMake(lastItemMaxX + self.itemPadding * 0.5, 0);
}

- (void)changeBottomLineFrameWithSelectedButton:(WTPageControlItem *)selectedItem {
    
    CGFloat bottomLineX;
    CGFloat bottomLineY;
    CGFloat bottomLineW;
    CGFloat bottomLineH;
    
    CGFloat selectedButtonWidth = selectedItem.frame.size.width;
    
    switch (self.pageControlStyle) {
        case WTPageControlStyleLine:
        {
            bottomLineW = selectedButtonWidth;
            bottomLineH = _bottomLineHeight;
            bottomLineX = selectedItem.frame.origin.x;
            bottomLineY = self.pageScrollView.bounds.size.height - bottomLineH;
            self.bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
        }
            break;
        case WTPageControlStyleLineLongerThanItem:
        {
            bottomLineW = selectedButtonWidth+(selectedButtonWidth ? _itemPadding : 0);
            bottomLineH = _bottomLineHeight;
            bottomLineX = selectedItem.frame.origin.x;
            bottomLineY = self.pageScrollView.bounds.size.height - bottomLineH;
            self.bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
        }
            break;
        case WTPageControlStyleLineAttachment:
        {
            bottomLineW = selectedButtonWidth ? selectedItem.titleLabel.font.pointSize * 1.5 : 0; // 固定宽度为字体大小
            bottomLineH = _bottomLineHeight;
            bottomLineX = selectedItem.frame.origin.x;
            bottomLineY = self.pageScrollView.bounds.size.height - bottomLineH;
            self.bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
        }
            break;
        case WTPageControlStyleRect:
        {
            bottomLineW = selectedButtonWidth+(selectedButtonWidth ? _itemPadding : 0);
            bottomLineH = selectedItem.frame.size.height;
            bottomLineX = selectedItem.frame.origin.x;
            bottomLineY = 0;
            self.bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
            self.bottomLine.layer.cornerRadius = 0;
        }
            break;
        case WTPageControlStyleRoundRect:
        {
            bottomLineH = _itemFont.lineHeight + 10;
            bottomLineW = selectedButtonWidth+bottomLineH * 0.5;
            bottomLineX = selectedItem.frame.origin.x;
            bottomLineY = (selectedItem.frame.size.height-bottomLineH) * 0.5;
            self.bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
            self.bottomLine.layer.cornerRadius = MIN(bottomLineW, bottomLineH) * 0.5;
            self.bottomLine.layer.masksToBounds = YES;
            
        }
            break;
        case WTPageControlStyleTextZoom:{
            self.bottomLine.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    CGPoint bottomLineCenter = self.bottomLine.center;
    bottomLineCenter.x = selectedItem.center.x;
    self.bottomLine.center = bottomLineCenter;
}

#pragma mark - setter
- (void)setScrollView:(UIScrollView *)scrollView{
    if (scrollView) {
        _scrollView = scrollView;
        [scrollView addObserver:self forKeyPath:KPageControlContentOffset options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)setItemColorGradient:(BOOL)itemColorGradient{
    _itemColorGradient = itemColorGradient;
}

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex{
    
    _selectedItemIndex = selectedItemIndex;
    if (self.pageControlItems.count) {
        WTPageControlItem * item = [self.pageControlItems objectAtIndex:selectedItemIndex];
        [self pageControlItemClick:item];
    }
}

- (void)setLayoutType:(WTPageControlLayoutType)layoutType{
    _layoutType = layoutType;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setBottomLineBgColor:(UIColor *)bottomLineBgColor{
    _bottomLineBgColor = bottomLineBgColor;
    if (!self.bottomLine.hidden) {
        _bottomLine.backgroundColor = bottomLineBgColor;
    }
}

- (void)setSelectedItemTitleColor:(UIColor *)selectedItemTitleColor{
    _selectedItemTitleColor = selectedItemTitleColor;
    [self setBeginColor:_selectedItemTitleColor];
    [self.selectedItem setTitleColor:selectedItemTitleColor forState:UIControlStateNormal];
}

- (void)setItemPadding:(CGFloat)itemPadding{
    _itemPadding = itemPadding;
    for (WTPageControlItem * item in self.pageControlItems) {
        item.itemStyle = item.itemStyle;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self moveItemScrollViewWithSelectedButton:self.selectedItem];
}

- (void)setItemFont:(UIFont *)itemFont{
    _itemFont = itemFont;
    for (WTPageControlItem * item in self.pageControlItems) {
        item.titleLabel.font = itemFont;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self moveItemScrollViewWithSelectedButton:self.selectedItem];
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight{
    _bottomLineHeight = bottomLineHeight;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - 设置item的图片大小
- (void)setItemImageSize:(CGSize)itemImageSize{
    
    _itemImageSize = itemImageSize;
    for (WTPageControlItem * item in self.pageControlItems) {
        item.imageSize = itemImageSize;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - 设置item的样式
- (void)setItemStyle:(WTPageControlItemStyle)itemStyle{
    _itemStyle = itemStyle;
    for (WTPageControlItem * item in self.pageControlItems) {
        item.itemStyle = itemStyle;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
#pragma mark - getter
- (NSMutableArray *)pageControlItems{
    if (!_pageControlItems) {
        _pageControlItems = [NSMutableArray array];
    }
    return _pageControlItems;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor redColor];
        _bottomLine.layer.cornerRadius = self.bottomLineHeight * 0.5;
        _bottomLine.layer.masksToBounds = YES;
        
    }
    return _bottomLine;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object == self.scrollView && [keyPath isEqualToString:KPageControlContentOffset]) {
        [self beginMoveBottomLineWithScrollView:self.scrollView];
    }
}

- (void)beginMoveBottomLineWithScrollView:(UIScrollView *)scrollView{
    
    if (!scrollView.dragging && !scrollView.decelerating) return;
    
    // 判断临界值
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.bounds.size.width) return;
    
    static int i = 0;
    if (i == 0) {
        _beginOffsetX = scrollView.bounds.size.width * self.selectedItemIndex;
        i = 1;
    }
    
    // 当前的偏移量
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    // 偏移的进度
    CGFloat offsetProgress = currentOffsetX / scrollView.bounds.size.width;
    CGFloat progress = offsetProgress - floor(offsetProgress);
    
    NSInteger fromIndex;
    NSInteger toIndex;
    
    if (currentOffsetX - _beginOffsetX > 0) { // 向左拖拽
        //
        fromIndex = currentOffsetX / scrollView.bounds.size.width;
        toIndex = fromIndex + 1;
        if (toIndex >= self.pageControlItems.count) {
            toIndex = fromIndex;
        }
    }
    else if (currentOffsetX - _beginOffsetX < 0) { // 向右拖拽
        toIndex = currentOffsetX / scrollView.bounds.size.width;
        fromIndex = toIndex + 1;
        progress = 1.0 - progress;
    }
    else{
        progress = 1.0;
        fromIndex = self.selectedItemIndex;
        toIndex = fromIndex;
    }
    
    if (currentOffsetX == scrollView.bounds.size.width * fromIndex) {
        progress = 1.0;
        toIndex = fromIndex;
    }
    
    //
    if (currentOffsetX == scrollView.bounds.size.width * toIndex) {
        i = 0;
        self.selectedItemIndex = toIndex;
        return;
    }
    
    [self moveBottomLineWithProgress:progress fromIndex:fromIndex toIndex:toIndex currentOffsetX:currentOffsetX beginOffsetX:_beginOffsetX];
}

- (void)moveBottomLineWithProgress:(CGFloat)progress fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex currentOffsetX:(CGFloat)currentOffsetX beginOffsetX:(CGFloat)beginOffsetX{
    
    // 移动下划线
    WTPageControlItem * fromItem = self.pageControlItems[fromIndex];
    WTPageControlItem * toItem   = self.pageControlItems[toIndex];
    
    // 2个按钮之间的距离
    CGFloat xDistance = toItem.center.x - fromItem.center.x;
    // 2个按钮宽度的差值
    CGFloat wDistance = toItem.frame.size.width - fromItem.frame.size.width;
    
    CGRect  bottomLineFrame = self.bottomLine.frame;
    CGPoint bottomLineCenter = self.bottomLine.center;
    
    if (self.pageControlStyle == WTPageControlStyleLine) {
        bottomLineCenter.x = fromItem.center.x + xDistance * progress;
        bottomLineFrame.size.width = fromItem.frame.size.width + wDistance * progress;
        self.bottomLine.frame = bottomLineFrame;
        self.bottomLine.center = bottomLineCenter;
    }
    else if (self.pageControlStyle == WTPageControlStyleLineAttachment){
        CGFloat originW = fromItem.titleLabel.font.pointSize * 1.5;
        CGFloat originX = fromItem.frame.origin.x + (fromItem.frame.size.width - originW) * 0.5;
        
        if (currentOffsetX - _beginOffsetX >= 0) { // 向左拖拽
            if (progress < 0.5) {
                bottomLineFrame.origin.x = originX;
                bottomLineFrame.size.width = originW + xDistance * progress * 2;
            }
            else{
                bottomLineFrame.origin.x = originX + xDistance * (progress - 0.5) * 2;
                bottomLineFrame.size.width = originW + xDistance - xDistance * (progress - 0.5) * 2;
            }
        }
        else { // 向右拖拽
            if (progress < 0.5) {
                bottomLineFrame.origin.x = originX + xDistance * progress * 2;
                bottomLineFrame.size.width = originW - xDistance * progress * 2;
            }
            else{
                bottomLineFrame.origin.x = originX + xDistance;
                bottomLineFrame.size.width = originW - xDistance + xDistance * (progress - 0.5) * 2;
            }
            
        }
        
        self.bottomLine.frame = bottomLineFrame;
    }
    else if (self.pageControlStyle == WTPageControlStyleTextZoom){
        // 缩放文字
        [self itemTitleScaleWithProgress:progress fromItem:fromItem toItem:toItem];
    }
    else if (self.pageControlStyle == WTPageControlStyleRoundRect){
        
        bottomLineCenter.x = fromItem.center.x + xDistance * progress;
        bottomLineFrame.size.width = fromItem.frame.size.width + wDistance * progress + (_itemFont.lineHeight + 10) * 0.5;
        self.bottomLine.frame = bottomLineFrame;
        self.bottomLine.center = bottomLineCenter;
    }
    else{
        bottomLineCenter.x = fromItem.center.x + xDistance * progress;
        bottomLineFrame.size.width = fromItem.frame.size.width + wDistance * progress + _itemPadding;
        self.bottomLine.frame = bottomLineFrame;
        self.bottomLine.center = bottomLineCenter;
    }
    
    // 文字颜色渐变
    if (self.itemColorGradient) {
        [self itemTitleColorGradientWithProgress:progress fromItem:fromItem toItem:toItem];
    }
}

#pragma mark -缩放文字
- (void)itemTitleScaleWithProgress:(CGFloat)progress fromItem:(WTPageControlItem *)fromItem toItem:(WTPageControlItem *)toItem{
    fromItem.transform = CGAffineTransformMakeScale((1 - progress) * KMaxTextScale + 1, (1 - progress) * KMaxTextScale + 1);
    toItem.transform = CGAffineTransformMakeScale(progress * KMaxTextScale + 1, progress * KMaxTextScale + 1);
}

#pragma mark - item文字渐变
- (void)itemTitleColorGradientWithProgress:(CGFloat)progress fromItem:(WTPageControlItem *)fromItem toItem:(WTPageControlItem *)toItem{
    
    CGFloat fromProgress = progress;
    CGFloat toProgress = 1.0 - progress;
    
    CGFloat r = self.endR - self.beginR;
    CGFloat g = self.endG - self.beginG;
    CGFloat b = self.endB - self.beginB;
    
    UIColor * fromColor = [UIColor colorWithRed:self.beginR + r * fromProgress green:self.beginG + g * fromProgress blue:self.beginB + b * fromProgress alpha:1.0];
    UIColor * toColor  = [UIColor colorWithRed:self.beginR + r * toProgress green:self.beginG + g * toProgress blue:self.beginB + b * toProgress alpha:1.0];
    
    [fromItem setTitleColor:fromColor forState:UIControlStateNormal];
    [toItem setTitleColor:toColor forState:UIControlStateNormal];
    
}

#pragma mark - beginColor
- (void)setBeginColor:(UIColor *)color{
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.beginR = components[0];
    self.beginG = components[1];
    self.beginB = components[2];
}
#pragma mark - endColor
- (void)setEndColor:(UIColor *)color{
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.endR = components[0];
    self.endG = components[1];
    self.endB = components[2];
}

#pragma mark - 代理方法
- (void)performDelegateMethodFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageControl:selectexItemFromIndex:toIndex:)]) {
        [self.delegate pageControl:self selectexItemFromIndex:fromIndex toIndex:toIndex];
    }
    else if (self.delegate && [self.delegate respondsToSelector:@selector(pageControl:selectexItemIndex:)]){
        [self.delegate pageControl:self selectexItemIndex:toIndex];
    }
}

// 获取颜色的RGB值
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

- (void)dealloc{
    
    [self.scrollView removeObserver:self forKeyPath:KPageControlContentOffset];
}

@end
