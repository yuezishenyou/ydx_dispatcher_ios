//
//  YDConfirmOrderView.h
//  YDClient
//
//  Created by 徐丽然 on 2017/8/22.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDConfirmOrderView : UIView

/** 显示当前视图 */
- (void)show;

@property (weak, nonatomic) IBOutlet UILabel *mileLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayout;
@property (weak, nonatomic) IBOutlet UILabel *departureTime;


/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *silderBackView;


/** 价格 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) NSMutableArray *addressArray;

/** 叫车的回调事件 */
@property (nonatomic, copy) void (^callCar)(void);

/** 增加地址的回调 */
@property (nonatomic, copy) void (^addMiddlePlace)(void);

/** 选择地址 */
@property (nonatomic, copy) void (^choseTimeAction)(void);


@end
