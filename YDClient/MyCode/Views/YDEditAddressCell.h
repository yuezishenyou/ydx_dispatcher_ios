//
//  YDEditAddressCell.h
//  YDClient
//
//  Created by yuedao on 2017/10/26.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDEditAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UIButton *resveTime;

@property (nonatomic, strong) NSDictionary *dic;


@end
