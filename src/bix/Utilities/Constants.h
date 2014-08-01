//
//  Constants.h
//  Bix
//
//  Created by harttle on 14-3-9.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#ifndef Bix_Constants_h
#define Bix_Constants_h


/* local storage string
 * used for local storage identity
 */
static NSString *const KEY_ACTIVE_JID = @"active_jid";
static NSString *const KEY_PASSWORD = @"password";
static NSString *const KEY_AUTOLOGIN= @"autologin";
//static NSString *const KEY_ACTIVE_TABINDEX=@"active_tabindex";
static NSString *const KEY_CONTACT_LIST=@"contact_list";
static NSString *const KEY_SESSION_LIST=@"session_list";
static NSString *const KEY_MESSAGE_LIST=@"message_list";
static NSString *const KEY_JID=@"jid";

//static NSString *SERVER_DOMAIN = @"orange.local";
//static NSString *SERVER_DOMAIN = @"dsxdemacbook-pro.local";

/* server spec
 * used for server config
 */
static NSString* const SERVER = @"121.40.72.197";
static NSString* const SERVER_DOMAIN = @"bix.org";
static const NSTimeInterval CONNECT_TIMEOUT = 10;
static NSString* const BAIDU_MAP_KEY = @"oCvXZCd41PsMzOw0disOu1QA";




/* event strings
 * used for notification event identity.
 */
static  NSString *const EVENT_BUDDY_PRESENCE=@"buddy_presence";
static  NSString *const EVENT_MESSAGE_RECEIVED=@"message_received";
static  NSString *const EVENT_MESSAGE_SENT=@"message_sent";
static  NSString *const EVENT_CONTACT_ADDED=@"contact_added";
static  NSString *const EVENT_DISCONNECTED=@"disconnected";
static  NSString *const EVENT_CONNECTED=@"connected";
static  NSString *const EVENT_CONNECT_TIMEOUT=@"connect_timeout";
static  NSString *const EVENT_AUTHENTICATED=@"authenticated";
static  NSString *const EVENT_AUTHENTICATE_FAILED=@"authenticate_failed";


/* reuse key
 * used for reuse resource identity
 */
static  NSString *const REUSE_CELLID_CHATLIST=@"reuse_cellid_chatlist";
static  NSString *const REUSE_CELLID_MSGLIST=@"reuse_cellid_msglist";
static  NSString *const REUSE_CELLID_CONTACTLIST=@"reuse_cellid_contactlist";


/* msg in session
 * used for graphic drawing
 */
static const int MARGIN_MSG_RECEIVER  =   10;  //接收方
static const int MARGIN_MSG_SENDER   =    5;   //发送方
static const int MARGIN_MSG_TOP       =   5;   //上方
static const int MARGIN_MSG_BOTTOM   =    5;   //下方

static const int PADDING_MSG_TOP      =   10;  //上方
static const int PADDING_MSG_BOTTOM   =   14;  //下方
static const int PADDING_MSG_RECEIVER =   15;  //接收方
static const int PADDING_MSG_SENDER   =   15;  //发送方

static const int TIMEINFO_HEIGHT      =   20;
static const NSTimeInterval EXPIRE_TIME_INTERVAL =   60.0;    //回话过期时间（s），此后需重新显示日期

#endif
