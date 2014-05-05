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
static NSString *KEY_ACTIVE_JID = @"active_jid";
static NSString *KEY_PASSWORD = @"password";
static NSString *KEY_AUTOLOGIN= @"autologin";
//static NSString *KEY_ACTIVE_TABINDEX=@"active_tabindex";
static NSString *KEY_CONTACT_LIST=@"contact_list";
static NSString *KEY_SESSION_LIST=@"session_list";
static NSString *KEY_MESSAGE_LIST=@"message_list";
static NSString *KEY_JID=@"jid";

//static NSString *SERVER_DOMAIN = @"orange.local";
//static NSString *SERVER_DOMAIN = @"dsxdemacbook-pro.local";

/* server spec
 * used for server config
 */
static NSString *SERVER = @"127.0.0.1";
//static NSString *SERVER_DOMAIN = @"orange.local";
static NSString *SERVER_DOMAIN = @"dsxdemacbook-pro.local";

static NSString *BAIDU_MAP_KEY = @"oCvXZCd41PsMzOw0disOu1QA";


/* event strings
 * used for notification event identity.
 */
static NSString *EVENT_BUDDY_PRESENCE=@"buddy_presence";
static NSString *EVENT_MESSAGE_RECEIVED=@"message_received";
static NSString *EVENT_MESSAGE_SENT=@"message_sent";
static NSString *EVENT_CONTACT_ADDED=@"contact_added";


/* reuse key
 * used for reuse resource identity
 */
static NSString *REUSE_CELLID_CHATLIST=@"reuse_cellid_chatlist";
static NSString *REUSE_CELLID_MSGLIST=@"reuse_cellid_msglist";
static NSString *REUSE_CELLID_CONTACTLIST=@"reuse_cellid_contactlist";


/* graphic config
 * used for graphic drawing
 */
#define MARGIN_MSG_RECEIVER     10
#define MARGIN_MSG_SENDER       5
#define MARGIN_MSG_TOP          5
#define MARGIN_MSG_BOTTOM       5

#define PADDING_MSG_TOP         10
#define PADDING_MSG_BOTTOM      10
#define PADDING_MSG_RECEIVER    12
#define PADDING_MSG_SENDER      20

#define IMGCAP_WIDTH_SENDER     20
#define IMGCAP_HEIGHT_SENDER    15
#define IMGCAP_WIDTH_RECEIVER   14
#define IMGCAP_HEIGHT_RECEIVER  15
#define MARGIN_TIMEINFO         20

#endif
