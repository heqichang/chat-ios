
//
//  RegisterViewController.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/15.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterViewModel.h"
#import "QMError.h"

#import "RegisterVerifyViewController.h"
#import "QMUser.h"

@interface RegisterViewController ()

@property (nonatomic, strong) QMUser *user;
@property (nonatomic, strong) RegisterViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITextField *cellphoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [[QMUser alloc] init];
    self.viewModel = [[RegisterViewModel alloc] init];
    
    RAC(self.viewModel, phoneString) = self.cellphoneTextField.rac_textSignal;
    self.nextStepButton.rac_command = self.viewModel.nextStepEnabledCommand;
    
    @weakify(self);
    __block MBProgressHUD *loadingHud = nil;
    [self.nextStepButton.rac_command.executing subscribeNext:^(id x) {
        BOOL isExecuting = [x boolValue];
        if (isExecuting) {
            loadingHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        }
    }];
    
    
    [[self.nextStepButton.rac_command.executionSignals.flatten deliverOnMainThread] subscribeNext:^(QMError *error) {
        @strongify(self);
        if (error) {
            loadingHud.mode = MBProgressHUDModeText;
            loadingHud.labelText = error.desc;
            [loadingHud hide:YES afterDelay:.6];
        } else {
            [loadingHud hide:YES];
            [self performSegueWithIdentifier:@"Verify" sender:nil];
        }
    }];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.cellphoneTextField becomeFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Verify"]) {
        RegisterVerifyViewController *vc = (RegisterVerifyViewController *)[segue destinationViewController];
        self.user.phoneNum = self.cellphoneTextField.text;
        vc.user = self.user;
    }
}

@end
