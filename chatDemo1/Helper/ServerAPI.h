//
//  ServerAPI.h
//  chatDemo1
//
//  Created by HeQichang on 15/7/14.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QMError;


@interface ServerAPI : NSObject


+ (id)sharedAPI;

- (void)getFriendsWithUid:(NSString *)uid
           withCompletion:(void (^)(NSDictionary *friends, QMError *error))completion;


- (void)loginWithPhoneNum:(NSString *)phoneNum
                 Password:(NSString *)password
           withCompletion:(void (^)(NSDictionary *userInfo, QMError *error))completion;

/*!
 @method
 @brief 注册用户
 @param username 用户名
 @param password 用户密码
 @param completion 完成后的回调
 @discussion
 成功回调后 error == nil
 */
- (void)registerNewAccount:(NSString *)phone
                  Password:(NSString *)password
                  Nickname:(NSString *)nickname
            withCompletion:(void (^)(NSDictionary *jsonDict,
                                     QMError *error))completion;

- (void)checkExistPhoneNum:(NSString *)phone
            withCompletion:(void (^)(NSDictionary *jsonDict,
                                     QMError *error))completion;

- (void)getVerificationCodeBySMSWithPhone:(NSString *)phone
                           withCompletion:(void (^)(QMError * error))completion;


@end
