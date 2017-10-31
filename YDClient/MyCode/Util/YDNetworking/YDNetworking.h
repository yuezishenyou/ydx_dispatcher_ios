//
//  YDNetworking.h
//  HH_Entity
//
//  Created by maoziyue on 17/6/2.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface YDNetworking : NSObject

//// 登录
//+ (void)postGetLoginWithDictionary:(NSDictionary *)dict resultBlock:(void(^)(YDLoginModel *model,NSError *error))block;
//
//// 登出
//+ (void)postGetLoginOutWithDictionary:(NSDictionary *)dict resultBlock:(void(^)(YDLoginOutModel *model,NSError *error))block;





























/**
 * 2008
 * 修改头像
 */
//+ (void)changHeaderImageWihtImage:(UIImage *)image dictionary:(NSDictionary *)dic resltBlock:(void (^)(YDUpLoadModel *model, NSError *error))block;












@end
