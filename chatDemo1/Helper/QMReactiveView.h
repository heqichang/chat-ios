//
//  QMReactiveView.h
//  chatDemo1
//
//  Created by HeQichang on 15/7/29.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QMReactiveView <NSObject>

// Binds the given view model to the view.
//
// viewModel - The view model
- (void)bindViewModel:(id)viewModel;

@end
