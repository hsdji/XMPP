//
//  userLongInViewController.m
//  XMPP
//
//  Created by user on 17/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "userLongInViewController.h"

@interface userLongInViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UIButton *longinBtn;
@end

@implementation userLongInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.longinBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[xmppManage sharedManage] loginWithUserName:self.userName.text password:self.password.text loginSuccess:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } loginFailed:^(NSString *error) {
            NSLog(@"登录失败");
        }];
    }];
    
    [[self.registBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.navigationController pushViewController:[userRegistViewController new] animated:YES];
    }];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
