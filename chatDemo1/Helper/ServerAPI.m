//
//  ServerAPI.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/14.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "ServerAPI.h"
#import "QMError.h"
#import "NSString+MD5.h"

static NSString * const kRegisterUrl = @"http://1.heqichang1.sinaapp.com/reg.php";
static NSString * const kLoginUrl = @"http://1.heqichang1.sinaapp.com/login.php";
static NSString * const kGetFriends = @"http://1.heqichang1.sinaapp.com/getbuddies.php";
static NSString * const kCheckExistPhoneUrl = @"http://1.heqichang1.sinaapp.com/existphone.php";

@implementation ServerAPI

+ (id)sharedAPI {
    static ServerAPI *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[ServerAPI alloc] init];
    });
    return api;
}

- (void)getFriendsWithUid:(NSString *)uid
           withCompletion:(void (^)(NSDictionary *friends, QMError *error))completion {
    NSDictionary *bodyDict = @{@"uid": uid};
    [self postURL:kGetFriends Parameter:bodyDict withCompletion:^(NSDictionary *jsonDict, QMError *error) {
        if (error) {
            completion(nil, error);
        } else {
            if ([jsonDict[@"state"] isEqualToString:@"success"]) {
                
                NSArray *data = jsonDict[@"data"];
                NSMutableDictionary *tempFriendsDict = [[NSMutableDictionary alloc] init];
                for (NSDictionary *userDict in data) {
                    [tempFriendsDict setObject:userDict[@"nickname"] forKey:userDict[@"uid"]];
                }
                
                completion([tempFriendsDict copy], nil);
            } else {
                completion(nil, [QMError errorWithCode:QMErrorNoFriends andDescription:@"还没有好友"]);
            }
        }
    }];
}

- (void)loginWithPhoneNum:(NSString *)phoneNum
                 Password:(NSString *)password
           withCompletion:(void (^)(NSDictionary *userInfo, QMError *error))completion {
    
    NSDictionary *bodyDict = @{@"phone": phoneNum, @"pwd": password};
    [self postURL:kLoginUrl Parameter:bodyDict withCompletion:^(NSDictionary *jsonDict, QMError *error) {
        if (error) {
            completion(nil, error);
        } else {
            if ([jsonDict[@"state"] isEqualToString:@"success"]) {
                NSString *uid = [jsonDict[@"uid"] stringValue];
                NSString *nickname = jsonDict[@"nickname"];
                NSString *hashPwd = [[NSString stringWithFormat:@"%@%@", phoneNum, password] md5];
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid password:hashPwd completion:^(NSDictionary *loginInfo, EMError *error) {
                    if (!error && loginInfo) {
                        NSDictionary *dict = @{
                                               @"uid" : uid,
                                               @"phone" : phoneNum,
                                               @"nickname" : nickname
                                               };
                        completion(dict, nil);
                    } else {
                        completion(nil, [QMError errorWithCode:QMErrorLoginError andDescription:error.description]);
                    }
                } onQueue:nil];
            } else {
                completion(nil, [QMError errorWithCode:QMErrorLoginError andDescription:@"用户名或密码错误"]);
            }
        }
    }];
}

- (void)getVerificationCodeBySMSWithPhone:(NSString *)phone
                           withCompletion:(void (^)(QMError * error))completion {
    [self checkExistPhoneNum:phone withCompletion:^(NSDictionary *jsonDict, QMError *error) {
        if (error) {
            completion(error);
        } else {
            if ([jsonDict[@"state"] isEqualToString:@"success"] && [jsonDict[@"exist"] integerValue] == 0) {
                [SMS_SDK getVerificationCodeBySMSWithPhone:phone zone:@"86" result:^(SMS_SDKError *error) {
                    if (error) {
                        QMError *qmError = [QMError errorWithCode:QMErrorSendSMS andDescription:error.errorDescription];
                        completion(qmError);
                    } else {
                        completion(nil);
                    }
                }];
            } else {
                //TODO: 错误类型
                QMError *qmError = [QMError errorWithCode:QMErrorExistPhoneNum andDescription:@"手机号已存在"];
                completion(qmError);
            }
        }
    }];
}

- (void)checkExistPhoneNum:(NSString *)phone
            withCompletion:(void (^)(NSDictionary *jsonDict,
                                     QMError *error))completion {
    NSDictionary *bodyDict = @{@"phone": phone};
    [self postURL:kCheckExistPhoneUrl Parameter:bodyDict withCompletion:completion];
}

- (void)registerNewAccount:(NSString *)phone
                  Password:(NSString *)password
                  Nickname:(NSString *)nickname
            withCompletion:(void (^)(NSDictionary *jsonDict,
                                     QMError *error))completion {
    
    NSMutableDictionary *bodyDict = [@{
                               @"phone": phone,
                               @"pwd": password
                               } mutableCopy];
    
    if (nickname != nil && ![[nickname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [bodyDict setObject:nickname forKey:@"nickname"];
    }
    
    [self postURL:kRegisterUrl Parameter:bodyDict withCompletion:completion];
}

#pragma mark -- private
- (void)postURL:(NSString *)url
      Parameter:(NSDictionary *)paraDict
 withCompletion:(void (^)(NSDictionary *jsonDict,
                          QMError *error))completion {
    
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paraDict options:NSJSONWritingPrettyPrinted error:&jsonError];
    [request setHTTPBody:jsonData];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                NSError *jsonError2;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError2];
                if (!jsonError2) {
                    completion(jsonDict, nil);
                } else {
                    
                    QMError *qmError = [QMError errorWithCode:QMErrorParse andDescription:jsonError2.localizedDescription];
                    completion(nil, qmError);
                }
            } else {
                QMError *qmError = [QMError errorWithCode:QMErrorNetwork andDescription:[NSString stringWithFormat:@"请求网络返回出错-返回码：%ld", (long)httpResponse.statusCode]];
                completion(nil, qmError);
            }
            
        } else {
            QMError *qmError = [QMError errorWithCode:QMErrorNetwork andDescription:error.localizedDescription];
            completion(nil, qmError);
        }
    }];
    [dataTask resume];
    
}



@end
