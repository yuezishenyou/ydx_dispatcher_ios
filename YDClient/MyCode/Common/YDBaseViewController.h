//
//  YDBaseViewController.h
//  YDClient
//
//  Created by 徐丽然 on 2017/8/16.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NibType) {
    NibTypeNone = 0,//没有
    NibTypeiPhone,  //iPhone
    NibTypeiPad,    //iPad
};








@interface YDBaseViewController : UIViewController

//如果是xib ，初始化
- (instancetype)initWithNibVCName:(NSString *)vcName;



// title
@property (nonatomic, copy) NSString *titleString;
// 导航栏左侧按钮
@property (nonatomic, retain) UIButton * leftNavButton;
// 导航栏
@property (nonatomic, retain) UIView *navView;

// 标题
@property (nonatomic, retain) UILabel *titleLabel;

// 设置导航栏
- (void)setNavigationController;

- (void)backClick;


@end
