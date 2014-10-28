//
//  bixLocalAccount.h
//  bix
//
//  Created by harttle on 10/28/14.
//  Copyright (c) 2014 bix. All rights reserved.
//
// 本地用户。继承自 Account，该类中维护了只有本地用户才需要存储的信息，如xmpp实体、密码、完整的用户信息。
//

#import "Account.h"

@interface bixLocalAccount : Account

@end
