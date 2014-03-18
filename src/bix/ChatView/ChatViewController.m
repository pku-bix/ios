//
//  ChatViewController.m
//  bix
//
//  Created by harttle on 14-3-12.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "MessageCell.h"
#import "NSDate+Wrapper.h"
#import "XMPPStream+Wrapper.h"
#import "XMPPMessage+Wrapper.h"

@interface ChatViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textView;

- (IBAction)Send:(id)sender;
- (IBAction)Tap:(id)sender;

@end



@implementation ChatViewController

// app scope object
AppDelegate* appdelegate;

// view is animating
bool isAnimating;

// view needs scroll
bool scrollNeeded;


- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        isAnimating = scrollNeeded = NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // retain xmppStream
    
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self updateList:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = [NSString stringWithFormat: @"%@", self.session.bareJid];
    
    // viewsize update
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(KeyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    
    // message udpate
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateList:)
                                                 name:EVENT_MESSAGE_RECEIVED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateList:)
                                                 name:EVENT_MESSAGE_SENT
                                               object:nil];
    
    
    //[self ScrollToBottom];
}

- (void)viewWillDisappear:(BOOL)animated{
    // viewsize update
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidChangeFrameNotification
                                                  object:nil];
    
    // message update
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_MESSAGE_RECEIVED
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_MESSAGE_SENT
                                                  object:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Send:(id)sender {
    NSString *message = self.textView.text;
    if (message.length == 0) return;
    
    [appdelegate.xmppStream send:self.session.remoteJid Message:message];
    [appdelegate.xmppStream send:[XMPPJID jidWithString:@"harttle@orange.local"] Message:message];
    self.textView.text = @"";
    
    [self.textView resignFirstResponder];
}

- (void) updateList: (NSNotification*) notification{
    
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadData];    //async
    } completion:^(BOOL finished) {
        
        if (isAnimating) {
            scrollNeeded = YES;
        }
        else{
            [self ScrollToBottom];
        }
    }];
    
}

- (void) ScrollToBottom{
    
     if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        //NSLog(@"scrollToBottom:%f;%f",self.tableView.contentOffset.y, offset.y);
        
        [self.tableView setContentOffset:offset animated:YES];
        
        scrollNeeded = false;
    }
}



#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.session.msgs count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // try to reuse cell
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_CELLID_MSGLIST];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleValue1
        reuseIdentifier:REUSE_CELLID_MSGLIST];
    }
    
    // setup cell
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;
    
    // get msg
    XMPPMessage* msg = [self.session.msgs objectAtIndex:indexPath.row];
    
    // set msg cell
    cell.msgTextView.text = msg.body;
    cell.timeInfo.text = [msg.time toString];
    [cell.timeInfo sizeToFit];
    cell.timeInfo.center = CGPointMake(self.view.frame.size.width/2,
                                       MARGIN_TIMEINFO - cell.timeInfo.frame.size.height/2);
    CGSize size = [self getDisplaySize:msg.body];
    UIImage *bgImage = nil;
    
    int margin_msg_top = MARGIN_MSG_TOP + MARGIN_TIMEINFO;
    if (!msg.isMine) {
        
        bgImage = [[UIImage imageNamed:@"BlueBubble2.png"] stretchableImageWithLeftCapWidth:IMGCAP_WIDTH_SENDER topCapHeight:IMGCAP_HEIGHT_SENDER];
        [cell.msgTextView setFrame:CGRectMake(PADDING_MSG_SENDER + MARGIN_MSG_SENDER,
                                                     margin_msg_top + PADDING_MSG_TOP,
                                                     size.width, size.height)];
        [cell.bgImageView setFrame:CGRectMake(MARGIN_MSG_SENDER, margin_msg_top,
                                              size.width + PADDING_MSG_RECEIVER + PADDING_MSG_SENDER,
                                              size.height + PADDING_MSG_TOP + PADDING_MSG_BOTTOM)];
    }else {
        bgImage = [[UIImage imageNamed:@"GreenBubble2.png"] stretchableImageWithLeftCapWidth:IMGCAP_WIDTH_RECEIVER topCapHeight:IMGCAP_HEIGHT_RECEIVER];
        
        [cell.msgTextView setFrame:
         CGRectMake(self.view.frame.size.width - size.width - PADDING_MSG_SENDER - MARGIN_MSG_SENDER,
                    margin_msg_top + PADDING_MSG_TOP,
                    size.width,
                    size.height)];
        [cell.bgImageView setFrame:
         CGRectMake(self.view.frame.size.width - size.width - MARGIN_MSG_SENDER - PADDING_MSG_SENDER - PADDING_MSG_RECEIVER,
                    margin_msg_top,
                    size.width + PADDING_MSG_RECEIVER + PADDING_MSG_SENDER,
                    size.height + PADDING_MSG_TOP + PADDING_MSG_BOTTOM)];
    }
    cell.bgImageView.image = bgImage;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XMPPMessage* msg = [self.session.msgs objectAtIndex:indexPath.row];
    
    CGSize size = [self getDisplaySize:msg.body];
    
    int margin_msg_top = MARGIN_MSG_TOP + MARGIN_TIMEINFO;
    return size.height + PADDING_MSG_TOP + PADDING_MSG_BOTTOM + margin_msg_top + MARGIN_MSG_BOTTOM;
}

-(CGSize) getDisplaySize:(NSString*) str{
    
    CGSize textSize = {self.view.frame.size.width
        - PADDING_MSG_RECEIVER - PADDING_MSG_SENDER - MARGIN_MSG_RECEIVER- MARGIN_MSG_SENDER,
        INTMAX_MAX};
    
    CGSize size = [str boundingRectWithSize:textSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                                    context: nil].size;
    return size;
}



#pragma mark - Keyboard related

// update view height now!
-(void)KeyboardWillChangeFrame: (NSNotification *)notification {
    isAnimating = YES;
    
    // Get the keyboard rect
    CGRect kbBeginrect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect kbEndrect   = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Animate the current view out of the way
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    
    CGRect rect = self.view.frame;
    double height_change = kbEndrect.origin.y - kbBeginrect.origin.y;
    rect.size.height += height_change;
    self.view.frame = rect;
    //NSLog(@"before:%f,%f",self.tableView.frame.size.height,self.tableView.frame.origin.y);
    
    [UIView commitAnimations];
}

// scroll tableview
-(void)keyboardDidChangeFrame:(NSNotification*)notification{
    // Get the keyboard rect
    CGRect kbBeginrect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect kbEndrect   = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // animate when up or need scroll
    if (kbEndrect.origin.y < kbBeginrect.origin.y || scrollNeeded) {
        [self.tableView layoutIfNeeded];    // important! recompute size of tableview
        [self ScrollToBottom];
    }
    isAnimating = false;
}

// keyboard dismiss
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// keyboard dismiss
- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
