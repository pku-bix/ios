//
//  ChatListViewController.m
//  bix
//
//  Created by harttle on 14-2-28.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Session.h"
#import "ChatMessage.h"

@interface ChatListViewController ()

@end

@implementation ChatListViewController

AppDelegate* appdelegate;
Session* sessionToOpen;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // retain xmppStream
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    // update msgs when absent
    [self updateList:nil];

    // msg event
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateList:)
     name:EVENT_MESSAGE_RECEIVED
     object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:EVENT_MESSAGE_RECEIVED
     object:nil];
}

- (void) updateList: (NSNotification*) notification
{
    [self.tableView reloadData];
}

-(void) openSession: (Session*)session{
    sessionToOpen = session;
    [self performSegueWithIdentifier:@"chat" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"chat"]) {
        
        ChatViewController *chatViewController = [segue destinationViewController];
        chatViewController.session = sessionToOpen;
    }
}



#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return [[bixChatProvider defaultChatProvider].sessions count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_CELLID_CHATLIST];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:REUSE_CELLID_CHATLIST];
    }
    Session *session = [[bixChatProvider defaultChatProvider].sessions objectAtIndex:[indexPath row]];
    
    //标记
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //消息
    ChatMessage* lastMsg = (ChatMessage*)[session.msgs lastObject];
    NSLog(@"%@",lastMsg.body);
    cell.detailTextLabel.text = lastMsg.body;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    [self updateCell:cell withAccount:session.peerAccount];
    session.peerAccount.cb = ^(Account* account){
        [self updateCell:cell withAccount:account];
    };
    [session.peerAccount pull];
    
    return cell;
}

- (void) updateCell: (UITableViewCell*)cell withAccount:(Account*)account{
    //昵称
    cell.textLabel.text = account.displayName;
    
    //头像。这里使用了插件，将url直接设置到imageview。应该操作imageview，让image来适配，而不是调整image。
    
    //UIImage *headShow = [UIImage imageNamed:@"head_show.jpeg"];
    //cell.imageView.image = [self scaleToSize: size:CGSizeMake(48, 48)];
    
    [account.avatar setImageToImageView:cell.imageView];
    
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 24;
    
    CGRect frame = cell.imageView.frame;
    frame.size = CGSizeMake(48, 48);
    cell.imageView.frame = frame;
    
    [cell.imageView layoutIfNeeded];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage; 
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Session* session = [[bixChatProvider defaultChatProvider].sessions objectAtIndex:[indexPath row]];
    [self openSession:session];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //add code here for when you hit delete
        [[bixChatProvider defaultChatProvider].sessions removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
