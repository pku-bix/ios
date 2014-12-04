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
#import "ChatListViewController.h"
#import "MainTabBarController.h"
#import "ChatNavigationController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController
AppDelegate* appdelegate;


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
    
    return [[bixChatProvider defaultChatProvider].contacts count];
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
    
    Account *account = [[bixChatProvider defaultChatProvider].contacts objectAtIndex:[indexPath row]];
    
    //文本
    cell.textLabel.text = account.username;
    
    //标记
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //头像
    UIImage *headShow = [UIImage imageNamed:@"head_show.jpeg"];
    CGSize headShowSize = CGSizeMake(42, 42);
    cell.imageView.image = [self scaleToSize:headShow size:headShowSize];
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 21;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
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

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark UITableViewDelegate


// contact selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Account* account = [[bixChatProvider defaultChatProvider].contacts objectAtIndex:[indexPath row]];
    Session* sessionToOpen = [[bixChatProvider defaultChatProvider] getSession:account];
    
    //MainTabBarController* mainTabBarController = (MainTabBarController*)self.tabBarController;
    
    ChatNavigationController* chatNavigationController = (ChatNavigationController*)self.navigationController;
    [chatNavigationController popToRootViewControllerAnimated:NO];
    [chatNavigationController openSession: sessionToOpen];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //add code here for when you hit delete
        [[bixChatProvider defaultChatProvider].contacts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
