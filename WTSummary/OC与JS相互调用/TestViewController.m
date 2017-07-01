//
//  TestViewController.m
//  WTSummary
//
//  Created by admin on 17/6/28.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()<UIWebViewDelegate>
@property (nonatomic ,weak) UIWebView * webview;
/** <#desc#>*/
@property (nonatomic, weak) UIButton * button1;
/** <#desc#>*/
@property (nonatomic, weak) UIButton * button2;
/** <#desc#>*/
@property (nonatomic, weak) UIButton * button3;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIWebView * webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, size.width, 300)];
    [self.view addSubview:webview];
    self.webview = webview;
    webview.backgroundColor = [UIColor greenColor];
    webview.delegate = self;
    
    NSString * htmlString = @"<html>\
    <head>\
    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /> \
    <title>TestHtml</title> <style>.btn{height:50px; width:60%; padding: 0px 30px; background-color: #0071E7; border: solid 1px #0071E7; border-radius:5px; font-size: 1.0em; color: white} </style> \
    <script> \
    function alertMobile() { alert('OC调用JS 无参') } \
    function alertName(msg) { alert('OC调用JS 一个参数 ' + msg )} \
    function alertSendMsg(num,msg) { alert('OC调用JS 两个参数:' + num + ',' + msg) } \
    \
    function btnClick1() { location.href = \"testhtml://method1\"} \
    function btnClick2() { location.href = \"testhtml://method2?iPhone7Plus\"} \
    function btnClick3() { location.href = \"testhtml://method3?QQ&weChat\"}\
    </script>\
    </head>\
    <body>\
    <br/>\
    <br/>\
    <div><label>JS 调用OC的方法</label></div>\
    <br/>\
    <br/>\
    <div id=\"div1\"><button class=\"btn\" type=\"button\" onclick=\"btnClick1()\">JS调用OC方法 无参</button></div><br/>\
    <div><button class=\"btn\" type=\"button\" onclick=\"btnClick2()\">JS调用OC方法 一个参数</button></div><br/>\
    <div><button class=\"btn\" type=\"button\" onclick=\"btnClick3()\">JS调用OC方法 两个参数</button></div></body>\
    </html>";
    
    [webview loadHTMLString:htmlString baseURL:nil];
    
    
    CGFloat width = 260;
    CGFloat y = CGRectGetMaxY(webview.frame) + 30;
    CGFloat x = (size.width - width) / 2;
    CGFloat height = 35;
    for (int i = 0; i < 3; i ++) {
        
        UIButton * button = [[UIButton alloc] init];
        button.frame = CGRectMake(x, y, width, height);
        [self.view addSubview:button];
        button.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
        y += (height * 2);
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            [button setTitle:@"OC调用JS 无参" forState:UIControlStateNormal];
        }else if (i == 1){
            [button setTitle:@"OC调用JS 一个参数" forState:UIControlStateNormal];
        }else if (i == 2){
            [button setTitle:@"OC调用JS 两个参数" forState:UIControlStateNormal];
        }
        
    }
    
    
//    UIBarButtonItem * backItem = [UIBarButtonItem itemWithTitle:@"< 返回" highTitle:nil Image:nil highImage:nil target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)buttonClick:(UIButton *)button{
    
    switch (button.tag) {
        case 0:
        {
            NSLog(@"OC调用JS 无参");
            [self.webview stringByEvaluatingJavaScriptFromString:@"alertMobile()"];
        }
            break;
        case 1:
        {
            NSLog(@"OC调用JS 一个参数");
            NSString * testJS = [NSString stringWithFormat:@"alertName('%d')",arc4random_uniform(100)];
            [self.webview stringByEvaluatingJavaScriptFromString:testJS];
        }
            break;
        case 2:
        {
            NSLog(@"OC调用JS 两个参数");
            //NSArray * temp = @[@"123"];
            NSString * testJS = [NSString stringWithFormat:@"alertSendMsg('%@','456')",@123];
            // 注意 在 OC调用JS geiJS传参的时候 不能拼接数组或者字典类型到字符串中  @"alertSendMsg('param','456')"
            [self.webview stringByEvaluatingJavaScriptFromString:testJS];
        }
            break;
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    // TestHtml://showSendNumber_msg_?13300001111&go climbing this weekend
    
    void (^AlertViewBlock)(NSString * title,NSString * message,NSString * cancel) = ^(NSString * title,NSString * message,NSString * cancel){
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:nil];
        
        [alertView show];
    };
    
    NSString * urlString = request.URL.absoluteString;
    NSString * scheme = @"testhtml://";
    if ([urlString hasPrefix:scheme]) {
        //
        NSString * subString = [urlString substringFromIndex:scheme.length];
        NSArray * temp = [subString componentsSeparatedByString:@"?"];
        NSString * method = [temp firstObject];
        
        if ([method isEqualToString:@"method1"]) {
            AlertViewBlock(@"JS调用OC方法",@"无参",@"取消");
        }else if ([method isEqualToString:@"method2"]) {
            NSString * param = [temp lastObject];
            AlertViewBlock(@"JS调用OC方法",[NSString stringWithFormat:@"一个参数\n参数为:%@",param],@"取消");
        }else if ([method isEqualToString:@"method3"]) {
            NSString * string = [temp lastObject];
            NSRange range = [string rangeOfString:@"&"];
            NSString * param1 = [string substringToIndex:range.location];
            NSString * param2 = [string substringFromIndex:range.location + 1];
            AlertViewBlock(@"JS调用OC方法",[NSString stringWithFormat:@"两个参数\n参数为:%@,%@",param1,param2],@"取消");
        }
    }
    
    
    return YES;
}

@end
