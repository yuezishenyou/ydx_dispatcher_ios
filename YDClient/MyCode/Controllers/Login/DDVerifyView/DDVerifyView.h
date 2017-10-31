//
//  DDVerifyView.h
//  MQVerCodeInputView
//
//  Created by maoziyue on 2017/10/26.
//  Copyright © 2017年  林美齐. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MQTextViewBlock)(NSString *text);

@interface DDVerifyView : UIView

@property (nonatomic, assign) UIKeyboardType keyBoardType;

@property (nonatomic, copy) MQTextViewBlock block;

/*验证码的最大长度*/
@property (nonatomic, assign) NSInteger maxLenght;
/*未选中下的view的borderColor*/
@property (nonatomic, strong) UIColor *viewColor;
/*选中下的view的borderColor*/
@property (nonatomic, strong) UIColor *viewColorHL;

-(void)mq_verCodeViewWithMaxLenght;

-(void)beginEdit;

@end
