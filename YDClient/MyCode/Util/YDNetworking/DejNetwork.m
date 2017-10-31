//
//  DejNetwork.m
//  Briefing
//
//  Created by maoziyue on 2017/9/22.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "DejNetwork.h"
#import "AFNetworking.h"
#import "AppDelegate.h"


@interface DejNetwork ()

@property (nonatomic,strong)AFHTTPSessionManager *sessionManager;

@end

@implementation DejNetwork

/**
 * 单例  这个是json格式的
 */
+ (instancetype)manager
{
    static DejNetwork *_netWork = nil;
    if (_netWork == nil) {
        _netWork = [[DejNetwork alloc]init];
        _netWork.sessionManager = [AFHTTPSessionManager manager];
        _netWork.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _netWork.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_netWork.sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _netWork.sessionManager.requestSerializer.timeoutInterval = 10.f;//时间15秒
        [_netWork.sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        _netWork.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_netWork.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
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
    
    __block DejNetwork *manager = [DejNetwork manager];
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
    
    
    __block DejNetwork *manager = [DejNetwork manager];
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














@end
