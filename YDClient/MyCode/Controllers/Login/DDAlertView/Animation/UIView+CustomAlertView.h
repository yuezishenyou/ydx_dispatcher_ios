//
//  UIView+CustomAlertView.h
//  CustomAnimation
//
//  Created by ning on 2017/4/17.
//  Copyright © 2017年 songjk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomAnimationMode) {
    CustomAnimationModeAlert = 0,//弹出效果
    CustomAnimationModeDrop //由上方掉落
};

@interface UIView (CustomAlertView)



/**
 显示 弹出view 任意view导入头文件之后即可调用 alpha 默认 0.2 传 -1 代表默认值
 */
-(void)showInWindowWithMode:(CustomAnimationMode)animationMode bgAlpha:(CGFloat)alpha;

/**
 隐藏 view
 */
-(void)hideView;


@end
