//
//  YDRegistController.m
//  shiwo
//
//  Created by maoziyue on 2017/10/30.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "YDRegistController.h"
#import "HHServicePickerView.h"

@interface YDRegistController ()

@property (weak, nonatomic) IBOutlet UITextField *serPlace;//服务地点



@end

@implementation YDRegistController

- (void)loadView
{
    [super loadView];
    self.view.frame = [[UIScreen mainScreen]bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}





- (IBAction)chooseBtnAction:(id)sender {
    
    HHServicePickerView *servicePicker = [[HHServicePickerView alloc]init];
    
    [servicePicker setConfirmBlock:^(NSString *selectedService) {
        NSLog(@"----service:%@----",selectedService);
    }];
    
    
    [self.view addSubview:servicePicker];
    
}


- (IBAction)okAction:(id)sender {
    NSLog(@"--确定--");
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}















@end
