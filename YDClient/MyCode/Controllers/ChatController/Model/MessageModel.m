//
//  MessageModel.m
//  YDClient
//
//  Created by 杨广军 on 2017/10/31.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "MessageModel.h"


@implementation MessageModel

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.messages = [[NSMutableArray alloc]init];
        
        JSQMessagesAvatarImage *userImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"yang" backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f] textColor:[UIColor colorWithWhite:0.60f alpha:1.0f] font:[UIFont systemFontOfSize:14.0f] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        JSQMessagesAvatarImage *cookImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_cook"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        JSQMessagesAvatarImage *jobsImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_jobs"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *wozImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_woz"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        self.avatars = @{ @"00" : userImage,
                          @"11" : cookImage,
                          @"22" : jobsImage,
                          @"33" : wozImage };
        
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
        
    }
    
    return self;
}
/**
 发送语音消息*/
- (void)addAudioMediaMessage
{
    NSString *senderId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *senderName = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
    NSString * sample = [[NSBundle mainBundle] pathForResource:@"jsq_messages_sample" ofType:@"m4a"];
    NSData * audioData = [NSData dataWithContentsOfFile:sample];
    JSQAudioMediaItem *audioItem = [[JSQAudioMediaItem alloc] initWithData:audioData];
    JSQMessage *audioMessage = [JSQMessage messageWithSenderId:senderId
                                                   displayName:senderName
                                                         media:audioItem];
    [self.messages addObject:audioMessage];
}
/**
 发送图片*/
- (void)addPhotoMediaMessage
{
    NSString *senderId = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *senderName = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"goldengate"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:senderId
                                                   displayName:senderName
                                                         media:photoItem];
    [self.messages addObject:photoMessage];
}
/**
 发送定位*/
- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    
    JSQMessage *locationMessage = [JSQMessage messageWithSenderId:nil
                                                      displayName:nil
                                                            media:locationItem];
    [self.messages addObject:locationMessage];
}
/**
 发送视频*/
- (void)addVideoMediaMessage
{
    // don't have a real video, just pretending
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:nil
                                                   displayName:nil
                                                         media:videoItem];
    [self.messages addObject:videoMessage];
}
/**
 发送视频带图片提示*/
- (void)addVideoMediaMessageWithThumbnail
{
    // don't have a real video, just pretending
//    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
//    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES thumbnailImage:[UIImage imageNamed:@"goldengate"]];
//    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                   displayName:kJSQDemoAvatarDisplayNameSquires
//                                                         media:videoItem];
//    [self.messages addObject:videoMessage];
}



@end
