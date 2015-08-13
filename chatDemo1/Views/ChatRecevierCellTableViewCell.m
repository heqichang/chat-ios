//
//  ChatRecevierCellTableViewCell.m
//  chatDemo1
//
//  Created by HeQichang on 15/8/8.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "ChatRecevierCellTableViewCell.h"

@interface ChatRecevierCellTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleViewHeight;


@end

@implementation ChatRecevierCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTextMessage:(NSString *)textMessage {
    _textMessage = textMessage;
    CGSize textBlockMinSize = {164, CGFLOAT_MAX};
    CGSize size = [_textMessage boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:@{
                                           NSFontAttributeName:[UIFont systemFontOfSize:14]
                                           }
                                 context:nil].size;
    
    self.bubbleViewWidth.constant = size.width + 36;
    self.bubbleViewHeight.constant = size.height + 30;
    self.messageLabel.text = textMessage;
    
}

@end
