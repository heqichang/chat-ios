//
//  QMUser.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/20.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "QMUser.h"

@interface QMUser ()<NSCoding>

@end


@implementation QMUser

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:@(_uid) forKey:@"uid"];
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_phoneNum forKey:@"phonenum"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        _uid = [[aDecoder decodeObjectForKey:@"uid"] integerValue];
        _username = [aDecoder decodeObjectForKey:@"username"];
        _phoneNum = [aDecoder decodeObjectForKey:@"phonenum"];
        _nickname = [aDecoder decodeObjectForKey:@"nickname"];
    }
    
    return self;
}

@end
