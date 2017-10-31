//
//  DDVerifyView.m
//  MQVerCodeInputView
//
//  Created by maoziyue on 2017/10/26.
//  Copyright © 2017年  林美齐. All rights reserved.
//

#import "DDVerifyView.h"
#import "UIView+MQ.h"

#define xdSpace 5
#define xdFont  20

@interface DDVerifyView()<UITextViewDelegate>
{
    CGFloat width;
    CGFloat height;
}

@property (nonatomic, strong) UIView *contairView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *viewArr;
@property (nonatomic, strong) NSMutableArray *labelArr;
@property (nonatomic, strong) NSMutableArray *pointlineArr;


@end

@implementation DDVerifyView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultValue];
    }
    return self;
}

-(void)initDefaultValue
{
    width = self.frame.size.width;
    height = self.frame.size.height;
    
    //初始化默认值
    self.maxLenght = 4;
    _viewColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    _viewColorHL = [UIColor colorWithRed:255/255.0 green:70/255.0 blue:62/255.0 alpha:1];
    self.backgroundColor = [UIColor clearColor];
    [self beginEdit];
}

-(void)mq_verCodeViewWithMaxLenght
{
    //创建输入验证码view
    if (_maxLenght<=0)
    {
        return;
    }
    if (_contairView)
    {
        [_contairView removeFromSuperview];
    }
    
    
    _contairView  = [[UIView alloc]init];
    _contairView.frame = CGRectMake(0, 0, width, height);
    _contairView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contairView];

    self.textView.frame = _contairView.bounds;
    [_contairView addSubview:self.textView];
    
    
    UIView *lastView;
    
    for (int i = 0; i < self.maxLenght; i++)
    {
        CGFloat tSpace = (self.maxLenght - 1) *xdSpace;
        CGFloat subW = (width - tSpace) / self.maxLenght;
        
        UIView *subView = [[UIView alloc]init];
        subView.backgroundColor = [UIColor whiteColor];
        subView.cornerRadius = 4;
        subView.borderWidth = (0.5);
        subView.userInteractionEnabled = NO;
        [_contairView addSubview:subView];
        subView.frame = CGRectMake(i * (subW + xdSpace) , 0, subW, height);
        

        UILabel *subLabel = [[UILabel alloc]init];
        subLabel.font = [UIFont systemFontOfSize:xdFont];
        [subView addSubview:subLabel];
        
        subLabel.frame = subView.bounds;
        subLabel.textAlignment = NSTextAlignmentCenter;

        lastView = subView;
        
        CGRect rect = CGRectMake(subLabel.center.x , 5 , 2 , height - 10);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor =  _viewColorHL.CGColor;
        [subView.layer addSublayer:line];
        
        if (i == 0)
        {//初始化第一个view为选择状态
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            line.hidden = NO;
            subView.borderColor = _viewColorHL;
        }
        else
        {
            line.hidden = YES;
            subView.borderColor = _viewColor;
        }
        [self.viewArr addObject:subView];
        [self.labelArr addObject:subLabel];
        [self.pointlineArr addObject:line];
    }
}

#pragma mark - TextView

-(void)beginEdit
{
    [self.textView becomeFirstResponder];
}

-(void)endEdit
{
    [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    NSString *verStr = textView.text;
    //有空格去掉空格
    verStr = [verStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (verStr.length >= _maxLenght) {
        verStr = [verStr substringToIndex:_maxLenght];
        [self endEdit];
    }
    textView.text = verStr;
    
    if (self.block) {
        //将textView的值传出去
        self.block(verStr);
    }
    
    for (int i= 0; i < self.viewArr.count; i++)
    {
        //以text为中介区分
        UILabel *label = self.labelArr[i];
        if (i<verStr.length)
        {
            [self changeViewLayerIndex:i pointHidden:YES];
            label.text = [verStr substringWithRange:NSMakeRange(i, 1)];
            
        }
        else
        {
            [self changeViewLayerIndex:i pointHidden:i==verStr.length?NO:YES];
            if (!verStr&&verStr.length==0) {//textView的text为空的时候
                [self changeViewLayerIndex:0 pointHidden:NO];
            }
            label.text = @"";
        }
    }
}

- (void)changeViewLayerIndex:(NSInteger)index pointHidden:(BOOL)hidden
{
    
    UIView *view = self.viewArr[index];
    view.borderColor = hidden?_viewColor:_viewColorHL;
    CAShapeLayer *line =self.pointlineArr[index];
    if (hidden)
    {
        [line removeAnimationForKey:@"kOpacityAnimation"];
    }
    else
    {
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    line.hidden = hidden;
    
}

- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}


#pragma mark --setter&&getter

-(void)setMaxLenght:(NSInteger)maxLenght{
    _maxLenght = maxLenght;
}

-(void)setKeyBoardType:(UIKeyboardType)keyBoardType{
    _keyBoardType = keyBoardType;
    self.textView.keyboardType = keyBoardType;
}

-(void)setViewColor:(UIColor *)viewColor{
    _viewColor = viewColor;
}

-(void)setViewColorHL:(UIColor *)viewColorHL{
    _viewColorHL = viewColorHL;
}

-(UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.tintColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.keyboardType = UIKeyboardTypePhonePad;
    }
    return _textView;
}

-(NSMutableArray *)pointlineArr
{
    if (!_pointlineArr) {
        _pointlineArr = [NSMutableArray new];
    }
    return _pointlineArr;
}
-(NSMutableArray *)viewArr
{
    if (!_viewArr) {
        _viewArr = [NSMutableArray new];
    }
    return _viewArr;
}
-(NSMutableArray *)labelArr
{
    if (!_labelArr) {
        _labelArr = [NSMutableArray new];
    }
    return _labelArr;
}









@end
