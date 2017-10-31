//
//  NSObject+AlertView.m
//  SJKAlertView
//
//  Created by ning on 2017/4/18.
//  Copyright © 2017年 songjk. All rights reserved.
//

#import "NSObject+AlertView.h"

@implementation NSObject (AlertView)
-(void)showAlertViewWithMsg:(NSString *)msg viewController:(UIViewController *)vc cancle:(void(^)())cancle sure:(void(^)())sure{//@"提示"
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cancle();
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sure();
    }];
    [alert addAction:action];
    [alert addAction:action2];
    [vc presentViewController:alert animated:YES completion:nil];
}
@end
