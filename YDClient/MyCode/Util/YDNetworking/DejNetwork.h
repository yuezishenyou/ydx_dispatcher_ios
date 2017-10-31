//
//  DejNetwork.h
//  Briefing
//
//  Created by maoziyue on 2017/9/22.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void (^successBlock)(id responseBody);
typedef void (^failureBlock)(NSError *error);


@interface DejNetwork : NSObject











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
