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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
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


#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return [appdelegate.dataWorker.sessions count];
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
    Session *session = [appdelegate.dataWorker.sessions objectAtIndex:[indexPath row]];
    
    //文本
    cell.textLabel.text = session.remoteJid;
    //标记
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //start a Chat
    sessionToOpen = [appdelegate.dataWorker.sessions objectAtIndex:[indexPath row]];
    
    [self performSegueWithIdentifier:@"chat" sender:self];
    
}

// init chat controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"chat"]) {
        
        ChatViewController *chatViewController = [segue destinationViewController];
        chatViewController.session = sessionToOpen;
    }
}


@end
