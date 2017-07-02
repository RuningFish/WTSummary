//
//  WTLabel.m
//  WTLabel
//
//  Created by admin on 17/4/8.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "WTLabel.h"

@interface WTLabel ()
/** layoutManager */
@property (nonatomic, strong) NSLayoutManager * layoutManager;
/** textContainer */
@property (nonatomic, strong) NSTextContainer * textContainer;
/** textStorage */
@property (nonatomic, strong) NSTextStorage   * textStorage;

/** 存放@的数组 */
@property (nonatomic, strong) NSMutableArray * userHandleArray;
/** 存放url的数组 */
@property (nonatomic, strong) NSMutableArray * urlHandleArray;
/** 存放#的数组 */
@property (nonatomic, strong) NSMutableArray * topicHandleArray;
/** 存放自定义的数组 */
@property (nonatomic, strong) NSMutableArray * userDefineArray;

/** 记录选择的range */
@property (nonatomic, assign) NSRange selectRange;
/** 记录点击的类型 */
@property (nonatomic, assign) WTLinkType selectLinkType;

/** 高亮的属性 */
@property (nonatomic, strong) NSMutableDictionary * attributeDict;
/** 是否点击高亮属性 */
@property (nonatomic, assign,getter=isSelected) BOOL selected;
@end

/** 匹配@的正则 @[\\u4e00-\\u9fa5a-zA-Z0-9_-]* */
static NSString * const userPattern = @"(@[^\\s@]+)";
/** 匹配#的正则 */
static NSString * const topicPattern = @"#.*?#";

/** 自定义的高亮范围和属性 */
static NSString * customRange = @"customRange";
static NSString * attributed   = @"attribute";

@implementation WTLabel

- (NSMutableDictionary *)attributeDict{
    
    if (_attributeDict == nil) {
        _attributeDict = [NSMutableDictionary dictionary];
    }
    return _attributeDict;
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self install];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    
    if (self = [super initWithCoder:coder]) {
        [self install];
    }
    return self;
}

- (void)install{

    self.userInteractionEnabled = YES;
    self.autoHighlightText = YES;
     self.selectBackgroundColor = [UIColor colorWithWhite:0.7 alpha:0.2];
    
    // layoutManager
    self.layoutManager = [[NSLayoutManager alloc] init];
    self.textContainer = [[NSTextContainer alloc] init];
    self.textStorage   = [[NSTextStorage alloc] init];
    
    [self.textStorage addLayoutManager:self.layoutManager];
    [self.layoutManager addTextContainer:self.textContainer];
    
    [self makeAttributedText];
    
//    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//    [self addGestureRecognizer:tapGesture];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self makeAttributedText];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self makeAttributedText];
}

- (void)setAutoHighlightText:(BOOL)autoHighlightText{
    _autoHighlightText = autoHighlightText;
    [self makeAttributedText];
}

#pragma mark - 匹配高亮的文字
- (void)makeAttributedText{

    NSAttributedString * attbuteStr = nil;
    
    // 文字的段落属性
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距
    paragraphStyle.lineSpacing = self.lineSpacing;
    // 对齐方式
    paragraphStyle.alignment = self.textAlignment;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.font,
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:self.textColor
                                 };
    
    if (self.attributedText != nil) {
        attbuteStr = self.attributedText;
    }else if (self.text != nil){
        attbuteStr = [[NSAttributedString alloc] initWithString:self.text];
    }else{
        attbuteStr = [[NSAttributedString alloc] initWithString:@""];
    }
    
    if (attbuteStr.length == 0)  return;
    NSMutableAttributedString * attrStringM = [[NSMutableAttributedString alloc] initWithAttributedString:attbuteStr];;
    
    [attrStringM setAttributes:attributes range:NSMakeRange(0, attrStringM.length)];
    [self.textStorage setAttributedString:attrStringM];
    
    if (!self.isAutoHighlightText) return;
    // 匹配@
    NSMutableArray * ranges = [self regularExpressionWithPattern:userPattern];
    
    self.userHandleArray = ranges;
    for (NSValue *value in ranges) {
        NSRange range;
        [value getValue:&range];
        
        NSDictionary * att = self.attributeDict[@(WTLinkTypeUserHandle)];
        if (att) {
            [self.textStorage addAttributes:att range:range];
        }
        
    }
    
    // 匹配url
    NSArray * range2 =  [self regularExpressionUrl];
    self.urlHandleArray = [NSMutableArray arrayWithArray:range2];
    for (NSValue *value in range2) {
        NSRange range;
        [value getValue:&range];
        NSDictionary * att = self.attributeDict[@(WTLinkTypeUrl)];
        if (att) {
            [self.textStorage addAttributes:att range:range];
        }
    }
    
    // 匹配#
    NSMutableArray * range3 = [self regularExpressionWithPattern:topicPattern];
    self.topicHandleArray = range3;
    for (NSValue *value in range3) {
        NSRange range;
        [value getValue:&range];
        NSDictionary * att = self.attributeDict[@(WTLinkTypeTopic)];
        if (att) {
            [self.textStorage addAttributes:att range:range];
        }
    }
    
    // 自定义高亮的文字
    NSArray * range4 = [self getCustomRange];
    self.userDefineArray = [NSMutableArray arrayWithArray:range4];
    for (NSDictionary * dict in range4) {
        NSValue * value = dict[customRange];
        NSDictionary * attributes = dict[attributed];
        if (value && attributes) {
            [self.textStorage addAttributes:attributes range:[value rangeValue]];
        }
    }
    
    // 重新绘制
    [self setNeedsDisplay];
}

#pragma mark - 匹配@ 、#
- (NSMutableArray <NSTextCheckingResult *> *)regularExpressionWithPattern:(NSString *)pattern{
    
    NSRegularExpression * expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray<NSTextCheckingResult *> * results = [expression matchesInString:[self.textStorage string] options:0 range:NSMakeRange(0, self.textStorage.length)];
    NSMutableArray * array = [NSMutableArray array];
    for (NSTextCheckingResult * result in results) {
        // 将结构体保存到数组
        NSRange range = result.range;
        
        NSString * rangeString = [self.textStorage.string substringWithRange:range];
        // 过滤忽略的高亮字符
        BOOL igore = [self.igoreKeywords containsObject:rangeString];
        if (!igore) {
            NSValue * value = [NSValue valueWithRange:range];
            [array addObject:value];
        }else if (igore && [self.userHandleArray containsObject:rangeString]){
            [self.userHandleArray removeObject:rangeString];
        }else if (igore && [self.topicHandleArray containsObject:rangeString]){
            [self.topicHandleArray removeObject:rangeString];
        }else if (igore && [self.urlHandleArray containsObject:rangeString]){
            [self.urlHandleArray removeObject:rangeString];
        }
    }
    return array;
}

#pragma mark - 匹配url
- (NSArray <NSTextCheckingResult *> *)regularExpressionUrl{
    
    NSDataDetector * urlPattern = [NSDataDetector  dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    
    NSArray<NSTextCheckingResult *> * results = [urlPattern matchesInString:[self.textStorage string] options:0 range:NSMakeRange(0, self.textStorage.length)];
    
    NSMutableArray * array = [NSMutableArray array];
    for (NSTextCheckingResult *result in results) {
        // 将结构体保存到数组
        NSRange range = result.range;
        NSString * rangeString = [self.textStorage.string substringWithRange:range];
        // 过滤忽略的高亮字符
        if (![self.igoreKeywords containsObject:rangeString]) {
            NSValue * value = [NSValue valueWithRange:range];
            [array addObject:value];
        }
       
    }
    
    return array;
}

#pragma amrk - 获取自定义的范围数组
- (NSArray <NSDictionary *>*)getCustomRange{
    
    NSString * text = self.textStorage.string;
    // 高亮文字
    NSString * key1 = @"text";
    // 高亮属性
    NSString * key2 = @"attribute";
    NSString * string;
    NSDictionary * attribute;
    NSValue * value;
    NSMutableArray * array = [NSMutableArray array];
    
    for (NSDictionary * dic in self.customArray) {
        if ([[dic allKeys] containsObject:key1]) {
            string = dic[key1];
            NSRange range = [text rangeOfString:string];
            if (range.length == 0) continue;
            value = [NSValue valueWithRange:range];
        }
        
        if ([[dic allKeys] containsObject:key2]) {
            NSDictionary * c = dic[key2];
            if (c) {
                attribute = c;
            }else{
                NSLog(@"自定义的高亮属性不是NSDictionary类型！");
                continue;
            }
        }
        
        NSMutableDictionary * att = [NSMutableDictionary dictionary];
        att[customRange] = value;
        att[attributed] = attribute;
        [array addObject:att];
    }
    
    return array;
}

#pragma mark - 处理点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //NSLog(@"touchesBegan");
    CGPoint point = [[touches anyObject] locationInView:self];
    
    // 获取点击的range
    self.selectRange = [self getSelectRange:point];
    self.selected = YES;
    if (self.selectRange.length == 0) {
        [super touchesBegan:touches withEvent:event];
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.selectRange.length == 0) {
        // 点击结束的时候响应非高亮击
        if (self.noLinkHandle) {
            self.noLinkHandle(self);
        }
        return;
    }
    
    _selected = NO;
    [self setNeedsDisplay];
    
    // 点击结束的时候响应高亮击
    NSString * selString = [self.textStorage.string substringWithRange:self.selectRange];

    if (self.selectLinkType == WTLinkTypeUserHandle) {
        if (self.userHandle) {
            self.userHandle(self,selString,self.selectRange);
        }
    }else if (self.selectLinkType == WTLinkTypeUrl){
        if (self.urlHandle) {
            self.urlHandle(self,selString,self.selectRange);
        }
    }else if (self.selectLinkType == WTLinkTypeTopic){
        if (self.topicHandle) {
            self.topicHandle(self,selString,self.selectRange);
        }
    }else if (self.selectLinkType == WTLinkTypeCustom){
        if (self.customHandle) {
            self.customHandle(self,selString,self.selectRange);
        }
    }
    
    // delegate
    if ([self.delegate respondsToSelector:@selector(label:didSelsectedWithType:string:range:)]) {
        [self.delegate label:self didSelsectedWithType:self.selectLinkType string:selString range:self.selectRange];
    }
}

- (void)drawRect:(CGRect)rect{
    
    // 绘制高亮背景
    if (self.selectRange.length != 0 ) {

        UIColor *selectedColor = self.selected ?self.selectBackgroundColor:[UIColor clearColor];
        [self.textStorage addAttribute:NSBackgroundColorAttributeName value:selectedColor range:self.selectRange];
        [self.layoutManager drawBackgroundForGlyphRange:self.selectRange atPoint:CGPointMake(0, 0)];
    }
  
    // 绘制文字
    NSRange range = NSMakeRange(0, self.textStorage.length);
    [self.layoutManager drawGlyphsForGlyphRange:range atPoint:CGPointZero];
}

#pragma mark - 通过点击获取高亮的范围ie
- (NSRange)getSelectRange:(CGPoint)point{
    
    NSInteger index = [self.layoutManager glyphIndexForPoint:point inTextContainer:self.textContainer];

    // @
    for (NSValue * value in self.userHandleArray) {
        NSRange selectRange;
        [value getValue:&selectRange];
        if (index > selectRange.location && index < selectRange.location + selectRange.length) {
            [self setNeedsDisplay];
            self.selectLinkType = WTLinkTypeUserHandle;
            return selectRange;
        }
    }
    
    // url
    for (NSValue * value in self.urlHandleArray) {
        NSRange selectRange;
        [value getValue:&selectRange];
        if (index > selectRange.location && index < selectRange.location + selectRange.length) {
            [self setNeedsDisplay];
            self.selectLinkType = WTLinkTypeUrl;
            return selectRange;
        }
    }
    
    // #
    for (NSValue * value in self.topicHandleArray) {
        NSRange selectRange;
        [value getValue:&selectRange];
        if (index > selectRange.location && index < selectRange.location + selectRange.length) {
            [self setNeedsDisplay];
            self.selectLinkType = WTLinkTypeTopic;
            return selectRange;
        }
    }

    // custom
    for (NSDictionary * dic in self.userDefineArray) {
        NSRange selectRange;
        NSValue * value = dic[customRange];
        [value getValue:&selectRange];
        if (index > selectRange.location && index < selectRange.location + selectRange.length) {
            [self setNeedsDisplay];
            self.selectLinkType = WTLinkTypeCustom;
            return selectRange;
        }
    }
    // 如果@ 、url 、# 、自定义中都没有找到 则返回(0,0)
    return NSMakeRange(0, 0);
}

#pragma mark -忽略的关键字
-(void)setIgoreKeywords:(NSArray *)igoreKeywords{
    
    _igoreKeywords = igoreKeywords;
    
    //NSLog(@"忽略的高亮字符 --- %@",_igoreKeywords);
    [self makeAttributedText];
}

#pragma mark - 设置高亮字体属性
- (void)setAttributes:(NSDictionary *)attributes forLinkType:(WTLinkType)linkType{
    
    if (attributes) {
        [self.attributeDict setObject:attributes forKey:@(linkType)];
    }else{
        [self.attributeDict removeObjectForKey:@(linkType)];
    }
    
    [self makeAttributedText];
}

- (void)setCustomArray:(NSArray<NSDictionary *> *)customArray{
    
    if (customArray.count > 0) {
        _customArray = customArray;
        [self makeAttributedText];
    }
    
    
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.textContainer.size = self.frame.size;
}
@end
