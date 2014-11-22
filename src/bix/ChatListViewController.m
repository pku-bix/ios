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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:REUSE_CELLID_CHATLIST];
    }
    Session *session = [[bixChatProvider defaultChatProvider].sessions objectAtIndex:[indexPath row]];
    
    //文本
    cell.textLabel.text = session.peerAccount.username;
    //标记
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
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
