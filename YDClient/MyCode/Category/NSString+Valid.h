//
//  NSString+Valid.h
//  Briefing
//
//  Created by maoziyue on 2017/9/21.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import <Foundation/Foundation.h>



//************* 验证是否有效 *****************/
@interface NSString (Valid)


//手机号有效性
+ (BOOL)validateMobile:(NSString *)mobile;

+ (BOOL)validatePass:(NSString *)pass;


@end
