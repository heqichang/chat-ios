//
//  ContactsTableViewController.m
//  chatDemo1
//
//  Created by HeQichang on 15/8/4.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ChatViewController.h"
#import "QMFriends.h"

@interface ContactsTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *friendDict = [[QMFriends sharedFriend] friendDict];
    
    NSArray *allKeys = [friendDict allKeys];
    for (id key in allKeys) {
        //NSInteger uid = [key integerValue];
        
        [self.dataSource addObject:@[key, friendDict[key]]];
    }
    
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead"];
    NSArray *data = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = data[1];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"chat" sender:@(indexPath.row)];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"chat"]) {
        NSInteger row = [sender integerValue];
        NSArray *data = [self.dataSource objectAtIndex:row];
       
        ChatViewController *cVc = [segue destinationViewController];
        cVc.uid = data[0];
        cVc.nickname = data[1];
        
    }
}

#pragma mark - private

//- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
//{
//    //建立索引的核心
//    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
//    
//    [self.sectionTitles removeAllObjects];
//    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
//    
//    //返回27，是a－z和＃
//    NSInteger highSection = [self.sectionTitles count];
//    //tableView 会被分成27个section
//    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
//    for (int i = 0; i <= highSection; i++) {
//        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
//        [sortedArray addObject:sectionArray];
//    }
//    
//    //名字分section
//    for (EMBuddy *buddy in dataArray) {
//        
//        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
//        
//        NSMutableArray *array = [sortedArray objectAtIndex:section];
//        [array addObject:buddy];
//    }
//    
//    //每个section内的数组排序
//    for (int i = 0; i < [sortedArray count]; i++) {
//        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EMBuddy *obj1, EMBuddy *obj2) {
//            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.username];
//            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
//            
//            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.username];
//            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
//            
//            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
//        }];
//        
//        
//        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
//    }
//    
//    return sortedArray;
//}

@end
