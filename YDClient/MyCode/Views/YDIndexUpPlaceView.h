//
//  YDIndexUpPlaceView.h
//  YDClient
//
//  Created by 徐丽然 on 2017/8/18.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDIndexUpPlaceView : UIView

/** 上车地址 */
@property (nonatomic, strong) UILabel *upPlaceLabel;

/** 选择上车地址 block */
@property (nonatomic, copy) void (^choseUpPlace)(void);

/** 显示个人信息 block */
@property (nonatomic, copy) void (^showPersonInfo)(void);

@end
