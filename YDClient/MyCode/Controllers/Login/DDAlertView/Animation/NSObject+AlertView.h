//
//  NSObject+AlertView.h
//  SJKAlertView
//
//  Created by ning on 2017/4/18.
//  Copyright © 2017年 songjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (AlertView)
-(void)showAlertViewWithMsg:(NSString *)msg viewController:(UIViewController *)vc cancle:(void(^)(void))cancle sure:(void(^)(void))sure;
@end
