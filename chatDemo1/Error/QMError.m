//
//  QMError.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/15.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "QMError.h"

@implementation QMError

+ (QMError *)errorWithCode:(QMErrorType)errCode
                andDescription:(NSString *)desc {
    QMError *error = [[self alloc] init];
    error.errorCode = errCode;
    error.desc = desc;
    
    return error;
}


@end
