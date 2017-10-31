//
//  YDPersonCenterHeaderView.h
//  YDDriver
//
//  Created by 徐丽然 on 17/9/22.
//  Copyright © 2017年 Shanghai Meiyue InfoTech Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDPersonCenterHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic, copy) void (^checkPersonInfo)(void);

@end
