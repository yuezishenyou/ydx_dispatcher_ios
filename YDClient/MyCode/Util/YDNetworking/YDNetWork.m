//
//  YDNetWork.m
//  YDDriver
//
//  Created by maoziyue on 17/4/12.
//  Copyright © 2017年 Shanghai Meiyue InfoTech Ltd. All rights reserved.
//

#import "YDNetWork.h"
#import "AFNetworking.h"

@interface YDNetWork ()<UIAlertViewDelegate>


@property (nonatomic,strong)AFHTTPSessionManager *sessionManager;

@end

@implementation YDNetWork

/**
 * 单例
 */
+ (instancetype)manager
{
    static YDNetWork *_netWork = nil;
    if (_netWork == nil) {
        _netWork = [[YDNetWork alloc]init];
        _netWork.sessionManager = [AFHTTPSessionManager manager];
        _netWork.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _netWork.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_netWork.sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _netWork.sessionManager.requestSerializer.timeoutInterval = 10.f;//时间15秒
        [_netWork.sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
    }
    return _netWork;
}

/**
 * GET方法
 * 实例方法请求网络
 */
- (void)GET:(NSString *)urlStr
 parameters:(NSDictionary *)paramenters
    success:(successBlock)success
    failure:(failureBlock)failure
{
    //urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self.sessionManager GET:urlStr
                  parameters:paramenters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         success(json);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure(error);
     }];
}


/**
 * GET方法
 * 类方法请求网络
 */
+ (void)GET:(NSString *)urlStr
 parameters:(NSDictionary *)parameters
    success:(successBlock)success
    failure:(failureBlock)failure
{
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    __block YDNetWork *manager = [YDNetWork manager];
    [manager.sessionManager GET:urlStr
                     parameters:parameters
                       progress:nil
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         
         success(json);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure(error);
     }];
    
    
}

/**
 * POST方法
 * 实例方法请求网络
 */
- (void)POST:(NSString *)urlStr
  parameters:(NSDictionary *)parameters
     success:(successBlock)success
     failure:(failureBlock)failure
{
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self.sessionManager POST:urlStr
                   parameters:parameters
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         
         success(json);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure(error);
     }];
    
}

/**
 * POST方法
 * 类方法请求网络
 */
+ (void)POST:(NSString *)urlStr
  parameters:(NSDictionary *)parameters
     success:(successBlock)success
     failure:(failureBlock)failure
{
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"-----urlStr:%@------",urlStr);
    
    __block YDNetWork *manager = [YDNetWork manager];
    [manager.sessionManager POST:urlStr
                      parameters:parameters
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

             success(json);

     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure(error);
     }];
    
}





//- (BOOL)loginOutUserWith:(id)jsonDic
//{
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    NSString *token = [def objectForKey:@"token"];
////    DLogInfo(@"-------------token:%@------------------",token);
//    
//    if (token.length <= 0) {
//        return NO;
//    }
//    
//    NSDictionary *dic = jsonDic[@"status"];
//    NSInteger code = [dic[@"code"] integerValue];
//
////    DLogInfo(@"-------------code:%ld------------------",(long)code);
//    
//    
//
//    //((code == 9998 || code == 9999 || code == 1001 ) && _isLoginOut == NO)
//    if ((code == 9998 || code == 9999  || code == 1001))
//    {
//        
//        // 将本地存储的token清空
//        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//        NSMutableArray *arr = [NSMutableArray arrayWithArray:[def objectForKey:@"orders"]];
//        if (arr != nil)
//        {
//            [def setObject:nil forKey:@"orders"];
//        }
//        
//        [def setObject:nil forKey:@"token"];
//        MainViewController *mainVC = [YDGlobal manager].mainVC;
//        mainVC.canReceiveNewOrder = NO;
//        [[YDGlobal manager] onCancel];
//        mainVC.orderDetailView.hidden = YES;
//        [[YDGlobal manager] closeSocket];
//        NSString *message;
//        if (dic[@"msg"] == nil)
//        {
//            message = @"您的账户已在其他设备登录！";
//        }
//        else
//        {
//            message = dic[@"msg"];
//        }
//        
//        UIAlertView *alertForInput = [[UIAlertView alloc] initWithTitle: KLocalizedString(@"Tips", nil)
//                                                                message: message
//                                                               delegate: self
//                                                      cancelButtonTitle: KLocalizedString(@"Confirm", nil)
//                                                      otherButtonTitles:  nil];
//        alertForInput.tag = 1000000;
//        [alertForInput show];
//        return YES;
//    }
//    return NO;
//}


//#pragma mark --------------alertView代理---------------
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//     //_al = nil;
//    if (alertView.tag == 1000000) {
//        
//        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//        
//        //[CACHEMANAGER cleanWithKey:USERREGISTINFO];
//        // 将本地存储的token清空
//        [def setObject:nil forKey:@"token"];
//        [def setObject:nil forKey:@"tel"];
//        //[def setObject:nil forKey:@"pass"];
//        [def setObject:nil forKey:@"name"];
//        [def setObject:nil forKey:@"photoPath"];
//        [def setObject:nil forKey:@"uid"];
//        [def setObject:nil forKey:@"imei"];
//        
//        if ([[YDGlobal manager] outOfCountry]) {
//            [[[YDGlobal manager] appleLocationManager] stopUpdatingHeading];
//            [[[YDGlobal manager] appleLocationManager] stopUpdatingLocation];
//        }else{
//            [[YDGlobal manager].locationManager stopUpdatingLocation];
//        }
//        
//        [[YDGlobal manager] closeSocket];
//        
//        
//        // 获取token失败, 跳转到登录页
//        [JPUSHService setTags:nil aliasInbackground:nil];
//        if ([[[YDGlobal manager] drivertimeTimer] isValid]) {
//            [[[YDGlobal manager] drivertimeTimer] invalidate];
//            [[YDGlobal manager] setDrivertimeTimer:nil];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"OutOffLine" object:nil];
//        [APPDELEGATE resetRootControllerWithVCName:@"YDLoginController"];
//        
//        
//        
//        
//    }
//}















@end
