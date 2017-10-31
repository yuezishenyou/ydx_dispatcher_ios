//
//  PersonCenterView.h
//  YDDriver
//
//  Created by 徐丽然 on 17/9/22.
//  Copyright © 2017年 Shanghai Meiyue InfoTech Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDPersonCenterView : UIView

@property (nonatomic, copy) void (^clickHeaderView)(void);

// 跳转到我的订单, 设置界面
@property (nonatomic, copy) void (^checkMorePersonInfo)(NSInteger index);

@property (nonatomic, copy) void (^showLoadingViewForView)(void);

@property (nonatomic, copy) void (^hideLoadingViewForView)(void);

- (void)setDateWithName:(NSString *)name andScore:(CGFloat)score firstLoad:(BOOL)first;

- (void)setHeaderImageWithFirstLoad:(BOOL)first;

- (void)show;

@end
