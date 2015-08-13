//
//  RegisterViewModel.h
//  chatDemo1
//
//  Created by HeQichang on 15/7/15.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;

@interface RegisterViewModel : NSObject

@property (nonatomic, strong) NSString *phoneString;
@property (nonatomic, strong) RACCommand *nextStepEnabledCommand;

@end
