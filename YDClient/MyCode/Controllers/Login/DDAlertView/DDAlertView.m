//
//  DDAlertView.m
//  ydx_login
//
//  Created by maoziyue on 2017/10/26.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "DDAlertView.h"
#import "DDPhoneTextField.h"
#import "TimerManager.h"
#import "DDVerifyView.h"
#import "NSString+Valid.h"


#define xdSpace  20
#define xdFont   17
#define xsFont   14
#define xdTime   @"verityTime"
#define xdInit   20

@interface DDAlertView ()
{
    CGFloat width;
    CGFloat height;
    NSInteger count;//倒计时
}
//1
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) DDPhoneTextField *textFieldPhone;
@property (nonatomic,strong) UITextField *textFieldPass;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
@property (nonatomic,strong) UIButton *forgetBtn;
@property (nonatomic,strong) UIButton *loginBtn;

//2
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel  *descriptionLab;//描述文字
@property (nonatomic,strong) UIButton *sendBtn;//发送验证码
@property (nonatomic,strong) DDVerifyView *verView;//验证码输入框

//3
@property (nonatomic,strong) UITextField *textFieldSet;//设置密码
@property (nonatomic,strong) UIView  *line3;
@property (nonatomic,strong) UILabel *explainLab1;
@property (nonatomic,strong) UILabel *explainLab2;
@property (nonatomic,strong) UIButton *reSetBtn;//确定



@end 


@implementation DDAlertView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        width = frame.size.width;
        height = frame.size.height;
        count = xdInit;
        [self keyboard];
    }
    return self;
}

- (void)keyboard
{
   
}

- (void)setAlertViewType:(DDAlertViewType)alertViewType
{
    _alertViewType = alertViewType;
    
    if (alertViewType == alertViewTypeLogin)
    {
        //NSLog(@"--1--");
        
        [self setup];
        [self showInWindowWithMode:CustomAnimationModeAlert bgAlpha:0.5];
    }
    else if (alertViewType == alertViewTypeVertify)
    {
        //NSLog(@"--2--");
        [self setup2];
        [self showInWindowWithMode:CustomAnimationModeAlert bgAlpha:0.5];
       
        [self runTimer];
    }
    else if(alertViewType == alertViewTypePass)
    {
        //NSLog(@"--3--");
        [self setup3];
        [self showInWindowWithMode:CustomAnimationModeAlert bgAlpha:0.5];
    }
}






- (void)setup
{
    
    if (_backBtn) {
        _backBtn.hidden        = YES;
        [_backBtn removeFromSuperview];
        _backBtn = nil;
    }
    if (_descriptionLab) {
        _descriptionLab.hidden = YES;
        [_descriptionLab removeFromSuperview];
        _descriptionLab = nil;
    }
    if (_sendBtn) {
        _sendBtn.hidden        = YES;
        [_sendBtn removeFromSuperview];
        _sendBtn = nil;
    }
    if (_verView) {
        _verView.hidden        = YES;
        [_verView removeFromSuperview];
        _verView = nil;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.titleLab.text = @"密码登陆";
    
    [self addSubview:self.cancelBtn];
    [self addSubview:self.titleLab];
    [self addSubview:self.textFieldPhone];
    [self addSubview:self.line1];
    [self addSubview:self.textFieldPass];
    [self addSubview:self.line2];
    [self addSubview:self.forgetBtn];
    [self addSubview:self.loginBtn];
    
    _textFieldPhone.hidden = NO;
    _line1.hidden          = NO;
    _textFieldPass.hidden  = NO;
    _line2.hidden          = NO;
    _forgetBtn.hidden      = NO;
    _loginBtn.hidden       = NO;
    
    CGFloat kWidth = [[UIScreen mainScreen]bounds].size.width;
    CGFloat kHeight = [[UIScreen mainScreen]bounds].size.height;
    self.frame = CGRectMake(0, 0, width, CGRectGetMaxY(_loginBtn.frame));
    self.center = CGPointMake(kWidth / 2, kHeight / 2);

}

- (void)setup2
{
    
    _textFieldPhone.hidden = YES;
    _line1.hidden          = YES;
    _textFieldPass.hidden  = YES;;
    _line2.hidden          = YES;
    _forgetBtn.hidden      = YES;
    _loginBtn.hidden       = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.titleLab.text = @"验证码登录";
    
    NSString *tel = self.textFieldPhone.text;
    self.descriptionLab.text = [NSString stringWithFormat:@"验证码已发送至 %@",tel];
    
    
    [self addSubview:self.cancelBtn];
    [self addSubview:self.backBtn];
    [self addSubview:self.descriptionLab];
    [self addSubview:self.sendBtn];
    [self addSubview:self.verView];
    
    __weak typeof(self) weakSelf = self;
    self.verView.block = ^(NSString *text){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"text = %@",text);
        
        //这里做看做什么操作了
        if (text.length == 5 && [text isEqualToString:@"10086"])
        {
            [strongSelf stopTimer];
            
            strongSelf.alertViewType = alertViewTypePass;
        }
        
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.verView beginEdit];
    });
    

    _backBtn.hidden        = NO;
    _descriptionLab.hidden = NO;
    _sendBtn.hidden        = NO;
    _verView.hidden        = NO;
    
    
    CGFloat kWidth = [[UIScreen mainScreen]bounds].size.width;
    CGFloat kHeight = [[UIScreen mainScreen]bounds].size.height;
    self.frame = CGRectMake(0, 0, width, CGRectGetMaxY(_verView.frame) + xdSpace );
    self.center = CGPointMake(kWidth / 2, kHeight / 2);
}

- (void)setup3
{
    if (_backBtn) {
        _backBtn.hidden = YES;
        [_backBtn removeFromSuperview];
    }
    if (_cancelBtn) {
        _cancelBtn.hidden = YES;
        [_cancelBtn removeFromSuperview];
    }
    if (_descriptionLab) {
        _descriptionLab.hidden = YES;
    }
    if (_sendBtn) {
        _sendBtn.hidden = YES;
    }
    if (_verView) {
        _verView.hidden = YES;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.titleLab.text = @"设置登录密码";
    
    
    [self addSubview:self.textFieldSet];
    [self addSubview:self.line3];
    [self addSubview:self.explainLab1];
    [self addSubview:self.explainLab2];
    [self addSubview:self.reSetBtn];
    
    
    CGFloat kWidth = [[UIScreen mainScreen]bounds].size.width;
    CGFloat kHeight = [[UIScreen mainScreen]bounds].size.height;
    self.frame = CGRectMake(0, 0, width, CGRectGetMaxY(_reSetBtn.frame) );
    self.center = CGPointMake(kWidth / 2, kHeight / 2);

}

- (void)hiddenSubViews
{
    
}


- (void)showSubViews
{
    
}




















#pragma mark --methods
- (void)cancelBtnAction:(UIButton *)btn
{
    [self hideView];
}

- (void)forgetBtnAction:(UIButton *)btn
{
    NSLog(@"--忘记密码--");
    NSString *phone = [_textFieldPhone.text stringByReplacingOccurrencesOfString:@" "withString:@""];
    
    if (![NSString validateMobile:phone]) {
        NSLog(@"---手机号码无效---");
        return ;
    }
    
    //要判断手机号是否正确
    self.alertViewType = alertViewTypeVertify;
}

- (void)loginBtnAction:(UIButton *)btn
{
    //判断手机号，密码格式是否正确
    NSString *phone = [self.textFieldPhone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *pass = self.textFieldPass.text;
    
//    if (![NSString validateMobile:phone]) {
//        NSLog(@"---手机号码无效---");
//        return;
//    }
//    if (![NSString validatePass:pass]) {
//        NSLog(@"----密码无效----");
//        return;
//    }
    

    //登录成功
    NSLog(@"--登录--");
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:@"isLogin"];
    [ud synchronize];
    

    [self hideView];
    
}

- (void)backBtnAction:(UIButton *)btn
{
    self.alertViewType = alertViewTypeLogin;
    [self stopTimer];
}

- (void)sendBtnAction:(UIButton *)btn
{
     NSLog(@"--重新发送验证码--");
    [self runTimer];
}


- (void)reSertBtnAction:(UIButton *)btn
{
    NSLog(@"--确定--");
    
    //成功后
    [self hideView];
}








// 忘记密码事件之后， 重新发送验证码
- (void)runTimer
{
    NSString * msg = [NSString stringWithFormat:@"%ds后重发",xdInit];
    [self.sendBtn setTitle:msg forState:UIControlStateNormal];
    self.sendBtn.userInteractionEnabled = NO;
    
    TimerManager *time = [TimerManager manager];
    __weak  TimerManager * weakTime = time;
    [time addTimerWithName:xdTime timerSpace:60.f timercb:^{
        NSLog(@"---count:%ld----",(long)count);
        count --;
        NSString * msg = [NSString stringWithFormat:@"%lds后重发",(long)count];
        [self.sendBtn setTitle:msg forState:UIControlStateNormal];
        
        if (count == 0)
        {
            [weakTime deleteTimerWithName:xdTime];
            count = xdInit;
            [self.sendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            self.sendBtn.userInteractionEnabled = YES;
        }
    }];
}


// 倒计时完毕 、输入验证码之后跳转成功、点击返回按钮、释放
- (void)stopTimer
{
    count = xdInit;
    TimerManager *time = [TimerManager manager];
    [time deleteTimerWithName:xdTime];
}



























#pragma mark --lazy
- (UILabel *)titleLab
{
    if (!_titleLab)
    {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, width, 20 )];
        _titleLab.font = [UIFont systemFontOfSize:17];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (DDPhoneTextField *)textFieldPhone
{
    if (_textFieldPhone == nil)
    {
        _textFieldPhone = [[DDPhoneTextField alloc]initWithFrame:CGRectMake(xdSpace, CGRectGetMaxY(_titleLab.frame)+ xdSpace/2 , width - xdSpace *2 , 50)];
        _textFieldPhone.borderStyle = UITextBorderStyleNone;
        _textFieldPhone.keyboardType = UIKeyboardTypeNumberPad;
        _textFieldPhone.font = [UIFont systemFontOfSize:xsFont];
        _textFieldPhone.placeholder = @"手机号";
    }
    return _textFieldPhone;
}

- (UIView *)line1
{
    if (!_line1)
    {
        _line1 = [[UIView alloc]initWithFrame:CGRectMake(xdSpace, CGRectGetMaxY(_textFieldPhone.frame), width - xdSpace *2, 1)];
        _line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _line1;
}

- (UITextField *)textFieldPass
{
    if (!_textFieldPass) {
        _textFieldPass = [[UITextField alloc]initWithFrame:CGRectMake(xdSpace, CGRectGetMaxY(_line1.frame) , width - xdSpace *2 , 50)];
        _textFieldPass.borderStyle = UITextBorderStyleNone;
        _textFieldPass.keyboardType = UIKeyboardTypePhonePad;
        _textFieldPass.font = [UIFont systemFontOfSize:xsFont];
        _textFieldPass.keyboardType = UIKeyboardTypeASCIICapable;
        _textFieldPass.autocorrectionType = UITextAutocorrectionTypeNo;
        _textFieldPass.spellCheckingType = UITextSpellCheckingTypeNo;
        _textFieldPass.placeholder = @"密码";
    }
    return _textFieldPass;
}

- (UIView *)line2
{
    if (!_line2)
    {
        _line2 = [[UIView alloc]initWithFrame:CGRectMake(xdSpace, CGRectGetMaxY(_textFieldPass.frame), width - xdSpace *2, 1)];
        _line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _line2;
}

- (UIButton *)forgetBtn
{
    if (!_forgetBtn) {
        _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetBtn.frame = CGRectMake((width - 120)/2, CGRectGetMaxY(_line2.frame), 120, 50);
        //_forgetBtn.backgroundColor = [UIColor yellowColor];
        _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_forgetBtn addTarget:self action:@selector(forgetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _forgetBtn;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(0, CGRectGetMaxY(_forgetBtn.frame), width, 40);
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _loginBtn.backgroundColor = [UIColor lightGrayColor];
        [_loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(width - 30, 0, 30, 30);
        _cancelBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

//
- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 30, 30);
        _backBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(UILabel *)descriptionLab
{
    if (!_descriptionLab) {
        _descriptionLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLab.frame) + xdSpace , width, 20)];
        _descriptionLab.textAlignment = NSTextAlignmentCenter;
        _descriptionLab.font = [UIFont systemFontOfSize:12];
        _descriptionLab.textColor = [UIColor lightGrayColor];
    }
    return _descriptionLab;
}


- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake((width - 120)/2, CGRectGetMaxY(_descriptionLab.frame) + xdSpace , 120, 30);
        _sendBtn.layer.cornerRadius = 3.0f;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.borderWidth = 1.0f;
        _sendBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //_sendBtn.backgroundColor = [UIColor yellowColor];
    }
    return _sendBtn;
}

- (DDVerifyView *)verView
{
    if (!_verView) {
        _verView = [[DDVerifyView alloc]initWithFrame:CGRectMake(xdSpace, CGRectGetMaxY(_sendBtn.frame) + xdSpace,width - xdSpace *2 , 40)];
        _verView.maxLenght = 5;//最大长度
        _verView.keyBoardType = UIKeyboardTypeNumberPad;
        _verView.viewColor = [UIColor redColor];
        [_verView mq_verCodeViewWithMaxLenght];
    }
    return _verView;
}

- (UITextField *)textFieldSet
{
    if (!_textFieldSet) {
        _textFieldSet = [[UITextField alloc]initWithFrame:CGRectMake(xdSpace, CGRectGetMaxY(_titleLab.frame) + xdSpace, width - xdSpace *2, 50)];
        _textFieldSet.borderStyle = UITextBorderStyleNone;
        _textFieldSet.keyboardType = UIKeyboardTypePhonePad;
        _textFieldSet.font = [UIFont systemFontOfSize:xsFont];
        _textFieldSet.keyboardType = UIKeyboardTypeASCIICapable;
        _textFieldSet.autocorrectionType = UITextAutocorrectionTypeNo;
        _textFieldSet.spellCheckingType = UITextSpellCheckingTypeNo;
        _textFieldSet.placeholder = @"密码";
    }
    return _textFieldSet;
}

- (UIView *)line3
{
    if (!_line3) {
        _line3 = [[UIView alloc]initWithFrame:CGRectMake(xdSpace, CGRectGetMaxY(_textFieldSet.frame), width - xdSpace *2, 1)];
        _line3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _line3;
}

- (UILabel *)explainLab1
{
    if (!_explainLab1) {
        _explainLab1 = [[UILabel alloc]initWithFrame:CGRectMake(xdSpace, CGRectGetMaxY(_line3.frame)+xdSpace/2, width - xdSpace *2, 10)];
        _explainLab1.font = [UIFont systemFontOfSize:12];
        _explainLab1.textColor = [UIColor lightGrayColor];
        _explainLab1.text = @"须包含数字、字母2种元素";
    }
    return _explainLab1;
}

- (UILabel *)explainLab2
{
    if (!_explainLab2) {
        _explainLab2 = [[UILabel alloc]initWithFrame:CGRectMake(xdSpace, CGRectGetMaxY(_explainLab1.frame)+xdSpace/2, width - xdSpace *2, 10)];
        _explainLab2.font = [UIFont systemFontOfSize:12];
        _explainLab2.textColor = [UIColor lightGrayColor];
        _explainLab2.text = @"密码长度须8-16位";
    }
    return _explainLab2;
}
- (UIButton *)reSetBtn
{
    if (!_reSetBtn) {
        _reSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reSetBtn.frame = CGRectMake(0, CGRectGetMaxY(_explainLab2.frame) + xdSpace, width, 40);
        _reSetBtn.backgroundColor = [UIColor lightGrayColor];
        [_reSetBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_reSetBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_reSetBtn addTarget:self action:@selector(reSertBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reSetBtn;
}

//    @property (nonatomic,strong) UITextField *textFieldSet;//设置密码
//    @property (nonatomic,strong) UIView  *line3;
//    @property (nonatomic,strong) UILabel *explainLab1;
//    @property (nonatomic,strong) UILabel *explainLab2;
//    @property (nonatomic,strong) UIButton *reSetBtn;//确定




























- (void)dealloc
{
    [self stopTimer];
    NSLog(@"--DD释放--");
}


@end
