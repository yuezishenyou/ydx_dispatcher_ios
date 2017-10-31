//
//  YDNetWork.h
//  YDDriver
//
//  Created by maoziyue on 17/4/12.
//  Copyright © 2017年 Shanghai Meiyue InfoTech Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 定义成功的Block
 */
typedef void (^successBlock)(id responseBody);


/**
 * 定义失败的Block
 */
typedef void (^failureBlock)(NSError *error);


//************ 网络请求管理类 *****************/
@interface YDNetWork : NSObject





//****************************** 基础 *******************************/



/**
 * 单例
 */
+ (instancetype)manager;

/**
 * GET方法
 * 实例方法请求网络
 */
- (void)GET:(NSString *)urlStr parameters:(NSDictionary *)paramenters success:(successBlock)success failure:(failureBlock)failure;

/**
 * GET方法
 * 类方法请求网络
 */
+ (void)GET:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure;

/**
 * POST方法
 * 实例方法请求网络
 */
- (void)POST:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure;


/**
 * POST方法
 * 类方法请求网络
 */
+ (void)POST:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure;




@end
