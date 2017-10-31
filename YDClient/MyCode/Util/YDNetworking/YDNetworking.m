//
//  YDNetworking.m
//  HH_Entity
//
//  Created by maoziyue on 17/6/2.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "YDNetworking.h"
#import "MJExtension.h"
#import "YDNetWork.h"
#import "DejNetwork.h"


@implementation YDNetworking



//+ (void)postGetLoginWithDictionary:(NSDictionary *)dict resultBlock:(void(^)(YDLoginModel *model,NSError *error))block
//{
//    NSString *url = [NSString stringWithFormat:@"%@%@",GATEWAY,@"/login"];
//
//    [[YDNetWork manager] POST:url parameters:dict success:^(id responseBody) {
//
//
//
//
//    } failure:^(NSError *error) {
//
//
//    }];
//}

//+ (void)postGetLoginOutWithDictionary:(NSDictionary *)dict resultBlock:(void(^)(YDLoginOutModel *model,NSError *error))block
//{
//    NSString *url = [NSString stringWithFormat:@"%@%@",GATEWAY,@"/logout"];
//    [[DejNetwork manager]GET:url parameters:dict success:^(id responseBody) {
//
//        NSLog(@"----登出:%@----",responseBody);
//
//    } failure:^(NSError *error) {
//        NSLog(@"-----登出----");
//    }];
//}























///**
// * 2008
// * 修改头像
// */
//+ (void)changHeaderImageWihtImage:(UIImage *)image dictionary:(NSDictionary *)dic resltBlock:(void (^)(YDUpLoadModel *model, NSError *error))block
//{
//    
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
//                                                         
//                                                         @"text/html",
//                                                         
//                                                         @"image/jpeg",
//                                                         
//                                                         @"image/png",
//                                                         
//                                                         @"application/octet-stream",
//                                                         
//                                                         @"text/json",
//                                                         
//                                                         nil];
//    
//    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
//    
//    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
//    
//    NSString *url = [NSString stringWithFormat:@"%@?sid=2008&token=%@", GATEWAY, dic[@"token"]];
//    
//    
//    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//        NSData *picture = UIImageJPEGRepresentation(image, 0.5);
//        [formData appendPartWithFileData:picture name:@"photoPath" fileName:@"photo.jpg" mimeType:@"photo/jpg"];
//        
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        
//        NSLog(@"----%@----%@------",json[@"sid"],json);
//        
//        YDUpLoadModel *enti = [YDUpLoadModel mj_objectWithKeyValues:responseObject];
//        
//        if (block) {
//            block(enti,nil);
//        }
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        if (block) {
//            block(nil,error);
//        }
//        
//    }];
//    
//}











@end
