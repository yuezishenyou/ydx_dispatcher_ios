//
//  PersonCenterCell.m
//  YDDriver
//
//  Created by 徐丽然 on 17/9/22.
//  Copyright © 2017年 Shanghai Meiyue InfoTech Ltd. All rights reserved.
//

#import "YDPersonCenterCell.h"

@interface YDPersonCenterCell ()

@property (weak, nonatomic) IBOutlet UIView *tapView;


@end


@implementation YDPersonCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkInfoAction)];
    [self.tapView addGestureRecognizer:tap];

}

- (void)checkInfoAction{
    if (self.checkInfo) {
        self.checkInfo();
    }
}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    
//}

@end
