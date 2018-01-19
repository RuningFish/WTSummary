//
//  AppDelegate.m
//  WTSummary
//
//  Created by admin on 17/6/25.
//  Copyright © 2017年 飞奔的小鲨鱼. All rights reserved.
//

#import "AppDelegate.h"
#import "TestViewController.h"
#import "WTNavigationController.h"
#import "ViewController.h"
#import "TestTwoViewController.h"

void UncaughtExceptionHandler(NSException * exception) {

    // 获取异常相关信息
    NSArray *callStackSymbols = [exception callStackSymbols];
    NSString *callStackSymbolStr = [callStackSymbols componentsJoinedByString:@"\n"];
    NSString *reason = [exception reason];
    NSString *name   = [exception name];

    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH小时mm分ss秒"];
    NSString * dateStr = [dateFormatter stringFromDate:date];

    NSLog(@"崩溃时间：%@",dateStr);
    NSLog(@"异常名称：%@",name);
    NSLog(@"异常原因：%@",reason);
    NSLog(@"堆栈标志:\n %@",callStackSymbolStr);


//    //系统版本
//    NSString    * systemVersion    = [[UIDevice currentDevice] systemVersion];
//    //将crash日志保存到Document目录下的ExceptReport文件夹下
//    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString * exceptReport = [path stringByAppendingPathComponent:@"ExceptReport"];
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    NSString * crashString = [NSString stringWithFormat:@"奔溃时间:%@ \n 系统版本:%@  \n 异常名称:%@ \n 异常原因:%@ \n 堆栈标志:\n %@", dateStr,systemVersion,name, reason, callStackSymbolStr];
//    // 把错误日志写到文件中,如果存在路径先清理一下
//    if (![fileManager fileExistsAtPath:exceptReport]) {
//        [fileManager removeItemAtPath:exceptReport error:nil];
//        [crashString writeToFile:exceptReport atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    }
}


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    TestViewController * test = [[TestViewController alloc] init];
    ViewController * viewController = [[ViewController alloc] init];
    TestTwoViewController * testTwo = [[TestTwoViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    WTNavigationController * nav = [[WTNavigationController alloc] initWithRootViewController:viewController];
//    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
 
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 设置webview 的UserAgent
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    
    //add my info to the new agent
    NSString * newAgent = @"piyingke/iOS";//[oldAgent stringByAppendingString:@" Jiecao/2.4.7 ch_appstore"];
    NSLog(@"new agent :%@", newAgent);
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
