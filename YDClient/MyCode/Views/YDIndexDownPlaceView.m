//
//  YDIndexDownPlaceView.m
//  YDClient
//
//  Created by 徐丽然 on 2017/8/18.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDIndexDownPlaceView.h"

@implementation YDIndexDownPlaceView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubView];
    }
    return self;
}

- (void)setSubView {
    self.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width / 2, self.height)];
    label.text = @"您要去哪里?";
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chosePlace)];
    [label addGestureRecognizer:tap1];
    [self addSubview:label];
    
    self.minutelabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2, 0, self.width / 2, self.height)];
    self.minutelabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appointAction)];
    [self.minutelabel addGestureRecognizer:tap2];
    self.minutelabel.textAlignment = NSTextAlignmentCenter;
    self.minutelabel.text = @"接送机";
    [self addSubview:self.minutelabel];
}

// 选择下车地址
- (void)chosePlace{
    if (self.choseDownPlace) {
        self.choseDownPlace(YES);
    }
}

// 接送机
- (void)appointAction{
    if (self.choseDownPlace) {
        self.choseDownPlace(NO);
    }
}

@end
