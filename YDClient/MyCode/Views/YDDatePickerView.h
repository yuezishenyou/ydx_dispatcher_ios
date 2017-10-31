//
//  YDDatePickerView.h
//  YDClient
//
//  Created by yuedao on 2017/10/26.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDDatePickerView : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, copy) void (^choseTimeSucess)(NSString *date, NSString *hour, NSString *minute);
- (void)show;

- (void)hidden;

@end
