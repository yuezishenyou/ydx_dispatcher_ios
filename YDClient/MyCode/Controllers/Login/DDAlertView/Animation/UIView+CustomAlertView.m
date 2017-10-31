//
//  UIView+CustomAlertView.m
//  CustomAnimation
//
//  Created by ning on 2017/4/17.
//  Copyright © 2017年 songjk. All rights reserved.
//

#import "UIView+CustomAlertView.h"
#import <objc/runtime.h>
#define TagValue  3333
#define ALPHA  0.2 //背景
#define AlertTime 0.3 //弹出动画时间
#define DropTime 0.5 //落下动画时间

@implementation UIView (CustomAlertView)

static CustomAnimationMode mode;
static CGFloat  
bgAlpha;
/*
- (void)setBgAlpha:(CGFloat)bgAlpha{
    objc_setAssociatedObject(self, BGALPHA, @(bgAlpha), OBJC_ASSOCIATION_ASSIGN);
}
- (CGFloat)bgAlpha{
    return [objc_getAssociatedObject(self, @"bgAlpha") floatValue];
}
 */

-(void)showInWindowWithMode:(CustomAnimationMode)animationMode bgAlpha:(CGFloat)alpha{
    mode = animationMode;
    bgAlpha = alpha;
    [self keyBoardListen];
    switch (animationMode) {
        case CustomAnimationModeAlert:
            [self showInWindow];
            break;
        case CustomAnimationModeDrop:
            [self upToDownShowInWindow];
            break;
        default:
            break;
    }
}

-(void)hideView
{
    [self removeKeyBoardListen];
    [self tapBgView];
}

-(void)showInWindow{
    if (self.superview) {
        [self removeFromSuperview];
    }
    [self addViewInWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.center = [UIApplication sharedApplication].keyWindow.center;
    self.alpha = 0;
    self.transform = CGAffineTransformScale(self.transform,0.1,0.1);
    [UIView animateWithDuration:AlertTime animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
}

-(void)upToDownShowInWindow{
    if (self.superview) {
        [self removeFromSuperview];
    }
    [self addViewInWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGFloat x = ([UIApplication sharedApplication].keyWindow.bounds.size.width-self.frame.size.width)/2;
    CGFloat y = -self.frame.size.height;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
    [UIView animateWithDuration:DropTime delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.center = [UIApplication sharedApplication].keyWindow.center;
    } completion:^(BOOL finished) {
        
    }];
}

//弹出隐藏
-(void)hide
{
    if (self.superview)
    {
        [UIView animateWithDuration:0.0 animations:^{
            self.transform = CGAffineTransformScale(self.transform,0.1,0.1);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self hideAnimationFinish];
        }];
    }
}
//下滑隐藏
-(void)dropDown{
    if (self.superview) {
        [UIView animateWithDuration:DropTime delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(self.frame.origin.x, [UIApplication sharedApplication].keyWindow.bounds.size.height, self.frame.size.width, self.frame.size.width);
        } completion:^(BOOL finished) {
            [self hideAnimationFinish];
        }];
    }
}

-(void)hideAnimationFinish
{
    UIView *bgvi = [[UIApplication sharedApplication].keyWindow viewWithTag:TagValue];
    if (bgvi)
    {
        [bgvi removeFromSuperview];
    }
    [self removeFromSuperview];
}

-(void)tapBgView
{
    switch (mode) 
    {
        case CustomAnimationModeAlert:
            [self hide];
            break;
        case CustomAnimationModeDrop:
            [self dropDown];
            break;
        default:
            break;
    }
}



/**
 加入背景view
 */
-(void)addViewInWindow{
    UIView *oldView = [[UIApplication sharedApplication].keyWindow viewWithTag:TagValue];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    
    
    UIView *v = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    v.tag = TagValue;
    [self addGuesture:v];
    v.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:bgAlpha == -1 ? ALPHA : bgAlpha];
    
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//
//    effectView.frame = v.bounds;
//
//    [v addSubview:effectView];
    

    [[UIApplication sharedApplication].keyWindow addSubview:v];
    

}
//添加背景view手势
-(void)addGuesture:(UIView *)vi
{
    //背景不加点击手势
    
//    vi.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
//    [vi addGestureRecognizer:tap];
    
}
#pragma mark - 键盘弹起监听
- (void)keyBoardListen {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)removeKeyBoardListen{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标;
    if (CGRectGetMaxY(self.frame)>=keyBoardEndY) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect _frame = self.frame;
            _frame.origin.y = keyBoardEndY-_frame.size.height-10;
            self.frame = _frame;
        }];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)noti {
    [UIView animateWithDuration:0.5 animations:^{
        self.center = [UIApplication sharedApplication].keyWindow.center;
    }];
}



@end
