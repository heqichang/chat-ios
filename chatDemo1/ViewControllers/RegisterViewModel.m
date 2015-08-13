//
//  RegisterViewModel.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/15.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "RegisterViewModel.h"
#import "ServerAPI.h"

@interface RegisterViewModel ()

@property (nonatomic, strong) RACSignal *phoneValidSignal;



@end

@implementation RegisterViewModel

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}



- (RACCommand *)nextStepEnabledCommand {
    if (!_nextStepEnabledCommand) {
        @weakify(self);
        _nextStepEnabledCommand = [[RACCommand alloc] initWithEnabled:self.phoneValidSignal signalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [[ServerAPI sharedAPI] getVerificationCodeBySMSWithPhone:self.phoneString withCompletion:^(QMError *error) {
                    if (error) {
                        [subscriber sendNext:error];
                    } else {
                        [subscriber sendNext:nil];
                    }
                    
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _nextStepEnabledCommand;
}

- (RACSignal *)phoneValidSignal {

    if (!_phoneValidSignal) {
        _phoneValidSignal = [RACObserve(self, phoneString) map:^id(NSString *value) {
            NSString *validPhoneNumberRegex = @"1[3|5|7|8][0-9]{9}";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validPhoneNumberRegex];
            return @([pred evaluateWithObject:value]);
        }];
    }
    
    return _phoneValidSignal;
}

@end
