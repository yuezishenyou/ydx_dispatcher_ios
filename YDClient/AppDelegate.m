//
//  AppDelegate.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/16.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "AppDelegate.h"
#import "YDLoginController.h"
#import "YDIndexController.h"
#import "IQKeyboardManager.h"
#import "Global.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self setMapView];
    [self setRootViewController];
    return YES;
}

/** 设置地图并开启位置服务 */
- (void)setMapView
{
    [AMapServices sharedServices].apiKey = MAP_APIKEY;
    [GLOABL configLocationManager];
}


/** 设置根试图 */
- (void)setRootViewController
{
    
    UIViewController *vc;
    
    vc = [[YDIndexController alloc] init];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:@"isLogin"];
    [ud synchronize];
    
//    if ([self checkLogin])
//    {
//        vc = [[YDIndexController alloc] init];
//
//    }else {
//        YDLoginController *login = [[YDLoginController alloc] init];
//        login.isLogin = YES;
//        vc = login;
//    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    [self setKeyBoard];
}

/**
 * 检测是否登录
 * YES 为已登录
 * NO 为未登录
 */
- (BOOL)checkLogin {
//#warning 暂时第一次加载App时为未登录, 加载之后为已登录
    NSString *firstLanch = kYD_USERDEFAULTS_READ_OBJ(@"firstLaunch");
    kYD_USERDEFAULTS_SET_OBJ(@"firstLaunch", @"firstLaunch");
    kYD_USERDEFAULTS_SYN;
    DLog(@"=========%@", firstLanch);
    if (firstLanch == nil)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

/** 设置键盘 */
- (void)setKeyBoard
{
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = YES;
    manager.toolbarDoneBarButtonItemText = @"完成";
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
