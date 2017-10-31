//
//  YDLoginController.h
//  YDClient
//
//  Created by 徐丽然 on 2017/8/16.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBaseViewController.h"

@interface YDLoginController : YDBaseViewController

@property (nonatomic, assign) BOOL isLogin;

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *verTextField;
@property (weak, nonatomic) IBOutlet UIButton *goRegist;

@end
