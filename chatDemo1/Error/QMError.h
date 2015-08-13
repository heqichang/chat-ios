//
//  QMError.h
//  chatDemo1
//
//  Created by HeQichang on 15/7/15.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorDefs.h"

@interface QMError : NSObject


/*!
 @property
 @brief 错误代码
 */
@property (nonatomic) QMErrorType errorCode;

/*!
 @property
 @brief 错误信息描述
 */
@property (nonatomic, strong) NSString *desc;

/*!
 @method
 @brief 创建一个QMError实例对象
 @param errCode 错误代码
 @param description 错误描述信息
 @discussion
 @result 错误信息描述实例对象
 */
+ (QMError *)errorWithCode:(QMErrorType)errCode
            andDescription:(NSString *)description;


@end
