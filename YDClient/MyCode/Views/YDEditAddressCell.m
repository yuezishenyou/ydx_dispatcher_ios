//
//  YDEditAddressCell.m
//  YDClient
//
//  Created by yuedao on 2017/10/26.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDEditAddressCell.h"

@implementation YDEditAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.address.text = dic[ADDRESS_NAME];
}
@end
