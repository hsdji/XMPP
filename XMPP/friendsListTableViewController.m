//
//  friendsListTableViewController.m
//  XMPP
//
//  Created by user on 17/8/25.
//  Copyright © 2017年 user. All rights reserved.
//



#define kAppdelegate  ((AppDelegate *)([UIApplication sharedApplication].delegate))

#import "friendsListTableViewController.h"
#import "ListTableViewCell.h"
#import "XMPPRosterCoreDataStorage.h"
@interface friendsListTableViewController ()
{
    NSMutableArray *alldataArr;
    NSString *str;
}

@property (nonatomic,strong)XMPPRoster *xmppRoster;

@end

@implementation friendsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的好友";
    self.tableView.tableFooterView = [UIView new];
//    [[xmppManage sharedManage] loginWithUserName:@"app1" password:@"1" loginSuccess:^{
//        
//         [[xmppManage sharedManage] addFriendsWithFriendsName:@"dn1"];
//         [[xmppManage sharedManage] addFriendsWithFriendsName:@"dn2"];
//         [[xmppManage sharedManage] addFriendsWithFriendsName:@"dn3"];
//        
        [[xmppManage sharedManage] getFirends:^(NSArray *block) {
            [alldataArr removeAllObjects];
            [alldataArr addObjectsFromArray:block];
            [self.tableView reloadData];
        }];
//        
//    } loginFailed:^(NSString *error) {
//        
//        
//    }];
    
    
    
    [[xmppManage sharedManage] getMessages:^(NSDictionary *dic) {
        str = [dic valueForKey:@"name"];
        [self.tableView reloadData];
    }];
    
    alldataArr = [NSMutableArray new];
    [self.tableView registerClass:[ListTableViewCell class] forCellReuseIdentifier:@"cell"];
}


-(void)viewDidAppear:(BOOL)animated{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[userLongInViewController new]] animated:YES completion:nil];
    });
}


#pragma -mark tableView delegate&datasouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return alldataArr.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *a = [alldataArr[indexPath.row] valueForKey:@"name"];
    cell.nameLab.text = [a isEqualToString:str]?[a stringByAppendingString:@"                           您有未读消息"]:a;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *a = [alldataArr[indexPath.row] valueForKey:@"name"];
    if ([a isEqualToString:str]) {
        str = nil;
        [self.tableView reloadData];
    }
    ViewController *v = [ViewController new];
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", a, @"127.0.0.1"]];
    v.jid = jid;
    [self.navigationController pushViewController:v animated:YES];
}

@end
