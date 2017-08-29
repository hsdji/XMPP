//
//  xmppManage.h
//  XMPP
//
//  Created by user on 17/8/28.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

//block 用户登录，注册部分
typedef void (^OperationSuccessBlock)();
typedef void (^OperationfailedBlock)(NSString *error);
typedef void (^friendsListBlock)(NSArray *block);

typedef void (^getMessage)(NSString *messahe);


typedef void (^refresh)(NSDictionary *dic);

@interface xmppManage : NSObject<XMPPStreamDelegate>

//xmppManage单利
+(xmppManage *)sharedManage;

@property(nonatomic,strong)XMPPStream *xmppStream;
//是否注册用户标示
//是否注册用户标示
@property (assign,nonatomic)BOOL isRegisterUser;
@property(nonatomic,copy)OperationSuccessBlock successBlock;
@property(nonatomic,copy)OperationfailedBlock failedBlock;
@property (nonatomic,copy)friendsListBlock friendsBlock;
@property (nonatomic,copy)getMessage messageBlock;
@property (nonatomic,strong)XMPPRoster *xmppRoster;

@property (nonatomic,strong)XMPPRosterCoreDataStorage *xmppRosterCoreDataStorage;


@property (nonatomic,strong)XMPPMessageArchiving *msgArchiving;

@property (nonatomic,strong)XMPPMessageArchivingCoreDataStorage *msgArchivingStorage;

@property (nonatomic,copy)refresh refresh;
-(void)getMessages:(refresh)refresh;


//添加好友
-(void)addFriendsWithFriendsName:(NSString *)name;
//删除好友
-(void)deleteName:(NSString *)name;
//获取好友列表
-(void)getFirends:(friendsListBlock)block;



//登录
-(void)loginWithUserName:(NSString *)userName password:(NSString *)password loginSuccess:(OperationSuccessBlock)loginSuceess loginFailed:(OperationfailedBlock)loginFailed;

//注册
- (void)registerWithUserName:(NSString *)userName  password:(NSString *)password registerSuccess:(OperationSuccessBlock)registerSuccess registerFailed:(OperationfailedBlock)registerFailed;

-(void)getmessage:(getMessage)block;
@end
