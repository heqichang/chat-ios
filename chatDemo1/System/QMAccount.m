//
//  QMAccount.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/22.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "QMAccount.h"
#import "QMUser.h"

static NSString * const kUserDefaultsKey = @"QMAccount";

@interface QMAccount ()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation QMAccount

+ (id)sharedAccount {
    static QMAccount *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[QMAccount alloc] init];
    });
    return account;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)addQMUser:(QMUser *)user {
    [self removeQMUser:user];
    NSData *defalutData = [_defaults objectForKey:kUserDefaultsKey];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
    [appleys addObject:user];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
    [_defaults setObject:data forKey:kUserDefaultsKey];
}

- (void)removeQMUser:(QMUser *)user {
    NSData *defalutData = [_defaults objectForKey:kUserDefaultsKey];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
    QMUser *needDelete;
    for (QMUser *entity in appleys) {
        if (entity.uid == user.uid) {
            needDelete = entity;
            break;
        }
    }
    
    if (needDelete) {
        [appleys removeObject:needDelete];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
        [_defaults setObject:data forKey:kUserDefaultsKey];
    }
}

- (NSArray *)allAccounts {
    NSData *defalutData = [_defaults objectForKey:kUserDefaultsKey];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    return ary;
}

@end
