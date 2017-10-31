//
//  YDPersonCenterHeaderView.m
//  YDDriver
//
//  Created by 徐丽然 on 17/9/22.
//  Copyright © 2017年 Shanghai Meiyue InfoTech Ltd. All rights reserved.
//

#import "YDPersonCenterHeaderView.h"

@implementation YDPersonCenterHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YDPersonCenterHeaderView" owner:nil options:nil] lastObject];
        self.headerImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personInfoDetail)];
        [self.headerImage addGestureRecognizer:tap];
    }
    return self;
}

- (void)personInfoDetail{
    if (self.checkPersonInfo) {
        self.checkPersonInfo();
    }
}

@end
