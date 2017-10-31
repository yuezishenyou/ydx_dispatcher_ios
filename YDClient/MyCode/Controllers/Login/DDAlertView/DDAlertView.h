//
//  DDAlertView.h
//  ydx_login
//
//  Created by maoziyue on 2017/10/26.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

typedef NS_ENUM(NSInteger, DDAlertViewType) {
    alertViewTypeLogin = 0,   //登录
    alertViewTypeVertify,     //验证码
    alertViewTypePass,        //设置密码
};

@interface DDAlertView : UIView

@property (nonatomic, assign) DDAlertViewType alertViewType;


@end
