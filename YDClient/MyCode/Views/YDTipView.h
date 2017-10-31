//
//  YDTipView.h
//  YDClient
//
//  Created by 徐丽然 on 2017/8/17.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDTipView : UIView

@property (nonatomic, strong) UIImageView *backImage;

@property (nonatomic, strong) UILabel *welcomeLabel;

@property (nonatomic, strong) UILabel *hotelLabel;

@property (nonatomic, copy) void (^confirmAction)(void);

@end
