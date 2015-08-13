//
//  QMFriends.m
//  chatDemo1
//
//  Created by HeQichang on 15/8/6.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "QMFriends.h"

static NSString * const kUserDefaultsKey = @"QMFriends";

@interface QMFriends ()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end


@implementation QMFriends

@synthesize friendDict = _friendDict;

+ (id)sharedFriend {
    static QMFriends *friends;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        friends = [[QMFriends alloc] init];
    });
    return friends;
}

- (id)init {
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        
    }
    return self;
}

- (NSDictionary *)friendDict {
    if (_friendDict == nil) {
        _friendDict = [self.defaults dictionaryForKey:kUserDefaultsKey];
        if (!_friendDict) {
            _friendDict = [[NSDictionary alloc] init];
        }
    }
    return _friendDict;
}

- (void)setFriendDict:(NSDictionary *)friendDict {
   
    _friendDict = friendDict;
    [self.defaults setObject:friendDict forKey:kUserDefaultsKey];
    
}




@end
