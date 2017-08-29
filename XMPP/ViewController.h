//
//  ViewController.h
//  XMPP
//
//  Created by user on 17/8/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSFetchedResultsControllerDelegate>


@property (nonatomic,strong)UITableView *tableView;

@property (nonnull,strong)XMPPJID *jid;
@end

