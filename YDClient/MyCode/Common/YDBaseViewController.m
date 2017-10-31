//
//  YDBaseViewController.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/16.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBaseViewController.h"

@interface YDBaseViewController ()

@end

@implementation YDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setNavigationController];
}


- (instancetype)initWithNibVCName:(NSString *)vcName
{
    NibType type;
    if ([[UIDevice currentDevice]userInterfaceIdiom]== UIUserInterfaceIdiomPhone) {
        type = NibTypeiPhone;
    }else{
        type = NibTypeiPad;
    }
    return [self initWithVCName:vcName nibType:type];
}

- (instancetype)initWithVCName:(NSString *)vcName nibType:(NibType)type
{
    NSString *xib_name ;
    
    if(type == NibTypeiPhone){
        xib_name = [NSString stringWithFormat:@"%@_iPhone",vcName];
    }
    else if (type == NibTypeiPad ){
        xib_name = [NSString stringWithFormat:@"%@_iPad",vcName];
    }
    self = [super initWithNibName:xib_name bundle:nil];
    
    return self;
}


























/**
 * 设置导航栏
 */
- (void)setNavigationController{
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kNavAndStatusHeight)];
    _navView.userInteractionEnabled = YES;
    _navView.backgroundColor = getColor(@"ffffff");
    
    [self.view addSubview:_navView];
    
    // 左返回按钮
    // 返回按钮
    _leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftNavButton.frame = CGRectMake(10, kStatusHeight + (kNaviHeight - 28) / 2, 38, 28);
    [_leftNavButton setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    
    [_leftNavButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [_leftNavButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_leftNavButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [_navView addSubview:_leftNavButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _titleLabel.textColor = getColor(@"000000");
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.center = CGPointMake(_navView.center.x, _navView.center.y + kStatusHeight / 2);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_navView addSubview:_titleLabel];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kNavAndStatusHeight - 1, kScreenSize.width, 1)];
    bottomLine.backgroundColor = getColor(@"c1c1c1");
    bottomLine.tag = 100;
    
    [_navView addSubview:bottomLine];
    
}

- (void)setTitleString:(NSString *)titleString{
    self.titleLabel.text = titleString;
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
