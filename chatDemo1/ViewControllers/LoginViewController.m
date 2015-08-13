//
//  LoginViewController.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/14.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "LoginViewController.h"
#import "QMUser.h"
#import "QMAccount.h"
#import "QMFriends.h"
#import "ServerAPI.h"
#import "QMError.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)tapOuterTextField:(id)sender;
- (IBAction)registerButtonDidTouch:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewConstraint;
- (IBAction)usernameTextFieldEditingDidBegin:(id)sender;
- (IBAction)passwordTextFieldEditingDidBegin:(id)sender;
- (IBAction)loginButtonDidTouchUpInside:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 44;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (IBAction)tapOuterTextField:(id)sender {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if (self.headImageViewConstraint.constant != 50) {
        [self.view layoutIfNeeded];
        self.headImageViewConstraint.constant = 50.0f;
        __weak __typeof(self)weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            [weakSelf.view layoutIfNeeded];
        }];
    }
}

- (IBAction)registerButtonDidTouch:(id)sender {
    [self performSegueWithIdentifier:@"Register" sender:sender];
}

- (IBAction)usernameTextFieldEditingDidBegin:(id)sender {
    if (self.headImageViewConstraint.constant != 30) {
        [self.view layoutIfNeeded];
        self.headImageViewConstraint.constant = 30.0f;
        __weak __typeof(self)weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            [weakSelf.view layoutIfNeeded];
        }];
    }
}

- (IBAction)passwordTextFieldEditingDidBegin:(id)sender {
    if (self.headImageViewConstraint.constant != 30) {
        [self.view layoutIfNeeded];
        self.headImageViewConstraint.constant = 30.0f;
        __weak __typeof(self)weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            [weakSelf.view layoutIfNeeded];
        }];
    }
}

- (IBAction)loginButtonDidTouchUpInside:(id)sender {
    if (self.usernameTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        return;
    }
    
    __block MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    loadingHud.mode = MBProgressHUDModeText;
    loadingHud.labelText = @"正在登录...";
    
    @weakify(self);
    [[ServerAPI sharedAPI] loginWithPhoneNum:self.usernameTextField.text Password:self.passwordTextField.text withCompletion:^(NSDictionary *userInfo, QMError *error) {
        @strongify(self);
        loadingHud.labelText = @"登录成功，正在跳转...";
        
        if (!error) {
            // 保存登录的用户信息
            QMUser *loginedUser = [[QMUser alloc] init];
            loginedUser.uid = [userInfo[@"uid"] integerValue];
            loginedUser.phoneNum = userInfo[@"phone"];
            loginedUser.nickname = userInfo[@"nickname"];
            [[QMAccount sharedAccount] setLoginedUser:loginedUser];
            
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            [SSKeychain setPassword:self.passwordTextField.text forService:KKEYCHAIN_SERVICE_NAME account:self.usernameTextField.text];
            
            // 获取登录用户的好友关系列表
            [[ServerAPI sharedAPI] getFriendsWithUid:[@(loginedUser.uid) stringValue] withCompletion:^(NSDictionary *friends, QMError *error) {
                if (!error && friends) {
                    [[QMFriends sharedFriend] setFriendDict:friends];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [loadingHud hide:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                });
                
            }];
        } else {
            MBProgressHUD *errorHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            loadingHud.mode = MBProgressHUDModeText;
            loadingHud.labelText = error.desc;
            [errorHud hide:YES afterDelay:.6];
        }
    }];
}
@end
