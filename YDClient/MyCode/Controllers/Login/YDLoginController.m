//
//  YDLoginController.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/16.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDLoginController.h"
#import "YDIndexController.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "YDQRCodeController.h"
#import <AVFoundation/AVFoundation.h>

@interface YDLoginController ()

@property (weak, nonatomic) IBOutlet UIView *bgContentView;

@property (weak, nonatomic) IBOutlet UILabel *welcomeJionLabel;
@property (weak, nonatomic) IBOutlet UIButton *userDeleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *verCodeDeleteBtn;

@property (weak, nonatomic) IBOutlet UIButton *getVerCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *xieyiLabel;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImageV;


@property (weak, nonatomic) IBOutlet UILabel *dTimeLabel;//倒计时

@property (weak, nonatomic) IBOutlet UIView *agreeBackView;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger timeSecond;//秒

@end

@implementation YDLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userTextFieldChanged) name:UITextFieldTextDidChangeNotification object:_userTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verCodeTextFieldChanged) name:UITextFieldTextDidChangeNotification object:_verTextField];
    
}

/** 设置导航栏 */
//- (void)setNavigationController{
//    if (!self.isLogin) {
//        [super setNavigationController];
//        self.titleString = @"注册";
//    }
//}

/** 设置UI */
- (void)setUI
{
    if (self.isLogin)
    {
        self.welcomeJionLabel.text = @"欢迎登录悦道代叫中心";
        self.agreeBackView.hidden = YES;
        [self.registBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.registBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.goRegist setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -80)];
        [self.goRegist setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        
        UIImageView *leftUserImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28,22)];
        leftUserImageV.image = [UIImage imageNamed:@"log_account_icon"];
        leftUserImageV.contentMode = UIViewContentModeCenter;
        self.userTextField.leftView = leftUserImageV;
        self.userTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    else
    {
        self.goRegist.hidden = YES;
    }
    self.dTimeLabel.hidden = YES;
    self.verCodeDeleteBtn.hidden = YES;
    self.userDeleteBtn.hidden = YES;
    self.loadingImageV.hidden = YES;

}


/** 隐藏键盘 */
- (void)dismisKeyBoard
{
    [self.userTextField resignFirstResponder];
    [self.verTextField resignFirstResponder];
}

/** 清空内容并隐藏手机号删除button */
- (IBAction)userDeleteAction:(id)sender {
    self.userTextField.text = @"";
    self.userDeleteBtn.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeTimer];
}
/** 清空内容并隐藏验证码删除button */
- (IBAction)verifyCodeDeleteAction:(id)sender {
    self.verCodeDeleteBtn.hidden = YES;
    self.verTextField.text = @"";
}

/** 隐藏或显示手机号删除按钮 */
- (void)userTextFieldChanged
{
    if (self.userTextField.text.length >= 1) {
        self.userDeleteBtn.hidden = NO;
    }
    else
    {
        self.userDeleteBtn.hidden = YES;
    }
}

/** 显示或隐藏二维码删除按钮 */
- (void)verCodeTextFieldChanged
{
    if (self.verTextField.text.length >= 1) {
        self.verCodeDeleteBtn.hidden = NO;
    }else{
        self.verCodeDeleteBtn.hidden = YES;
    }
}


/** 跳转到注册页面 */
- (IBAction)goRegisterAction:(id)sender {
    if (self.timer && [self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
        self.getVerCodeBtn.hidden = NO;
        self.dTimeLabel.hidden = YES;
    }
    YDLoginController *vc = [[YDLoginController alloc] init];
    vc.isLogin = NO;
    [self.navigationController pushViewController:vc animated:YES];

}

/** 获取验证码计时器 */
- (void)createVerCodeTime {
    _timeSecond = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(timerAction)
                                                userInfo:nil
                                                 repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

/** 倒计时 */
- (void)timerAction {
    --_timeSecond ;
    
    NSString *timeString = [NSString stringWithFormat:@"%ldS",(long)_timeSecond];
    NSString *resendString = @"重新发送";
    NSMutableAttributedString *att1 = [self attributeStrWithString:timeString color:kRGBNomal size:16];
    NSMutableAttributedString *att2 = [self attributeStrWithString:resendString color:[UIColor lightGrayColor] size:12];
    
    [att1 appendAttributedString:att2];
    self.dTimeLabel.attributedText = att1;
    
    if (_timeSecond == -1)
    {
        self.dTimeLabel.hidden = YES;
        self.getVerCodeBtn.hidden = NO;
        [self.timer invalidate];
        self.timer = nil;
    }

}

/** 转换为富文本 */
- (NSMutableAttributedString *)attributeStrWithString:(NSString *)string color:(UIColor *)color size:(CGFloat)size
{
    
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName:color,
                           NSFontAttributeName:[UIFont systemFontOfSize:size]
                           };
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:string attributes:dict];
    return att;
}


/** 获取验证码 */
- (IBAction)getVerficationCode:(id)sender {
    self.dTimeLabel.hidden = NO;
    self.getVerCodeBtn.hidden = YES;
    [self createVerCodeTime];
}

/** 注册或登录 */
- (IBAction)registerButtonAction:(id)sender {
    if (self.isLogin) {
        // 登录
        YDIndexController *index = [[YDIndexController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:index];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


/** 判断是否同意四方协议 */
- (IBAction)agreeButtonAction:(id)sender {
    self.agreeBtn.selected = !self.agreeBtn.selected;
}


- (void)dealloc {
    DLog(@"=================dealloc");
}

- (void)removeTimer{
    if (self.timer && [self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
