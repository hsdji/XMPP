//
//  xmppManage.m
//  XMPP
//
//  Created by user on 17/8/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import "xmppManage.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@interface xmppManage(){
    
    NSString *_userName;   //用户名
    NSString *_password;   //密码
    NSMutableArray *_onLineArr;
    __block NSMutableArray *arr;//上线好友
    __block NSMutableArray *allFriends;
}
@end

@implementation xmppManage
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}



//创建一个单例模式来管理xmpp的连接和操作
+(xmppManage *)sharedManage{
    
    static xmppManage *manager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[xmppManage alloc]init];
       manager->allFriends = [NSMutableArray new];
        manager->_onLineArr = [NSMutableArray new];
        manager->arr = [NSMutableArray new];
        [manager setupStream];
    });
    
    return manager;
}







#pragma mark ----- 登录注册部分 -------

-(void)loginWithUserName:(NSString *)userName password:(NSString *)password loginSuccess:(OperationSuccessBlock)loginSuceess loginFailed:(OperationfailedBlock)loginFailed{
    
    [self initWithUserName:userName password:password loginSuccess:loginSuceess loginFailed:loginFailed];
}

-(void)registerWithUserName:(NSString *)userName password:(NSString *)password registerSuccess:(OperationSuccessBlock)registerSuccess registerFailed:(OperationfailedBlock)registerFailed{
    
    self.isRegisterUser =YES;
    [self initWithUserName:userName password:password loginSuccess:registerSuccess loginFailed:registerFailed];
}

-(void)initWithUserName:(NSString *)userName password:(NSString *)password loginSuccess:(OperationSuccessBlock)suceess loginFailed:(OperationfailedBlock)failed{
    
    self.successBlock = suceess;
    self.failedBlock = failed;
    _userName = userName;
    _password = password;
    
    [self currentStateIsConnected];
    [self connect];
}

#pragma mark  ------- 建立连接相关代理 -----

//登录操作，也就是连接xmpp服务器,该方法会首先被调用。
-(void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"%@ %@",sender,socket);
}

//连接成功时调用，然后开始授权密码验证
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    if (self.isRegisterUser) {
        //用户注册，发送注册请求
        [self.xmppStream registerWithPassword:_password error:nil];
        NSLog(@"注册");
        
    } else {
        //用户登录，发送身份验证请求
        [self.xmppStream authenticateWithPassword:_password error:nil];
    }
}

//断开连接时调用.此方法在stream连接断开的时候调用，注意这些代理方法都是异步的.
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"断开连接! %@",sender);
}

#pragma mark --------  授权部分 ----------
//授权成功,开始发送信息
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    __weak xmppManage *weakSelf =self;
    dispatch_main_sync_safe(^{
        if (weakSelf.successBlock) {
            weakSelf.successBlock();
        }
    });
    //通知服务器用户上线
    [self goOnline];
}

//授权失败,该方法会被调用
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    
    __weak xmppManage *weakSelf =self;
    //根据是否是主线程再决定是否使用GCD。
    dispatch_main_sync_safe(^{
        if (self.failedBlock) {
            weakSelf.failedBlock(error.description);
        }
    });
}

#pragma mark ------- 注册相关代理 ----------
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    self.isRegisterUser =NO;
    
    __weak xmppManage *weakSelf =self;
    dispatch_main_sync_safe(^{
        if (weakSelf.successBlock) {
            weakSelf.successBlock();
        }
    });
}

-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    
    __weak xmppManage *weakSelf =self;
    dispatch_main_sync_safe(^{
        if (self.failedBlock) {
            weakSelf.failedBlock(error.description);
        }
    });
}

//链接服务端
-(void)connect{
    
    // 如果XMPPStream当前已经连接，直接返回
    if ([self.xmppStream isConnected]) {
        return;
    }
    
    // 设置XMPPStream的JID和主机.完整的Jid包括 Username@Domain/resource. Username：用户名，Domain登陆的XMPP服务器域名。Resource：资源/来源，用于区别客户端来源，xmpp协议设计为可多客户端同时登陆，resource就是用于区分同一用户不同端登陆。
    XMPPJID *myJID = [XMPPJID jidWithString:[self getBareJidStr:_userName]];
    [_xmppStream setMyJID: myJID];
    [_xmppStream setHostName:kxmppServer];
    [_xmppStream setHostPort:5222];
    
    // 开始连接提示：如果没有指定JID和hostName，才会出错，其他都不出错。
    NSError *error = nil;
    NSLog(@"%d", [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]);
    if (error) {
        NSLog(@"连接请求发送出错 %@",error.localizedDescription);
    }else{
        NSLog(@"连接请求发送成功！");
    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.friendsBlock(arr);
//    });
}

//与服务器断开连接
-(void)disconnect{
    
    //通知服务器下线
    [self goOffLine];
    //XMPPStream断开连接
    [_xmppStream disconnect];
}

//如果已经存在连接，先断开连接
-(void)currentStateIsConnected{
    
    if ([self.xmppStream isConnected]){
        [self.xmppStream disconnect];
    }
}


//初始化 XMPPStream并设置代理:
-(void)setupStream{
    
    
    self.msgArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    self.msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.msgArchivingStorage];
    [self.msgArchiving activate:self.xmppStream];
    
    
    
    _xmppStream = [[XMPPStream alloc]init];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.xmppRosterCoreDataStorage = [[XMPPRosterCoreDataStorage alloc]init];
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterCoreDataStorage];
    [self.xmppRoster activate:self.xmppStream];
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
}



-(void)addFriendsWithFriendsName:(NSString *)name{
    // 生成好友jid
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", name, @"127.0.0.1"]];
    
    // 第 1 种方法: 添加好友, 其对应的删除好友方法是, [self.xmppRoster unsubscribePresenceFromUser:jid];
    [self.xmppRoster subscribePresenceToUser:jid]; // 添加好友
    // 第 2 种方法: 添加好友,其对应的删除好友方法是, [self.xmppRoster removeUser:jid];
//    [self.xmppRoster addUser:jid withNickname:@"nickname"];//添加好友
}



-(void)deleteName:(NSString *)name{
    // 生成好友jid
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", name, @"127.0.0.1"]];
    // 第 1 种方法: 添加好友, 其对应的删除好友方法是, [self.xmppRoster unsubscribePresenceFromUser:jid];
    //[self.xmppRoster subscribePresenceToUser:jid]; // 添加好友
    // 第 2 种方法: 添加好友,其对应的删除好友方法是, [self.xmppRoster removeUser:jid];
    [self.xmppRoster removeUser:jid];//添加好友
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query = iq.childElement;
        if ([@"query" isEqualToString:query.name]) {
            NSArray *items = [query children];
            for (NSXMLElement *item in items) {
                NSString *jid = [item attributeStringValueForName:@"jid"];
                NSString *name = [jid stringByReplacingOccurrencesOfString:@"@127.0.0.1" withString:@""];
                NSDictionary *dic = @{@"name":name};
                [allFriends addObject:dic];
            }
            if (self.friendsBlock) {
                
            }
        }
    }
    return YES;
}



- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSString *a = @"收到一条新消息";
    NSString * msgs = [message stringValue];
    if ([message stringValue].length>0 && [message stringValue] != nil&&self.messageBlock != nil) {
        msgs =  [msgs stringByReplacingOccurrencesOfString:@"<body>" withString:@""];
        msgs = [msgs stringByReplacingOccurrencesOfString:@"</body>" withString:@""];
        if (self.messageBlock != nil) {
            SoundPlayer *sound = [[SoundPlayer alloc]init];
            [sound play:a volume:1 rate:0.5 pitchMultiplier:1];
            self.messageBlock(msgs);
        }
    }else{
        self.refresh(@{@"name":[[message fromStr]componentsSeparatedByString:@"@"].firstObject});
    }
}

-(void)getMessages:(refresh)refresh{
    self.refresh = refresh;
    [self.refresh copy];//复制一份防止销毁
}

-(void)getmessage:(getMessage)bloxk
{
    self.messageBlock  = bloxk;
    [bloxk copy];
    [self.messageBlock copy];
}



-(void)getFirends:(friendsListBlock)block{

    [self.xmppRoster fetchRoster];
    self.friendsBlock = block ;
}
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    NSString *presenceType = [presence type];
    NSString *name = [[presence from] user];
    if (![name isEqualToString:[[sender myJID] user]]) {
        if ([presenceType isEqualToString:@"available"]) {
            [arr addObject:@{@"name":name}];
             AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            self.friendsBlock(arr);
        } else if([presenceType isEqualToString:@"unavailable"]){
            [arr removeObject:@{@"name":name}];
            self.friendsBlock(arr);
        }
    }
}






//XMPPStream 上线
-(void)goOnline{
    
    // 实例化一个”展现“，上线的报告，默认类型为：available
    XMPPPresence *presence = [XMPPPresence presence];
    // 发送Presence给服务器,服务器知道“我”上线后，只需要通知我的好友，而无需通知我，因此，此方法没有回调
    [_xmppStream sendElement:presence];
}

//XMPPStream 离线
-(void)goOffLine{
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
    
}

//Bare,除去resource部分，包含Username@Domain
- (NSString *)getBareJidStr:(NSString *)jidStr{
    
    if ([jidStr hasSuffix:kxmppServer]) {
        return jidStr;
    }else{
        return [NSString stringWithFormat:@"%@@%@",jidStr,kxmppServer];
    }
}

-(void)dealloc{
    
    _xmppStream = nil;
    [_xmppStream removeDelegate:self];
}

@end



