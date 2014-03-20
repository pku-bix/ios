//
//  ContactViewController.m
//  bix
//
//  Created by harttle on 14-2-28.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "ContactViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Session.h"
#import "ChatViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController
AppDelegate* appdelegate;

Session* sessionToOpen;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    // reload when entering
    [self updateContact];
    
    // contacts update
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateContact)
                                                 name:EVENT_CONTACT_ADDED
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{

    // contacts update
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_CONTACT_ADDED
                                                  object:nil];
}

-(void)updateContact{
    [self.tableView reloadData];
}




#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [appdelegate.account.contacts count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_CELLID_CONTACTLIST];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:REUSE_CELLID_CONTACTLIST];
    }
    
    Account *account = [appdelegate.account.contacts objectAtIndex:[indexPath row]];
    
    //文本
    cell.textLabel.text = account.Jid.user;
    
    //标记
    cell.accessoryType = UITableViewCellAccessoryNone;
    
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
    
    //start a Chat
    Account* account = [appdelegate.account.contacts objectAtIndex:[indexPath row]];
    sessionToOpen = [appdelegate.xmppDelegate updateSession:account.Jid];
    [self performSegueWithIdentifier:@"chat" sender:self];
}

// init chat controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"chat"]) {
        
        ChatViewController *chatViewController = [segue destinationViewController];
        chatViewController.session = sessionToOpen;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //add code here for when you hit delete
        [appdelegate.account.contacts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
