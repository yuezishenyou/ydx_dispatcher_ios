//
//  MessageModel.h
//  YDClient
//
//  Created by 杨广军 on 2017/10/31.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"

@interface MessageModel : NSObject

@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubbleImageData;

//头像
@property (nonatomic, strong) NSDictionary *avatars;
//消息
@property (nonatomic ,strong) NSMutableArray *messages;


@end
