//
//  userRegistViewController.m
//  XMPP
//
//  Created by user on 17/8/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import "userRegistViewController.h"

@interface userRegistViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@end

@implementation userRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    xmppManage *manage = [xmppManage sharedManage];
    [[self.registBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
       [manage registerWithUserName:self.userName.text password:self.passWord.text registerSuccess:^{
           [[xmppManage sharedManage] loginWithUserName:self.userName.text password:self.passWord.text loginSuccess:^{
                     [self dismissViewControllerAnimated:YES completion:nil];
           } loginFailed:^(NSString *error) {
               
           }];
       } registerFailed:^(NSString *error) {
           
       }];
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
