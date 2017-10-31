//
//  YDSilderView.h
//  YDClient
//
//  Created by yuedao on 2017/10/24.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDSilderView : UIView

- (void)setInstallView;

// NO为预约, YES为实时
@property (nonatomic, copy) void (^changeCallModel)(BOOL);

@end
