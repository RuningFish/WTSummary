//
//  WTCustomTextStorage.m
//  HighlightTextView
//
//  Created by admin on 17/3/23.
//  Copyright © 2017年 piyingke. All rights reserved.
//

#import "WTCustomTextStorage.h"

@implementation WTCustomTextStorage
{
    NSMutableAttributedString *_imp;
}

- (instancetype)init{
    
    if (self = [super init]) {
        _imp = [[NSMutableAttributedString alloc] init];
    }
    
    return self;
}

- (NSString *)string{
    
    return _imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_imp attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str{
    
    [_imp replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [_imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

- (void)processEditing{
    
    [super processEditing];
    static NSRegularExpression *iExpression;
    // @"(@[^\\s@]+)"
    NSString *pattern = @"(@[^\\s@]+)";
    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:NULL];
    
    NSRange paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
    
    [self removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
    [iExpression enumerateMatchesInString:self.string
                                  options:0 range:paragaphRange
                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
     {
         [self addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4990E2"] range:result.range];
     }];
}
@end
