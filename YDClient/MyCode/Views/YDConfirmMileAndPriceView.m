//
//  YDConfirmMileAndPriceView.m
//  YDClient
//
//  Created by yuedao on 2017/10/24.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDConfirmMileAndPriceView.h"

@implementation YDConfirmMileAndPriceView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YDConfirmMileAndPriceView" owner:nil options:nil] lastObject];
    }
    
    return self;
}


@end
