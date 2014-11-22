//
//  XMPPDelegate.m
//  bix
//
//  Created by harttle on 14-3-7.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixChatProvider.h"
#import "NSDate+Wrapper.h"
#import "Constants.h"
#import "Session.h"
#import "NSString+Account.h"
#import "ChatMessage.h"

@interface bixChatProvider()

-(void)goOnline;
-(void)goOffline;
-(id) initWithAccount: (bixLocalAccount*)account;

@end


@implementation bixChatProvider{
    // retry chances remained
    int nRetry;
}


static bixLocalAccount* localAccount;
static bixChatProvider *instance = nil;

// singleton settings
+(void)setLocalAccount:(bixLocalAccount*) account{
    localAccount = account;
    instance = [[bixChatProvider alloc] initWithAccount:localAccount];
    
    NSLog(@"%@",localAccount);
    
    [instance load];
}


// singleton instance
+(bixChatProvider*)defaultChatProvider{
#ifdef DEBUG
    if (localAccount==nil)
        NSLog(@"Error instantiate chatprovider: account not set");
#endif
    return instance;
}


-(id)initWithAccount: (bixLocalAccount*)account{
    self = [super init];
    
    // 出于设计，构造函数内不要使用访问器
    _account = account;
    
    self.qsending = [NSMutableArray new];
    
    self.xmppStream = [XMPPStream new];
    // self.xmppStream.enableBackgroundingOnSocket = true; // this trick will be rejected by appstore
    self.xmppStream.hostName = XMPP_SERVER;
    self.xmppStream.myJID = account.username.toJid;
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];

    return self;
}

// 自定义访问器
-(void)setAccount:(bixLocalAccount *)account{
    _account = account;
    self.xmppStream.myJID = account.username.toJid;
}

-(void)dealloc{
    [self.xmppStream removeDelegate:self];
}

+(void)save{
    bixChatProvider* cp = [bixChatProvider defaultChatProvider];
    if (cp!=nil) {
        [cp save];
    }
}

+(void)reconnect{
    bixChatProvider* cp = [bixChatProvider defaultChatProvider];
    bixLocalAccount* ac = [bixLocalAccount instance];
    
    if (cp!=nil && ac!=nil && ac.presence) {
        [cp keepConnected:-1];
    }
}


#pragma mark - Sessions Contacts

//query contact, add when needed
-(Account*)getConcactByUsername: (NSString*)username{
    
    // self query
    if([self.account.username isEqualToString: username]) return self.account;
    
    NSArray* filteredContacts =[self.contacts
                                filteredArrayUsingPredicate:
                                [NSPredicate predicateWithFormat:@"username == %@",username]];
    
    if (filteredContacts.count > 0)
        return filteredContacts[0];
    
    Account* account = [[Account alloc] initWithUsername:username];
    [self.contacts addObject:account];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CONTACT_ADDED object:self ];
    
    return account;
}


//query session, add when needed
-(Session*)getSession: (Account*)remoteAccount{
    
    NSArray* filteredSessions =[self.sessions
                                filteredArrayUsingPredicate:
                                [NSPredicate predicateWithFormat:@"peername == %@",remoteAccount.username]];
    
    if (filteredSessions.count > 0)
        return filteredSessions[0];

    Session* session = [[Session alloc] initWithRemoteAccount:remoteAccount];
    [self.sessions addObject:session];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_SESSION_ADDED object:self ];
    
    return session;
}

-(void) save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // encoding
    NSData *contact_data = [NSKeyedArchiver archivedDataWithRootObject:self.contacts];
    [defaults setObject:contact_data forKey:[self contacts_key]];
    
    NSData *session_data = [NSKeyedArchiver archivedDataWithRootObject:self.sessions];
    [defaults setObject:session_data forKey:[self sessions_key]];

    // flush
    [defaults synchronize];
}

-(void) load{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData* contact_data = [defaults objectForKey:[self contacts_key]];
    self.contacts = contact_data ? [NSKeyedUnarchiver unarchiveObjectWithData: contact_data] : [NSMutableArray array];
    
    // session init requires contact init
    NSData* session_data = [defaults objectForKey:[self sessions_key]];
    self.sessions = session_data ? [NSKeyedUnarchiver unarchiveObjectWithData: session_data] : [NSMutableArray array];
}

-(NSString*) contacts_key{
    return [self.account.username stringByAppendingFormat:@"_contacts" ];
}
-(NSString*) sessions_key{
    return [self.account.username stringByAppendingFormat:@"_sessions" ];
}

#pragma mark - XMPP utilities

-(void)goOnline{
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
}

-(void)goOffline{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
    self.account.presence = false;
}

-(void) logOut{
    [self.xmppStream disconnectAfterSending];
    [self goOffline];
    [self save];
}

-(BOOL)keepConnectedAndAuthenticated:(int)count{
    nRetry = count;
    self.autoAuthentication = true;
    return [self doConnect];
}

-(BOOL)keepConnected:(int)count{
    nRetry = count;
    self.autoAuthentication = false;
    return [self doConnect];
}

-(BOOL)doConnect{
    if(self.xmppStream.isConnected || self.xmppStream.isConnecting) return true;
    if (nRetry > 0) {
        nRetry -- ;
        return [self.xmppStream connectWithTimeout:XMPP_CONNECT_TIMEOUT error: nil];
    }
    else if (nRetry == -1){
        return [self.xmppStream connectWithTimeout:XMPP_CONNECT_TIMEOUT error: nil];
    }
    return false;
}

-(BOOL) registerAccount{
    NSError* error = nil;
    if([self.xmppStream registerWithPassword:self.account.password error:&error]){
        return true;
    }
    else{
        NSLog(@"register error: %@", error);
        return false;
    }
}

-(void) authenticate{
    NSError *error = nil;
    [self.xmppStream authenticateWithPassword:self.account.password error:&error];
}

-(void)send: (Account*)remoteAccount Message:(NSString*)body{
    ChatMessage *msg = [[ChatMessage alloc] initWithBody:body From:self.xmppStream.myJID To:remoteAccount.username.toJid];
    [self.xmppStream sendElement:msg];
}

// 重发
-(void) resendAll: (XMPPStream*)sender{
    while(self.qsending.count>0) {
        [sender sendElement:self.qsending.firstObject];
        [self.qsending removeObjectAtIndex:0];
    }
}

#pragma mark - XMPPStreamDelegate

// 连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
#ifdef DEBUG
    NSLog(@"xmpp connected");
#endif
    // 验证
    if ( self.autoAuthentication && !sender.isAuthenticated && !sender.isAuthenticating) {
        [self authenticate];
    }
    // 重发
    if(self.account.presence && sender.isAuthenticated){
        [self resendAll:sender];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CONNECTED object:self];
}
// 连接超时
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
#ifdef DEBUG
    NSLog(@"xmpp connect timeout");
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DISCONNECTED object:self];
    [self doConnect];
}
// 断开连接成功
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
#ifdef DEBUG
    NSLog(@"xmpp disconnect");
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DISCONNECTED object:self];

    //保存账号
    [self.account save];
}

// 验证成功
- (void) xmppStreamDidAuthenticate:(XMPPStream *)sender{
#ifdef DEBUG
    NSLog(@"xmpp authenticated");
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_AUTHENTICATED object:self];

    self.account.autoLogin = YES;
    [self.account saveForRestore];
    
    [self goOnline];
    [self resendAll:sender];
}
// 验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
#ifdef DEBUG
    NSLog(@"xmpp authenticate failed:\n%@\n\n",error);
#endif    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_AUTHENTICATE_FAILED object:self];
}
//将要发送状态
- (XMPPPresence *)xmppStream:(XMPPStream *)sender willSendPresence:(XMPPPresence *)presence{
#ifdef DEBUG
    NSLog(@"xmpp will send presence\n%@\n\n",presence);
#endif
    return presence;
}
//已发送状态
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence{
#ifdef DEBUG
    NSLog(@"xmpp sent presence:\n%@\n\n",presence);
#endif
}
//发送状态失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error{
#ifdef DEBUG
    NSLog(@"xmpp send presence failed, error: %@\npresence:\n%@\n\n",error,presence);
#endif
    if (error.code == XMPPStreamInvalidState && error.domain==XMPPStreamErrorDomain) {
        [self keepConnectedAndAuthenticated:-1];
        [self.qsending addObject:presence];
#ifdef DEBUG
        NSLog(@"xmpp state invalid, reconnecting...");
#endif
    }
}
//收到状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
#ifdef DEBUG
    NSLog(@"xmpp presence received:\n%@\n\n", presence);
#endif
    //取得好友状态
    NSString *presenceType = [presence type]; //"available", "unavailable"
    //当前用户
    XMPPJID *myJid = [sender myJID];
    //在线用户
    XMPPJID *remoteJid = [presence from];
    
    Account* remoteAccount = [self getConcactByUsername:remoteJid.user];
    remoteAccount.presence = [presenceType isEqual: @"available"];
    
    if (![remoteJid.bare isEqualToString:myJid.bare]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BUDDY_PRESENCE object:self
                                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    remoteAccount, @"account", nil ]];
    }
}
//将要发送聊天
- (XMPPMessage *)xmppStream:(XMPPStream *)sender willSendMessage:(XMPPMessage *)message{
    Account* remoteAccount = [self getConcactByUsername:message.to.user];
    Session* session = [self getSession:remoteAccount];
    
    ChatMessage* chatMessage = [[ChatMessage alloc] initWithXMPPMessage:message];
    [session.msgs addObject:chatMessage];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MESSAGE_SENT object:chatMessage ];
    return chatMessage;
}
//已发送聊天
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
#ifdef DEBUG
    NSLog(@"xmpp sent message:\n%@\n\n",message);
#endif
}
//发送聊天失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
#ifdef DEBUG
    NSLog(@"xmpp send message failed: %@\nmessage:\n%@\n\n",error,message);
#endif
    if (error.code == XMPPStreamInvalidState && error.domain==XMPPStreamErrorDomain) {
        [self keepConnectedAndAuthenticated:-1];
        [self.qsending addObject:message];
#ifdef DEBUG
        NSLog(@"xmpp state invalid, reconnecting...");
#endif
    }
}
//收到聊天
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
#ifdef DEBUG
    NSLog(@"xmpp message received:\n%@\n\n",message);
#endif
    // only chat message with body proceeds
    if (!message.isChatMessageWithBody) {
        return;
    }
    
    // generate chatMessage
    ChatMessage *chatMessage = [[ChatMessage alloc] initWithBody:message.body From:message.from To:message.to];
    
    Account* remoteAccount = [self getConcactByUsername:message.from.user];
    Session* session = [self getSession:remoteAccount];
    [session.msgs addObject:chatMessage];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MESSAGE_RECEIVED object:self ];
}


//将要发送IQ
- (XMPPIQ *)xmppStream:(XMPPStream *)sender willSendIQ:(XMPPIQ *)iq{
#ifdef DEBUG
    NSLog(@"xmpp will send iq:\n%@\n\n",iq);
#endif
    return iq;
}
//已发送IQ
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq{
#ifdef DEBUG
    NSLog(@"xmpp send iq succeed:\n%@\n\n",iq);
#endif
}
//发送IQ失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error{
#ifdef DEBUG
    NSLog(@"xmpp send iq failed: %@\niq:\n%@\n\n",error,iq);
#endif
    if (error.code == XMPPStreamInvalidState && error.domain==XMPPStreamErrorDomain) {
        [self keepConnectedAndAuthenticated:-1];
        [self.qsending addObject:iq];
#ifdef DEBUG
        NSLog(@"xmpp state invalid, reconnecting...");
#endif
    }
}

// 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_REGISTERED object:self ];
#ifdef DEBUG
    NSLog(@"xmpp registered");
#endif
}

// 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_REGISTER_FAILED object:self
                                                      userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 error,@"error", nil]];
#ifdef DEBUG
    NSLog(@"xmpp register failed: \n%@\n\n", error);
#endif
}

//收到错误信息
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_ERROR_RECEIVED object:self
                                                      userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 error, @"error", nil]];
#ifdef DEBUG
    NSLog(@"xmpp error received:\n%@\n\n",error);
#endif
}


@end
