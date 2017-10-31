//
//  NSString+Valid.m
//  Briefing
//
//  Created by maoziyue on 2017/9/21.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "NSString+Valid.h"

@implementation NSString (Valid)


//手机号有效性
+ (BOOL)validateMobile:(NSString *)mobile
{
    
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (mobile.length != 11)
    {
        return NO;
    }
    else
    {
        
        /**
         
         * 移动号段正则表达式
         
         */
        
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        
        /**
         
         * 联通号段正则表达式
         
         */
        
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        /**
         
         * 电信号段正则表达式
         
         */
        
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        

        if (isMatch1 || isMatch2 || isMatch3)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}


+ (BOOL)validatePass:(NSString *)pass
{
    
    pass = [pass stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (pass.length == 0)
    {
        return NO;
    }
    
    ///^[a-zA-Z0-9]{6,10}$/
    NSString *pattern = @"^[a-zA-Z0-9]{6,18}$";
    //NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{4,18}"; //6-18位数字和字母组合
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    BOOL isMatch = [pred evaluateWithObject:pass];
    
    return isMatch;
    
}

+ (BOOL)validateEmail:(NSString *)email
{
    email = [email stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (email.length == 0)
    {
        return NO;
    }
    
    NSString* number=@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    
    return [numberPre evaluateWithObject:email];
}














@end
