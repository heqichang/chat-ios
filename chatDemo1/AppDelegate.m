//
//  AppDelegate.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/13.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+EaseMob.h"

#import "NSString+MD5.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [SMS_SDK registerApp:@"8d6fe54a1c8f" withSecret:@"84e8b96100e99becc0dce3cc2406df42"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
//    NSString *hash = [@"18677967721123456i" md5];
//    
//    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"1" password:hash completion:^(NSDictionary *loginInfo, EMError *error) {
//        if (!error && loginInfo) {
//            NSLog(@"登陆成功");
//        }
//    } onQueue:nil];
    
    [self loginStateChange:nil];
    
    [self.window makeKeyAndVisible];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - private
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess) {
        //登陆成功加载主窗口控制器
//        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainTabBarController"];
        self.window.rootViewController = vc;
    } else {
        //登陆失败加载登陆页面控制器
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        self.window.rootViewController = vc;
    }
}



@end
