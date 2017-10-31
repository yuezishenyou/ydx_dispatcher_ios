//
//  YDTipView.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/17.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDTipView.h"

@implementation YDTipView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    [self addSubview:backView];
    
    UIView *imageBackView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 280 / WIDTH_6S_SCALE) / 2, 100 / HEIGHT_6S_SCALE + 64, 280 / WIDTH_6S_SCALE, 290 / HEIGHT_6S_SCALE)];
    
    [self addSubview:imageBackView];
    
    self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280 / WIDTH_6S_SCALE, 290 / HEIGHT_6S_SCALE)];
    self.backImage.image = [UIImage imageNamed:@"scan_joinsuccess_bgimage"];
    [imageBackView addSubview:self.backImage];
    
    self.welcomeLabel = [self setLabelWithFrame:CGRectMake(0, 140 / HEIGHT_6S_SCALE, imageBackView.width, 18) font:[UIFont systemFontOfSize:16] color:getColor(@"353535")];
    self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel.text = @"恭喜您已成功加入";
    [imageBackView addSubview:self.welcomeLabel];
    
    self.hotelLabel = [self setLabelWithFrame:CGRectMake(0, self.welcomeLabel.y + 30, imageBackView.width, 20) font:[UIFont systemFontOfSize:18] color:getColor(MAIN_COLOR)];
    self.hotelLabel.textAlignment = NSTextAlignmentCenter;
    
    [imageBackView addSubview:self.hotelLabel];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(22 / WIDTH_6S_SCALE, self.hotelLabel.y + 55, imageBackView.width - 44 / WIDTH_6S_SCALE, 40)];
    [confirmButton addTarget:self action:@selector(confirmButtonClickAcion) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.layer.cornerRadius = 5;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton setTitleColor:getColor(@"ffffff") forState:UIControlStateNormal];
    [confirmButton setBackgroundColor:getColor(MAIN_COLOR)];
    
    [imageBackView addSubview:confirmButton];
}

- (void)confirmButtonClickAcion{
    if (self.confirmAction) {
        self.confirmAction();
    }
}

- (UILabel *)setLabelWithFrame:(CGRect)framme font:(UIFont *)font color: (UIColor *)color{
    UILabel *label = [[UILabel alloc] initWithFrame:framme];
    label.font = font;
    label.textColor = color;
    
    return label;
}

@end
