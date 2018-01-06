//
//  WTCardView.m
//  WTSummary
//
//  Created by piyingke on 2017/11/28.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTCardView.h"
#import "WTCardViewCell.h"

@interface WTCardView ()<WTCardViewCellDelegate>
@property (nonatomic, assign) WTCardViewStyle style;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) NSMutableSet * reusableCells;
@property (nonatomic, copy)   NSString * identifier;
@property (nonatomic, strong) NSMutableArray * cardCells;
/** 当前的index */
@property (nonatomic, assign) NSInteger currentIndex;
@end

static CGFloat loadCount = 2;

@implementation WTCardView

- (NSMutableSet *)reusableCells{
    if (!_reusableCells) {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}

- (NSMutableArray *)cardCells{
    if (!_cardCells) {
        _cardCells = [NSMutableArray array];
    }
    return _cardCells;
}
- (instancetype)initWithFrame:(CGRect)frame andStyle:(WTCardViewStyle)style{
    
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.style = style;
    }
    return self;
}

- (void)reloadData{
    
    if (!self.dataSource) return;
    
    _itemCount = [self.dataSource numberOfItemsInCardView:self];
    for (NSInteger index = self.reusableCells.count; index < loadCount; index ++) {
        
        CGSize cellSize = [self cellSizeAtIndex:index];
        WTCardViewCell * cardViewCell = [self cardViewCellAtIndex:self.currentIndex];
        [self addSubview:cardViewCell];
        [self sendSubviewToBack:cardViewCell];
        [self.cardCells addObject:cardViewCell];
        
        cardViewCell.transform = CGAffineTransformIdentity;
        CGFloat cellX = (self.frame.size.width - cellSize.width)*0.5;
        CGFloat cellY = (self.frame.size.height - cellSize.height)*0.5;
        cardViewCell.frame = CGRectMake(cellX, cellY, cellSize.width, cellSize.height);
        cardViewCell.delegate = self;
        
        if (index == 0) {
            cardViewCell.userInteractionEnabled = YES;
        }
    }
}

- (CGSize)cellSizeAtIndex:(NSInteger)index{
    if ([self.dataSource respondsToSelector:@selector(cardView:sizeForCellAtIndex:)]) {
        CGSize cellSize = [self.dataSource cardView:self sizeForCellAtIndex:index];
        if (cellSize.width > self.frame.size.width || cellSize.width == 0) {
            cellSize.width = self.frame.size.width;
        }
        else if (cellSize.height > self.frame.size.height || cellSize.height == 0){
            cellSize.height = self.frame.size.height;
        }
        return cellSize;
    }
    return self.frame.size;
}

- (WTCardViewCell *)cardViewCellAtIndex:(NSInteger)index{
    if ([self.dataSource respondsToSelector:@selector(cardView:cellAtIndex:)]) {
        // 先从缓存池中寻找，没有的话创建
        WTCardViewCell * cardViewCell = [self.dataSource cardView:self cellAtIndex:index];
        
        ++self.currentIndex;
        if (!cardViewCell) {
            return [[WTCardViewCell alloc] initWithReuseIdentifier:self.identifier];
        }
        else{
            return cardViewCell;
        }
        
    }
    return [[WTCardViewCell alloc] initWithReuseIdentifier:self.identifier];
    
}

#pragma mark - WTCardViewCellDelegate
- (void)cellDidRemoveFromSuperView:(WTCardViewCell *)cardViewCell{
    
    //
    cardViewCell.delegate = nil;
    cardViewCell.userInteractionEnabled = NO;
    [self.reusableCells addObject:cardViewCell];
    [self.cardCells removeObject:cardViewCell];
    
    [self reloadData];
    
    WTCardViewCell * cell = [self.cardCells firstObject];
    if (cell) {
        cell.userInteractionEnabled = YES;
    }
}

- (WTCardViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    
    self.identifier = identifier;
    WTCardViewCell * cell = [self.reusableCells anyObject];
    if (cell && [cell.idientifier isEqualToString:identifier]) {
        [self.reusableCells removeObject:cell];
         NSLog(@"缓存池的 cardViewCell");
        return cell;
    }
    return nil;
}
@end
