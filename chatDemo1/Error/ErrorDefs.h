//
//  ErrorDefs.h
//  chatDemo1
//
//  Created by HeQichang on 15/7/15.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#ifndef chatDemo1_ErrorDefs_h
#define chatDemo1_ErrorDefs_h


typedef NS_ENUM(NSInteger, QMErrorType) {
    // network
    QMErrorNetwork = 401, // 网络连接出错
    
    // parse
    QMErrorParse = 501, // 数据转换出错，比如nsdata->json
    
    
    
    // 用户 901-1000
    QMErrorInvalidUsername = 901, // 用户名出错
    QMErrorInvalidPassword, // 密码出错
    QMErrorExistPhoneNum, // 注册手机号已存在
    QMErrorSendSMS, // 环信短信验证码获取失败
    QMErrorLoginError, // 登录失败
    QMErrorNoFriends // 还没有其它朋友
};

#endif
