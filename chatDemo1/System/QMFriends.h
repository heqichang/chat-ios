//
//  QMFriends.h
//  chatDemo1
//
//  Created by HeQichang on 15/8/6.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//


@interface QMFriends : NSObject

@property (nonatomic, strong) NSDictionary *friendDict;


+ (id)sharedFriend;

@end
