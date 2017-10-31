//
//  YDXPassLoginController.m
//  YDClient
//
//  Created by maoziyue on 2017/10/31.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDXPassLoginController.h"

@interface YDXPassLoginController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;



@end

@implementation YDXPassLoginController

- (void)setNavigationController
{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
}




- (IBAction)loginBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}











- (void)dealloc
{
    NSLog(@"--login释放--");
}



@end
