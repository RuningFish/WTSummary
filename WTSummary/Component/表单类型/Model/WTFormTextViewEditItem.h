//
//  WTFormTextViewEditItem.h
//  WTSummary
//
//  Created by piyingke on 2018/1/18.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import "WTFormBaseItem.h"

@interface WTFormTextViewEditItem : WTFormBaseItem
/** textViewPlaceHolder */
@property(nonatomic, copy) NSString * placeholder;
/** placeholderColor */
@property(nonatomic, strong) UIColor * placeholderColor;
@end
