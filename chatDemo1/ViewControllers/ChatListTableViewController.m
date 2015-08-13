//
//  ChatListTableViewController.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/29.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "ChatListTableViewController.h"
#import "UISearchBar+Extension.h"
#import "ChatCellTableViewCell.h"
#import "ChatListItemViewModel.h"
#import "ChatViewController.h"
#import "QMFriends.h"


@interface ChatListTableViewController()<UISearchControllerDelegate, UISearchResultsUpdating, IChatManagerDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;


@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ChatListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"ChatCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar setPlaceholder:@"搜索"];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.definesPresentationContext = YES;
    
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.frame.size.height)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshDataSource];
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 延迟加载
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ChatListItemViewModel *vm = (ChatListItemViewModel *)[self.dataSource objectAtIndex:indexPath.row];
    [cell bindViewModel:vm];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"chat"]) {
        ChatViewController *chatVC = [segue destinationViewController];
        ChatListItemViewModel *vm = [self.dataSource objectAtIndex:[sender integerValue]];
        chatVC.uid = vm.uid;
        chatVC.nickname = vm.username;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"chat" sender:@(indexPath.row)];
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController {
    // You have to set YES showsCancelButton.
    // If not, you can not change your button title when this method called
    // first time.
    self.searchController.searchBar.showsCancelButton = YES;
    
    UIView* view=self.searchController.searchBar.subviews[0];
    for (UIView *subView in view.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            // solution 1
            UIButton *cancelButton = (UIButton*)subView;
            
            [cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
            
        }
    }
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"1");
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


#pragma mark - IChatManagerDelegate

// 接收在线信息回调
- (void)didUnreadMessagesCountChanged {
    [self refreshDataSource];
}


- (void)willReceiveOfflineMessages{
    NSLog(@"11");
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
    NSLog(@"3");
}

#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

- (void)refreshDataSource
{
    [self.dataSource removeAllObjects];
    NSMutableArray *conversationSource = [self loadDataSource];
    for (EMConversation *conversation in conversationSource) {
        ChatListItemViewModel *viewModel = [[ChatListItemViewModel alloc] init];
        viewModel.uid = conversation.chatter;
        viewModel.username = [self nicknameByConversation:conversation];
        viewModel.latestMessage = [self subTitleMessageByConversation:conversation];
        viewModel.unreadCount = [self unreadMessageCountByConversation:conversation];
        viewModel.latestMessageDate = [self lastMessageTimeByConversation:conversation];
        
        [self.dataSource addObject:viewModel];
    }
    
    [self.tableView reloadData];
}

// 得到用户昵称
- (NSString *)nicknameByConversation:(EMConversation *)conversation {
    NSString *uid = conversation.chatter;

    NSString *validUid = @"\\d+";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validUid];
    if ([pred evaluateWithObject:uid]) {
        NSDictionary *existedFriendDict = [[QMFriends sharedFriend] friendDict];
        if ([[existedFriendDict allKeys] containsObject:uid]) {
            return [existedFriendDict objectForKey:uid];
        }
    }
    return uid;
}


// 得到最后消息文字或者类型
- (NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = @"[图片]";
            } break;
            case eMessageBodyType_Text:{
                ret = ((EMTextMessageBody *)messageBody).text;
            } break;
            case eMessageBodyType_Voice:{
                ret = @"[语音]";
            } break;
            case eMessageBodyType_Location: {
                ret = @"[地址]";
            } break;
            case eMessageBodyType_Video: {
                ret = @"[视频]";
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [self formatDate:[self dateWithTimeIntervalInMilliSecondSince1970:lastMessage.timestamp]];
    }
    
    return ret;
}

- (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond {
    NSDate *ret = nil;
    double timeInterval = timeIntervalInMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if(timeIntervalInMilliSecond > 140000000000) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return ret;
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString * dateNow = [formatter stringFromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[[dateNow substringWithRange:NSMakeRange(8,2)] intValue]];
    [components setMonth:[[dateNow substringWithRange:NSMakeRange(5,2)] intValue]];
    [components setYear:[[dateNow substringWithRange:NSMakeRange(0,4)] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *todayDate = [gregorian dateFromComponents:components]; //今天 0点时间
    
    NSTimeInterval ti = [date timeIntervalSinceDate:todayDate];
    NSInteger hour = (NSInteger) (ti / 3600);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *ret = @"";
    
        if (hour <= 24 && hour >= 0) {
            [dateFormatter setDateFormat:@"HH:mm"];
        }else if (hour < 0 && hour >= -24) {
            [dateFormatter setDateFormat:@"昨天"];
        }else {
            [dateFormatter setDateFormat:@"yy/MM/dd"];
        }
    
    
    ret = [dateFormatter stringFromDate:date];
    return ret;
}

@end
