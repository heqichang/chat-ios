//
//  QMAccount.h
//  chatDemo1
//
//  Created by HeQichang on 15/7/22.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

@class QMUser;

@interface QMAccount : NSObject

+ (id)sharedAccount;
- (void)addQMUser:(QMUser *)user;
- (void)removeQMUser:(QMUser *)user;
- (NSArray *)allAccounts;

@property (nonatomic, strong) QMUser *loginedUser;

@end
