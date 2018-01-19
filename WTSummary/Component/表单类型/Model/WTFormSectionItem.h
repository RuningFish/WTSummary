//
//  WTFormSectionItem.h
//  WTSummary
//
//  Created by piyingke on 2018/1/19.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WTFormSectionItem : NSObject
/** headerTitle */
@property (nonatomic, copy) NSString * headerTitle;
/** footerTitle */
@property (nonatomic, copy) NSString * footerTitle;
/** headerHeight */
@property (nonatomic, assign) CGFloat headerHeight;
/** footerHeight */
@property (nonatomic, assign) CGFloat footerHeight;
/** headerTitleColor */
@property (nonatomic, strong) UIColor * headerTitleColor;
/** footerTitleColor */
@property (nonatomic, strong) UIColor * footerTitleColor;
/** headerColor */
@property (nonatomic, strong) UIColor * headerColor;
/** footerColor */
@property (nonatomic, strong) UIColor * footerColor;
/** sectionCells */
@property (nonatomic, strong) NSArray * cellItems;
@end
