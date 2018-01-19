//
//  WTDisplayView.m
//  WTSummary
//
//  Created by piyingke on 2018/1/8.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTDisplayView.h"
#import "UIImageView+WebCache.h"
@interface WTDisplayView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic ,strong) UICollectionView * collectionView;
@property (nonatomic ,strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic ,strong) UIImage * placeholderImage;
/** 图片的地址 */
@property (nonatomic ,strong) NSArray * imagePath;
/** 图片的总数 */
@property (nonatomic ,assign) NSInteger totalImageCount;
@property (nonatomic ,weak)   NSTimer * timer;
@property (nonatomic ,strong) UIPageControl * pageControl;
@end

static NSString * const identifier = @"displayCell";
@implementation WTDisplayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;
        [self initial];
        [self addCollectionView];
    }
    return self;
}

- (void)initial{
    
    self.isRepeat = YES;
    self.timeInterval = 3.0;
    self.autoDisplay = YES;
}

- (void)addCollectionView{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.itemSize = self.frame.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[WTDisplayCell class] forCellWithReuseIdentifier:identifier];
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    self.flowLayout = flowLayout;
}

+ (instancetype)displayViewWithFrame:(CGRect)frame delegate:(id<WTDisplayViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage{
    WTDisplayView * displayView = [[self alloc] initWithFrame:frame];
    displayView.delegate = delegate;
    displayView.placeholderImage = placeholderImage;
    return displayView;
}

+ (instancetype)displayViewWithFrame:(CGRect)frame imageStringArray:(NSArray *)imageString{
    WTDisplayView * displayView = [[self alloc] initWithFrame:frame];
    displayView.images = imageString;
    return displayView;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.totalImageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WTDisplayCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSInteger itemIndex = [self itemIndexWithCellIndex:indexPath.item];
    // 判断cell的类型
    NSString * imagePath = @"";
    NSString * title = @"";
    if (self.imagePath.count) {
        imagePath = self.imagePath[itemIndex];
    }
    if (self.titles.count) {
        title = self.titles[itemIndex];
    }

    cell.displayText = NO;
    // 设置图片
    void (^setCellImageBlock)() = ^(){
        if ([imagePath isKindOfClass:[NSString class]]) {
            if ([imagePath hasPrefix:@"http"]) {
                [cell.imageView sd_setImageWithURL:self.imagePath[itemIndex] placeholderImage:self.placeholderImage];
            }
            else{
                UIImage * image = [UIImage imageNamed:imagePath];
                if (!image) {
                    image = [UIImage imageWithContentsOfFile:imagePath];
                }
                cell.imageView.image = image;
            }
        }
    };
    
    if (imagePath.length && !title.length) {
        cell.imageView.hidden = NO;
        cell.titleLabel.hidden = YES;
        setCellImageBlock();
       
//        NSLog(@"1");
    }
    else if (imagePath.length && title.length){
        cell.imageView.hidden = cell.titleLabel.hidden = NO;
        cell.title = title;
        setCellImageBlock();
//        NSLog(@"2");
    }
    else if (!imagePath.length && title.length){
        cell.imageView.hidden = YES;
        cell.titleLabel.hidden = NO;
        cell.title = title;
        cell.displayText = YES;
//        NSLog(@"3");
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger selectIndex = [self itemIndexWithCellIndex:indexPath.item];
    if ([self.delegate respondsToSelector:@selector(displayView:didSelectItemAtIndex:)]) {
        [self.delegate displayView:self didSelectItemAtIndex:selectIndex];
    }
    
    if (self.clickItemAtIndexBlock) {
        self.clickItemAtIndexBlock(selectIndex);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.imagePath.count) return;
    NSInteger index = [self itemIndexWithCellIndex:[self currentIndex]];
    _pageControl.currentPage = index;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.autoDisplay) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.autoDisplay) {
        [self setupTitmer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}

#pragma mark - setter
- (void)setImages:(NSArray *)images{
    _images = images;
    
   NSMutableArray * temp = [NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * urlString = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        }
        else if ([obj isKindOfClass:[NSURL class]]){
            NSURL * url = (NSURL *)obj;
            urlString = url.absoluteString;
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    
    self.imagePath = temp;
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    NSMutableArray * temp = [NSMutableArray array];
    if (self.displayText) {
        for (int i = 0; i < titles.count; i ++) {
            [temp addObject:@""];
        }
        self.imagePath = temp;
    }
}

- (void)setImagePath:(NSArray *)imagePath{
    _imagePath = imagePath;
    [self invalidateTimer];
    
    self.totalImageCount = imagePath.count * 100;
    if (imagePath.count > 1) {
        self.collectionView.scrollEnabled = YES;
        [self setAutoDisplay:self.autoDisplay];
    }
    else{
        self.collectionView.scrollEnabled = NO;
        [self invalidateTimer];
    }
    
    // 添加pageControl
    [self setupPageControl];
    [self.collectionView reloadData];
}

- (void)setAutoDisplay:(BOOL)autoDisplay{
    _autoDisplay = autoDisplay;
    [self invalidateTimer];
    if (autoDisplay) {
        [self setupTitmer];
    }
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval{
    _timeInterval = timeInterval;
    [self setAutoDisplay:self.autoDisplay];
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection{
    _scrollDirection = scrollDirection;
    self.flowLayout.scrollDirection = scrollDirection;
    
}

- (void)setDisplayText:(BOOL)displayText{
    _displayText = displayText;
    [self setTitles:self.titles];
}

- (void)setPageAligment:(WTDisplayViewPageControlAligment)pageAligment{
    _pageAligment = pageAligment;
    [self setupPageControl];
}

- (void)setPageTintColor:(UIColor *)pageTintColor{
    _pageTintColor = pageTintColor;
    self.pageControl.pageIndicatorTintColor = pageTintColor;
}

- (void)setCurrentPageTintColor:(UIColor *)currentPageTintColor{
    _currentPageTintColor = currentPageTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageTintColor;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.collectionView.contentOffset.x == 0 && self.totalImageCount) {
        NSInteger index = self.isRepeat ? self.totalImageCount * 0.5 : 0;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGFloat pageWidth = 15*self.imagePath.count;
    CGFloat pageHeight = 20;
    CGFloat pageX = 0;
    CGFloat pageY = self.frame.size.height - pageHeight - 5;
    if (self.pageAligment == WTDisplayViewPageControlAligmentCenter) {
        pageX = (self.frame.size.width - pageWidth)*0.5;
    }
    else if (self.pageAligment == WTDisplayViewPageControlAligmentRight){
        pageX = self.frame.size.width - pageWidth - 10;
    }
    self.pageControl.frame = CGRectMake(pageX, pageY, pageWidth, pageHeight);
}

- (NSInteger)itemIndexWithCellIndex:(NSInteger)index{
    return index % self.imagePath.count;
}

- (void)setupTitmer{
    [self invalidateTimer];
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer{
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)autoScroll{
    
    if (!self.totalImageCount) return;
    NSInteger currentIndex = [self currentIndex];
    NSInteger nextIndex = currentIndex + 1;
    [self scrollToIndex:nextIndex];
}

- (NSInteger)currentIndex{
    
    if (!self.collectionView.frame.size.width || !self.collectionView.frame.size.height) {
        return 0;
    }
    NSInteger index = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.collectionView.contentOffset.x + self.flowLayout.itemSize.width * 0.5) / self.flowLayout.itemSize.width;
    }
    else{
        index = (self.collectionView.contentOffset.y + self.flowLayout.itemSize.height * 0.5) / self.flowLayout.itemSize.height;
    }
    return MAX(0, index);
}

- (void)scrollToIndex:(NSInteger)nextIndex{
    if (nextIndex >= self.totalImageCount) {
        if (self.isRepeat) {
            nextIndex = self.totalImageCount * 0.5;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - 不响应滚动的手势
- (void)disableScroll{
    self.collectionView.canCancelContentTouches = NO;
    for (UIGestureRecognizer * gesture in self.collectionView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self.collectionView removeGestureRecognizer:gesture];
        }
    }
}

- (void)adjustWhenViewControllerWillAppear{
    NSInteger index = [self currentIndex];
    if (index < self.totalImageCount) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - pageControl
- (void)setupPageControl{

    if (self.pageControl) [self.pageControl removeFromSuperview];
    if (self.imagePath.count == 0 || self.imagePath.count == 1 || self.displayText) return;
    NSInteger index = [self itemIndexWithCellIndex:[self currentIndex]];
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.imagePath.count;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPage = index;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)dealloc{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.timer = nil;
}
@end


@implementation WTDisplayCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
        
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        
        self.textHeight = 30;
        self.textBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.textColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:15];
    }
    return self;
}

#pragma mark - cell setter
- (void)setTitle:(NSString *)title{
    // 创建一个字符集对象, 包含所有的空格和换行字符
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    // 从字符串中过滤掉首尾的空格和换行, 得到一个新的字符串
    title = [title stringByTrimmingCharactersInSet:set];
    _title = title;
    _titleLabel.text = [NSString stringWithFormat:@"    %@",title];
}

- (void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    _titleLabel.font = textFont;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _titleLabel.textColor = textColor;
    
}

- (void)setTextHeight:(CGFloat)textHeight{
    _textHeight = textHeight;
}

- (void)setTextBackgroundColor:(UIColor *)textBackgroundColor{
    _textBackgroundColor = textBackgroundColor;
    _titleLabel.backgroundColor = textBackgroundColor;
    
}
- (void)setDisplayText:(BOOL)displayText{
    _displayText = displayText;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.displayText) {
        _titleLabel.frame = self.bounds;
    }
    else{
        self.imageView.frame = self.bounds;
        CGFloat titleWidth = self.frame.size.width;
        CGFloat titleHeight = self.textHeight?self.textHeight:30;
        CGFloat titleX = 0;
        CGFloat titleY = self.frame.size.height - titleHeight;
        _titleLabel.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight);
    }
    
}
@end
