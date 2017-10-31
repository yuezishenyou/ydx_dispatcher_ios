//
//  YDPersonInfoCell.h
//  YDDriver
//
//  Created by 徐丽然 on 17/9/22.
//  Copyright © 2017年 Shanghai Meiyue InfoTech Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDPersonInfoCell : UITableViewCell
// 标题信息
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 详细信息
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
// 电话
@property (weak, nonatomic) IBOutlet UILabel *phoneLLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;


@end
