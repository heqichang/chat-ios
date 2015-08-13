//
//  ChatListItemViewModel.h
//  chatDemo1
//
//  Created by HeQichang on 15/7/29.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatListItemViewModel : NSObject

@property (nonatomic, strong) NSURL *headImageURL;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *latestMessage;
@property (nonatomic, assign) NSInteger unreadCount;
@property (nonatomic, strong) NSString *latestMessageDate;

@end
