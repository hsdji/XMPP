//
//  JKXMPPTool.h
//  XMPP
//
//  Created by user on 17/8/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPReconnect.h"
#import "XMPPAutoPing.h"
//#import "XMPPIncomingFileTransfer.h"
@interface JKXMPPTool : NSObject<XMPPStreamDelegate,UIAlertViewDelegate,XMPPRosterDelegate,XMPPRosterMemoryStorageDelegate>

@property (strong, nonatomic)   NSMutableDictionary            *blockDict;  /**< 存放block的字典 */

@property (nonatomic, strong) XMPPStream *xmppStream;
// 模块
@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;

@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPRosterMemoryStorage *xmppRosterMemoryStorage;

@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

//@property (nonatomic, strong) XMPPIncomingFileTransfer *xmppIncomingFileTransfer;

@property (nonatomic, assign) BOOL  xmppNeedRegister;
@property (nonatomic, copy)   NSString *myPassword;

@property (nonatomic, strong) XMPPPresence *receivePresence;

+ (instancetype)sharedInstance;
- (void)loginWithJID:(XMPPJID *)JID andPassword:(NSString *)password;
- (void)registerWithJID:(XMPPJID *)JID andPassword:(NSString *)password;

- (void)addFriend:(XMPPJID *)aJID;

/**
 *  退出登录
 */
- (void)logout;

@end

