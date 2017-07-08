//
//  WTImageTextViewController.m
//  WTSummary
//
//  Created by piyingke on 17/7/6.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#define IMAGE_WIDTH ([UIScreen mainScreen].bounds.size.width - 10.0)

#import "WTImageTextViewController.h"
#import "WTToolbar.h"
#import "WTEditImageView.h"

@interface WTImageTextViewController ()<YYTextViewDelegate,WTToolbarDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WTEditImageViewDataSource>
@property (nonatomic, strong) YYTextView * textView;

@property (nonatomic, strong) WTToolbar * toolBar;

@property (nonatomic, assign) NSRange selectRange;
@end

@implementation WTImageTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布图文帖";
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.toolBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti{
    
    NSDictionary* userInfo = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    [UIView animateWithDuration:animationDuration animations:^{
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, -keyboardFrame.size.height);
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)noti{
    [UIView animateWithDuration:0.25 animations:^{
        self.toolBar.transform = CGAffineTransformIdentity;
    }];
}

- (void)textViewDidChange:(YYTextView *)textView{
    
  
}

- (YYTextView *)textView{
    if (!_textView) {
        _textView = [[YYTextView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        _textView.placeholderText = @"请输入内容";
        _textView.placeholderFont = [UIFont systemFontOfSize:15];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.tintColor = [UIColor lightGrayColor];
        _textView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
        _textView.delegate = self;
        NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 10;
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:_textView.text];
        [att addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, _textView.text.length)];
        
    }
    return _textView;
}

- (WTToolbar *)toolBar{
    if (!_toolBar) {
        CGFloat toolbarH = 50;
        _toolBar = [[WTToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - toolbarH, self.view.frame.size.width, toolbarH)];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

#pragma mark - ToolBarDelegate
- (void)toolbar:(WTToolbar *)discussToolbar didClickWithType:(WTToolbarButtonType)type{
    if (type == WTToolbarButtonTypeImage) {

    _selectRange = _textView.selectedRange;
    TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:self];
    [self presentViewController:controller animated:YES completion:nil];
        
    }else if (type == WTToolbarButtonTypeAt){
        // @好友
        NSLog(@"@好友");
    }
}


#pragma mark - TZImage Picker Controller Delegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    NSMutableAttributedString *contentText = [_textView.attributedText mutableCopy];
    for (NSInteger i = photos.count - 1; i >= 0; i--) {
        WTEditImageView *imageView = [[WTEditImageView alloc] initWithDataSourece:self];
        imageView.image = photos[i];
        imageView.location = _selectRange.location + i * 2 + 1;
        contentText = [[self p_textViewAttributedText:imageView contentText:contentText index:_selectRange.location originPoint:[_textView caretRectForPosition:_textView.selectedTextRange.start].origin isData:NO] mutableCopy];
    }
    [contentText insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:_selectRange.location + photos.count * 2];
    _textView.attributedText = contentText;
 
}

#pragma mark - YYTextView Get Attributed String
- (NSAttributedString *)p_textViewAttributedText:(id)attribute contentText:(NSAttributedString *)attributeString index:(NSInteger)index originPoint:(CGPoint)originPoint isData:(BOOL)isData {
    NSMutableAttributedString *contentText = [attributeString mutableCopy];
    NSAttributedString *textAttachmentString = [[NSAttributedString alloc] initWithString:@"\n"];
    if ([attribute isKindOfClass:[WTEditImageView class]]) {
        WTEditImageView *imageView = (WTEditImageView *)attribute;
        CGFloat imageViewHeight = ![imageView.title isEqualToString:@""] ? IMAGE_WIDTH + 30.0 : IMAGE_WIDTH;
        imageView.frame = CGRectMake(originPoint.x, originPoint.y, IMAGE_WIDTH, imageViewHeight);
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:_textView.font alignment:YYTextVerticalAlignmentCenter];
        if (!isData) [contentText insertAttributedString:textAttachmentString atIndex:index++];
        [contentText insertAttributedString:attachText atIndex:index++];
//
//        imageView.editBlock = ^(WTEditImageView *imageView) {
//            [self p_editImageViewTitle:imageView point:imageView.frame.origin];
//        };
//        imageView.moveBlock = ^(WTEditImageView *imageView, UILongPressGestureRecognizer *longPress) {
//            [self p_move:imageView longPress:longPress];
//        };
//        imageView.deleteBlock = ^(WTEditImageView *imageView) {
//            [self p_deleteImageView:imageView];
//        };
    }
    return contentText;
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
