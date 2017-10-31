//
//  YDXLoginController.m
//  YDClient
//
//  Created by maoziyue on 2017/10/31.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDXLoginController.h"
#import "YDRegistController.h"
#import "YDLoginController.h"
#import "YDXPassLoginController.h"
#import "TimerManager.h"

#define xdTime   @"verityTime"
#define xdInit   20

@interface YDXLoginController ()
{
    NSInteger count;
}


@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPass;
@property (weak, nonatomic) IBOutlet UIButton *vertityBtn;
@property (weak, nonatomic) IBOutlet UIButton *changePassBtn;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;









@end

@implementation YDXLoginController

// 设置导航栏 不能删除
- (void)setNavigationController
{
    
}

- (void)loadView
{
    [super loadView];
    self.view.frame = [[UIScreen mainScreen]bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    
    
    [self initData];
    
    [self initSubVies];
    
    
}

- (void)initData
{
    count = xdInit;
}


- (void)initSubVies
{
    
}



- (IBAction)changePassBbtnAction:(id)sender {
    
    YDXPassLoginController *vc = [[YDXPassLoginController alloc]initWithNibVCName:@"YDXPassLoginController"];
    [self.navigationController pushViewController:vc animated:NO];
}


- (IBAction)loginBtnAction:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:@"isLogin"];
    
    NSLog(@"----登录成功---");
    
}


- (IBAction)vertityBtnAction:(id)sender {
    NSLog(@"---发送验证码---");
    
    self.vertityBtn.userInteractionEnabled = NO;
    
    [self runTimer];
    
    
    
}

- (IBAction)registBtnAction:(id)sender {
    
    YDRegistController *regist = [[YDRegistController alloc]initWithNibVCName:@"YDRegistController"];
    
    [self.navigationController pushViewController:regist animated:NO];
    
}










#pragma mark --Util

// 忘记密码事件之后， 重新发送验证码
- (void)runTimer
{
    NSString * msg = [NSString stringWithFormat:@"%ds后重发",xdInit];
    [self.vertityBtn setTitle:msg forState:UIControlStateNormal];
    self.vertityBtn.userInteractionEnabled = NO;
    
    TimerManager *time = [TimerManager manager];
    __weak  TimerManager * weakTime = time;
    [time addTimerWithName:xdTime timerSpace:60.f timercb:^{
        NSLog(@"---count:%ld----",(long)count);
        count --;
        NSString * msg = [NSString stringWithFormat:@"%lds后重发",(long)count];
        [self.vertityBtn setTitle:msg forState:UIControlStateNormal];
        
        if (count == 0)
        {
            [weakTime deleteTimerWithName:xdTime];
            count = xdInit;
            [self.vertityBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            self.vertityBtn.userInteractionEnabled = YES;
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








- (void)dealloc
{
    NSLog(@"--login释放--");
}





@end
