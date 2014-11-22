//
//  Constants.h
//  Bix
//
//  Created by harttle on 14-3-9.
//  Copyright (c) 2014年 bix. All rights reserved.
//

// TODO: @杨珺 并非所有字面字符串都需要定义为常量。常量带来的好处在于减少拼写错误，对于只在同一文件中引用的字面字符串而言，该做法徒增工作量。
// 逐步迁移：
// 1. 只在一个文件中使用的取消其常量定义。如：本地文件存储的key、tableviewCell的reuse Key
// 2. 在多个文件用到的字面字符串，应添加到该文件中。如：通知的Key。

#ifndef Bix_Constants_h
#define Bix_Constants_h


// XMPP 服务器
static NSString* const XMPP_SERVER = @"121.40.72.197";
static NSString* const XMPP_SERVER_DOMAIN = @"bix.org";
static const NSTimeInterval XMPP_CONNECT_TIMEOUT = 10;

// API 服务器
static NSString* const API_SERVER = @"192.168.1.105:3000";

// 百度地图
static NSString* const BAIDU_MAP_KEY = @"oCvXZCd41PsMzOw0disOu1QA";



/*
 广域网请求服务器对应的各个ip地址，
 */

//app打开时，请求服务器地图标注信息的ip+path；
static NSString *const LOCATION_INFO_IP = @"http://121.40.72.197/api/chargers";

//点击地图标注的吹出框，请求服务器对应的充电桩的详细信息
static NSString *const LOCATION_DETAIL_INFO_IP = @"http://121.40.72.197/api/charger/";

//上报充电桩详细信息的IP
static NSString *const REPORT_CHARGER_INFO_IP = @"http://121.40.72.197/api/charger";

//POST设置界面的头像、姓名、用户id、个性签名、微信号、Tesla车型的ip
static NSString *const POST_IMAGE_TEXT_INFO_IP = @"http://121.40.72.197/api/user/";

//分享圈 发送文字和图片 的ip
static NSString *const POST_MOMENT_IP = @"http://121.40.72.197:80/api/posts";

//通知需要设备的deviceToken, 将每个用户的deviceToken post到服务器的 ip 地址
// TODO: @杜实现 在该方法中POST该Token至 /api/user/<username>
static NSString *const POST_DEVICE_TOKEN_IP = @"http://121.40.72.197/api/user/";


/*
 设置界面 -》个人信息 -》名字 字段类型
 */
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

static const int CHAT_HEAD_SHOW_SIZE            =       32;         // 聊天头像大小
static const int CHAT_HEAD_SHOW_PADDING_TOP     =       5;          // 聊天头像上边距
static const int CHAT_HEAD_SHOW_PADDING_BOTTOM  =       5;          // 聊天头像下边距
static const int CHAT_HEAD_SHOW_PADDING_LEFT    =       2;          // 聊天头像左边距
static const int CHAT_HEAD_SHOW_PADDING_RIGHT   =       2;          // 聊天头像右边距

static const int TIMEINFO_HEIGHT      =   20;
static const NSTimeInterval EXPIRE_TIME_INTERVAL =   60.0;    //回话过期时间（s），此后需重新显示日期

#endif
