//
//  WTFormBaseItem.h
//  WTSummary
//
//  Created by piyingke on 2018/1/17.
//  Copyright © 2018年 飞奔的小鲨鱼. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTFormBaseItem;

typedef enum {
    WTFormCellTypeDefault = 0, // 默认样式
    WTFormCellTypeEdit,        // 编辑样式 (修改昵称，签名等)
    WTFormCellTypeSelect,      // 选择样式 (生日，性别等)
    WTFormCellTypeTextViewEdit // textView的编辑框
}WTFormCellType;

typedef void (^didSelectItemBlock)(WTFormBaseItem * item);
@interface WTFormBaseItem : NSObject
/** cell的类型 */
@property (nonatomic ,assign) WTFormCellType formCellType;
/** image */
@property (nonatomic ,strong) UIImage * image;
/** arrowImage */
@property (nonatomic ,strong) UIImage * arrowImage;
/** title */
@property (nonatomic ,copy)   NSString * title;

@property (nonatomic ,copy) didSelectItemBlock selectBlock;

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title arrowImage:(UIImage *)arrowImage cellType:(WTFormCellType)cellType;

@end
