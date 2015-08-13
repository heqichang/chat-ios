//
//  RegisterInfoViewController.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/20.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "RegisterInfoViewController.h"
#import "QMUser.h"
#import "QMFriends.h"
#import "ServerAPI.h"
#import "QMAccount.h"
#import "chatDemoDef.h"


@interface RegisterInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACSignal *validNickNameSignal = [self.nicknameTextField.rac_textSignal map:^id(NSString *nickName) {
        return @(nickName.length > 0);
    }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *password) {
        if (password.length < 6 || password.length > 16) {
            return @(NO);
        }
        
        NSString *patternStr = @"^\\d+$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", patternStr];
        if ([pred evaluateWithObject:password] && password.length < 9) {
            return @(NO);
        }
        
        return @(YES);
    }];
    
    RACSignal *registerButtonEnabledSignal = [RACSignal combineLatest:@[validNickNameSignal, validPasswordSignal] reduce:^id(NSNumber *nicknameValid, NSNumber *passwordValid){
        return @([nicknameValid boolValue] && [passwordValid boolValue]);
    }];
    
    @weakify(self);
    self.registerButton.rac_command = [[RACCommand alloc] initWithEnabled:registerButtonEnabledSignal signalBlock:^RACSignal *(id input) {
        @strongify(self);
        MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        return [RACSignal defer:^RACSignal *{
            
            [[ServerAPI sharedAPI] registerNewAccount:self.user.phoneNum Password:self.passwordTextField.text Nickname:self.nicknameTextField.text withCompletion:^(NSDictionary *jsonDict, QMError *error) {
                
                [loadingHud hide:YES];
                if (error == nil && [jsonDict[@"state"] isEqualToString:@"success"]) {
//                    self.user.phoneNum = self.passwordTextField.text;
                    self.user.nickname = self.nicknameTextField.text;
                    
                    [[QMAccount sharedAccount] setLoginedUser:self.user];
                    [[QMAccount sharedAccount] addQMUser:self.user];
                    // 保存登录的账号密码
                    [SSKeychain setPassword:self.passwordTextField.text forService:KKEYCHAIN_SERVICE_NAME account:self.user.phoneNum];
                    MBProgressHUD *messageHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    messageHud.mode = MBProgressHUDModeText;
                    messageHud.labelText = @"正在登录中...";
                    [[ServerAPI sharedAPI] loginWithPhoneNum:self.user.phoneNum Password:self.passwordTextField.text withCompletion:^(NSDictionary *userInfo, QMError *error) {
                        if (!error) {
                            messageHud.labelText = @"登录成功，跳转中...";
                            
                            // 保存登录的用户信息
                            QMUser *loginedUser = [[QMUser alloc] init];
                            loginedUser.uid = [userInfo[@"uid"] integerValue];
                            loginedUser.phoneNum = userInfo[@"phone"];
                            loginedUser.nickname = userInfo[@"nickname"];
                            [[QMAccount sharedAccount] setLoginedUser:loginedUser];
                            
                            // 设置自动登录
                            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                            
                            // 获取登录用户的好友关系列表
                            [[ServerAPI sharedAPI] getFriendsWithUid:[@(loginedUser.uid) stringValue] withCompletion:^(NSDictionary *friends, QMError *error) {
                                if (!error && friends) {
                                    [[QMFriends sharedFriend] setFriendDict:friends];
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [messageHud hide:YES];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                                });
                                
                                
                            }];
                        } else {
                            messageHud.labelText = @"登录失败!";
                            [messageHud hide:YES afterDelay:.6];
                        }
                    }];
                    
                    
                } else {
                    // error
                }
            }];

            NSLog(@"success");
            return [RACSignal empty];
        }];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.nicknameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
