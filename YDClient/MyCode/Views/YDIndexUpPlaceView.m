//
//  YDIndexUpPlaceView.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/18.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDIndexUpPlaceView.h"
#import "DDAlertView.h"

@implementation YDIndexUpPlaceView
{
    CGFloat width;
    CGFloat height;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        width = frame.size.width;
        height = frame.size.height;
        
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    self.backgroundColor = [UIColor clearColor];
    self.upPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.upPlaceLabel.text = @"正在获取上车位置";
    self.upPlaceLabel.textAlignment = NSTextAlignmentCenter;
    self.upPlaceLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.upPlaceLabel];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, height + 10, height)];
    [button setImage:[UIImage imageNamed:@"nav_person_icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    button.backgroundColor = [UIColor redColor];

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.choseUpPlace) {
        self.choseUpPlace();
    }
}

- (void)buttonAction
{

    
    
    if (self.showPersonInfo)
    {
        self.showPersonInfo();
    }
}



@end
