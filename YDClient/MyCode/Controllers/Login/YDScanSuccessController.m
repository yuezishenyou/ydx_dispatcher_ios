//
//  YDScanSuccessController.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/17.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDScanSuccessController.h"
#import "YDIndexController.h"
#import "YDTipView.h"
#import "AppDelegate.h"

@interface YDScanSuccessController ()

@end

@implementation YDScanSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleString = @"扫码加入";
    [self setUI];
}

/** 设置UI */
- (void)setUI {

    YDTipView *tipView = [[YDTipView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    tipView.hotelLabel.text = [NSString stringWithFormat:@"%@代叫服务组", self.hotelName];
    [tipView setConfirmAction:^{
        YDIndexController *index = [[YDIndexController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:index];
    }];
    [self.view addSubview:tipView];
}

/** 返回 */
- (void)backClick {}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
