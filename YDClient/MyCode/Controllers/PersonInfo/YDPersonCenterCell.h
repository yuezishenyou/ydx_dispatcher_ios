//
//  PersonCenterCell.h
//  YDDriver
//
//  Created by 徐丽然 on 17/9/22.
//  Copyright © 2017年 Shanghai Meiyue InfoTech Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDPersonCenterCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic, copy) void (^checkInfo)(void);


@end
