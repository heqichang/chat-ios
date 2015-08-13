//
//  RegisterVerifyViewController.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/16.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "RegisterVerifyViewController.h"
#import "RegisterInfoViewController.h"
#import "QMDesignableUIButton.h"
#import "QMUser.h"


@interface RegisterVerifyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet QMDesignableUIButton *resendButton;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;

@property (nonatomic, assign) int countDown;

@end

@implementation RegisterVerifyViewController

- (void)viewDidLoad {
    self.countDown = 60;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:self.phoneInfoLabel.text, @"86", self.user.phoneNum]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:(id)[UIColor colorWithRed:1.0f green:143.0/255.0 blue:47.0/255.0 alpha:1] range:NSMakeRange(10, 15)];
    self.phoneInfoLabel.attributedText = attributedString;
    
    @weakify(self);
    RACSignal *intervalSignal = [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] startWith:[NSDate date]];
    intervalSignal = [intervalSignal take:60];
    intervalSignal = [intervalSignal map:^id(id value) {
        @strongify(self);
        return @(self.countDown--);
    }];
    
    [intervalSignal subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.resendButton setTitle:[NSString stringWithFormat:@"重新发送(%d)", self.countDown] forState:UIControlStateDisabled];
            
        });
    } completed:^{
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resendButton.enabled = YES;
            [self.resendButton setTitle:@"重新发送" forState:UIControlStateNormal];
            
        });
    }];
    
    RACSignal *verifyCodeSignal = [self.verifyCodeTextField.rac_textSignal map:^id(NSString *verifyCode) {
        NSString *verifyCodeRegex = @"\\d{4}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verifyCodeRegex];
        return @([pred evaluateWithObject:verifyCode]);
    }];
    
    self.nextStepButton.rac_command = [[RACCommand alloc] initWithEnabled:verifyCodeSignal signalBlock:^RACSignal *(id input) {
        return [RACSignal defer:^RACSignal *{
            @strongify(self);
            MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            [SMS_SDK commitVerifyCode:self.verifyCodeTextField.text result:^(enum SMS_ResponseState state) {
                [loadingHud hide:YES];
                if (1 == state)
                {
                    NSLog(@"成功");
                    [self performSegueWithIdentifier:@"Info" sender:nil];
                    
                }
                else if(0 == state)
                {
                    NSLog(@"验证失败");
                    NSString* str= @"验证失败";
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"错误"
                                                                  message:str
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                        otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
            return [RACSignal empty];
        }];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.verifyCodeTextField becomeFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Info"]) {
        RegisterInfoViewController *vc = (RegisterInfoViewController *)[segue destinationViewController];
        vc.user = self.user;
    }
}


@end
