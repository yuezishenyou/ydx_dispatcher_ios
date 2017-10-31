//
//  YDIndexDownPlaceView.h
//  YDClient
//
//  Created by 徐丽然 on 2017/8/18.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDIndexDownPlaceView : UIView

@property (nonatomic, strong) UILabel *minutelabel;

@property (nonatomic, copy) void (^choseDownPlace)(BOOL realTime);

@end
