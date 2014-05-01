//
//  ChatListViewController.h
//  bix
//
//  Created by harttle on 14-2-28.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPStream.h"
#import "Session.h"

@interface ChatListViewController : UITableViewController

//XMPPStream xmppStream = new XMPPStream();
//xmppStream.myJID = [XMPPJID jidWithString:@"user@dev1.myCompany.com"];
//xmppStream.hostName = @"192.168.2.27";

-(void) openSession: (Session*)session;

@end
