//
//  HHServicePickerView.h
//  shiwo
//
//  Created by maoziyue on 2017/10/30.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HHServicePickerViewBlock)(NSString *selectedService);

@interface HHServicePickerView : UIView

@property (strong, nonatomic) HHServicePickerViewBlock confirmBlock;

- (instancetype)initWithInitialService:(NSString *)initialService;

- (instancetype)init;


@end
