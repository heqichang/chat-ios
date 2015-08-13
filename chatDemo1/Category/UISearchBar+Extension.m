//
//  UISearchBar+Extension.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/29.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "UISearchBar+Extension.h"

@implementation UISearchBar (Extension)

- (void)setCancelButtonTitle:(NSString *)title {
//    for(UIView *view in [self subviews]) {
//        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
//            [(UIBarItem *)view setTitle:title];
//        }
//    }
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)subView;
            
            [cancelButton setTitle:@"hi" forState:UIControlStateNormal];
        }
    }
    
//    for (UIView *searchbuttons in self.subviews)
//    {
//        if ([searchbuttons isKindOfClass:[UIButton class]])
//        {
//            UIButton *cancelButton = (UIButton*)searchbuttons;
//            [cancelButton setTitle:title forState:UIControlStateNormal];
//            break;
//        }
//    }
}

@end
