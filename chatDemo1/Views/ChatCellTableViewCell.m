//
//  ChatCellTableViewCell.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/29.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "ChatCellTableViewCell.h"
#import "QMDesignableUILabel.h"
#import "QMReactiveView.h"
#import "ChatListItemViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ChatCellTableViewCell ()

@property (nonatomic, strong) ChatListItemViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet QMDesignableUILabel *unreadCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation ChatCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(ChatListItemViewModel *)viewModel {
    self.viewModel = viewModel;
    self.usernameLabel.text = self.viewModel.username;
    
    self.unreadCountLabel.hidden = viewModel.unreadCount == 0;
    self.unreadCountLabel.text = viewModel.unreadCount > 99 ? @"99+" : [@(viewModel.unreadCount) stringValue];
    self.messageLabel.text = viewModel.latestMessage;
    
//    RAC(self.unreadCountLabel, hidden) = [RACObserve(self.viewModel, unreadCount) map:^id(id value) {
//        NSInteger unreadCount = [value integerValue];
//        return @(unreadCount == 0);
//    }];
    
//    RAC(self.unreadCountLabel, text) = [RACObserve(self.viewModel, unreadCount) map:^id(id value) {
//        NSInteger unreadCount = [value integerValue];
//        if (unreadCount > 99) {
//            return @"99+";
//        } else {
//            return [value stringValue];
//        }
//    }];
}

@end
