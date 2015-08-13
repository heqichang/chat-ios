//
//  ChatViewController.m
//  chatDemo1
//
//  Created by HeQichang on 15/8/7.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatRecevierCellTableViewCell.h"
#import "ChatSenderCellTableViewCell.h"


@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, IChatManagerDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, strong) NSString *senderId;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;




@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ChatRecevierCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"recevier"];
    [_tableView registerNib:[UINib nibWithNibName:@"ChatSenderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"sender"];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    self.textView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    self.textView.layer.borderWidth = .65f;
    self.textView.layer.cornerRadius = 6.0f;
    
    
    if (self.nickname) {
        [self.navigationItem setTitle:self.nickname];
    }
    
    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    self.senderId = [userInfo objectForKey:@"username"];
    
    self.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.uid conversationType:eConversationTypeChat];
    [self.conversation markAllMessagesAsRead:YES];
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self.view addSubview:self.tableView];
    
    //通过会话管理者获取已收发消息
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    
    self.dataSource = [[self.conversation loadNumbersOfMessages:20 before:timestamp] mutableCopy];
    
//    [self scrollViewToBottom:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollViewToBottom:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


#pragma mark - getter
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat Height = endFrame.size.height;
    self.bottomViewBottomConstraint.constant = -Height;
    [self.bottomView needsUpdateConstraints];
    @weakify(self);
    [UIView animateWithDuration:duration animations:^{
        @strongify(self);
        [self.bottomView layoutIfNeeded];
    }];
    
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    CGFloat orgHeight = textView.frame.size.height;
    CGFloat height = [textView sizeThatFits:textView.frame.size].height;
    
    if (height > orgHeight && orgHeight < 80) {
        self.bottomViewHeight.constant += height - orgHeight;
    } else if (height < orgHeight) {
        self.bottomViewHeight.constant -= orgHeight - height;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        
        if (textView.text.length > 0) {
            EMChatText *txtChat = [[EMChatText alloc] initWithText:textView.text];
            EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
            
            // 生成message
            EMMessage *message = [[EMMessage alloc] initWithReceiver:self.uid bodies:@[body]];
            message.messageType = eMessageTypeChat; // 设置为单聊消息
            
            // 环信发送信息
            [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
            
            [self.dataSource addObject:message];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
        textView.text = @"";
        return NO;
    }
    return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    EMMessage *message = [self.dataSource objectAtIndex:indexPath.row];
    
    BOOL isSender = [message.from isEqualToString:self.senderId];
    
    id<IEMMessageBody> messageBody = message.messageBodies.firstObject;
    
    if (isSender) {
        ChatSenderCellTableViewCell *senderCell = [tableView dequeueReusableCellWithIdentifier:@"sender" forIndexPath:indexPath];
        
        senderCell.textMessage = ((EMTextMessageBody *)messageBody).text;
        
        senderCell.backgroundColor = [UIColor clearColor];
        senderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return senderCell;
        
    } else {
        ChatRecevierCellTableViewCell *recevierCell = [tableView dequeueReusableCellWithIdentifier:@"recevier" forIndexPath:indexPath];
        recevierCell.textMessage = ((EMTextMessageBody *)messageBody).text;
        
        recevierCell.backgroundColor = [UIColor clearColor];
        recevierCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return recevierCell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    EMMessage *message = [self.dataSource objectAtIndex:indexPath.row];
    
    id<IEMMessageBody> messageBody = message.messageBodies.firstObject;
    
    NSString *messageText = ((EMTextMessageBody *)messageBody).text;

    CGSize textBlockMinSize = {164, CGFLOAT_MAX};
    CGSize size = [messageText boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{
                                                       NSFontAttributeName:[UIFont systemFontOfSize:14]
                                                       }
                                             context:nil].size;
    
    
    return size.height + 30 > 65 ? size.height + 30 : 65;
}

#pragma mark - IChatManagerDelegate
-(void)didReceiveMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [_conversation markMessageWithId:message.messageId asRead:YES];
        [self.dataSource addObject:message];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - private
- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}



@end
