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
static NSString *const KEY_CONTACT_LIST=@"contact_list";
static NSString *const KEY_SESSION_LIST=@"session_list";
static NSString *const KEY_MESSAGE_LIST=@"message_list";
static NSString *const KEY_REMOTE_BAREJID=@"remote_barejid";
static NSString *const KEY_BAREJID=@"barejid";

//static int aaaaaa = 5;

//static NSString *SERVER_DOMAIN = @"orange.local";
//static NSString *SERVER_DOMAIN = @"dsxdemacbook-pro.local";

/* server spec
 * used for server config
 */
static NSString* const SERVER = @"121.40.72.197";
static NSString* const SERVER_DOMAIN = @"bix.org";
static const NSTimeInterval CONNECT_TIMEOUT = 10;
static NSString* const BAIDU_MAP_KEY = @"oCvXZCd41PsMzOw0disOu1QA";

/*
 app打开时，请求服务器地图标注信息的ip+path；
 */
//static NSString *const LOCATION_INFO_IP = @"http://121.40.72.197/api/piles";
static NSString *const LOCATION_INFO_IP = @"http://121.40.72.197/api/chargers";

//点击地图标注的吹出框，请求服务器对应的充电桩的详细信息
//static NSString *const LOCATION_DETAIL_INFO_IP = @"http://121.40.72.197/api/pile/";
static NSString *const LOCATION_DETAIL_INFO_IP = @"http://121.40.72.197/api/charger/";

//POST设置界面的头像、姓名、用户id、个性签名、微信号、Tesla车型的ip
static NSString *const POST_IMAGE_TEXT_INFO_IP = @"http://121.40.72.197/api/user/";

//设置界面 -》个人信息 -》名字 字段类型
static const int NAME_TYPE = 1;
static const int SIGNATURE_TYPE = 2;    //个性签名
static const int WE_CHAT_ID_TYPE = 3;   //微信号
static const int TESLA_MODEL_TYPE = 4;  //Tesla车型
static const int FEED_BACK_TYPE = 5;    //反馈与建议


/*
 点击充电桩详情页面，展示的数据项数
 */
static const int DETAIL_INFO_NUMBER = 5;

//请求完服务器数据时，发出的通知
static NSString* const REQUEST_SIMPLE_INFO = @"request_simpe_info_from_server";

//向服务器请求充电桩详情时，发出的通知
static NSString* const REQUEST_CHARGER_DETAIL_INFO = @"request_charger_detail_info";

//传递分享充电桩时，传递经纬度发出的通知
static NSString* const SEND_COORDINATE = @"send_latitude_longitude";

/* event strings
 * used for notification event identity.
 */
static  NSString *const EVENT_BUDDY_PRESENCE=@"buddy_presence";
static  NSString *const EVENT_MESSAGE_RECEIVED=@"message_received";
static  NSString *const EVENT_MESSAGE_SENT=@"message_sent";
static  NSString *const EVENT_CONTACT_ADDED=@"contact_added";
static  NSString *const EVENT_SESSION_ADDED=@"session_added";
static  NSString *const EVENT_DISCONNECTED=@"disconnected";
static  NSString *const EVENT_CONNECTED=@"connected";
static  NSString *const EVENT_CONNECT_TIMEOUT=@"connect_timeout";
static  NSString *const EVENT_AUTHENTICATED=@"authenticated";
static  NSString *const EVENT_AUTHENTICATE_FAILED=@"authenticate_failed";
static  NSString *const EVENT_REGISTERED=@"registered";
static  NSString *const EVENT_REGISTER_FAILED=@"register_failed";
static  NSString *const EVENT_ERROR_RECEIVED=@"error_received";


/* reuse key
 * used for reuse resource identity
 */
static  NSString *const REUSE_CELLID_CHATLIST=@"reuse_cellid_chatlist";
static  NSString *const REUSE_CELLID_MSGLIST=@"reuse_cellid_msglist";
static  NSString *const REUSE_CELLID_CONTACTLIST=@"reuse_cellid_contactlist";
static  NSString *const REUSE_CELLID_MOMENTLIST=@"reuse_cellid_momentlist";
static  NSString *const REUSE_CELLID_MOMENTREPLYLIST=@"reuse_cellid_momentreplylist";

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
