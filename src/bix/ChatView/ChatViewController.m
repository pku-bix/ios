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
#import "ChatMessage.h"

@interface ChatViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textView;
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
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = [NSString stringWithFormat: @"%@", self.session.remoteJid.user];
    
    [self updateList:nil];
    
    // viewsize update event
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(KeyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(updateList:)
                                                 name:EVENT_MESSAGE_RECEIVED    object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(updateList:)
                                                 name:EVENT_MESSAGE_SENT    object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidChangeFrameNotification   object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_MESSAGE_RECEIVED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_MESSAGE_SENT object:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateList: (NSNotification*) notification{
//    [UIView animateWithDuration:0 animations:^{
//        [self.tableView reloadData];
//    } completion:^(BOOL finished) {
//        
//        if (isAnimating) {
//            scrollNeeded = YES;
//        }
//        else{
//            [self ScrollToBottom];
//        }
//    }];
    [self.tableView reloadData];
    [self ScrollToBottom];
}

- (void) ScrollToBottom{
    
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        
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
    ChatMessage* msg = [self.session.msgs objectAtIndex:indexPath.row];
    
    // set msg time
    int margin_msg_top = 0;
    
    if ([self.session msgExpiredAt:indexPath.row]) {
        cell.timeInfo.text = [msg.date toFriendlyString];
        [cell.timeInfo sizeToFit];
        cell.timeInfo.center = CGPointMake(self.view.frame.size.width/2,
                                               TIMEINFO_HEIGHT - cell.timeInfo.frame.size.height/2);
        margin_msg_top =MARGIN_MSG_TOP + TIMEINFO_HEIGHT;
    }
    else{
        [cell.timeInfo setHidden:true];
        margin_msg_top = MARGIN_MSG_TOP;
    }
    
    // set msg text
    cell.msgTextView.text = msg.body;
    
    CGSize size = [self getDisplaySize:msg.body];
    UIImage *bgImage = nil;

    if (msg.isMine) {
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
        
        bgImage = [[UIImage imageNamed:@"msg_sent-100.png"]
                   resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 10, 24)
                   resizingMode:UIImageResizingModeStretch];

    }else {
        [cell.msgTextView setFrame:CGRectMake(PADDING_MSG_SENDER + MARGIN_MSG_SENDER,
                                              margin_msg_top + PADDING_MSG_TOP,
                                              size.width,   size.height)];
        [cell.bgImageView setFrame:CGRectMake(MARGIN_MSG_SENDER,    margin_msg_top,
                                              size.width + PADDING_MSG_RECEIVER + PADDING_MSG_SENDER,
                                              size.height + PADDING_MSG_TOP + PADDING_MSG_BOTTOM)];
        
        bgImage = [[UIImage imageNamed:@"msg_received-100.png"]
                   resizableImageWithCapInsets:UIEdgeInsetsMake(6, 24, 10, 6)
                   resizingMode:UIImageResizingModeStretch];
    }
    cell.bgImageView.image = bgImage;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatMessage* msg = [self.session.msgs objectAtIndex:indexPath.row];

    CGSize size = [self getDisplaySize:msg.body];
    int margin_msg_top = MARGIN_MSG_TOP;
    if ([self.session msgExpiredAt:indexPath.row]) margin_msg_top += TIMEINFO_HEIGHT;
    
    return size.height + PADDING_MSG_TOP + PADDING_MSG_BOTTOM + margin_msg_top + MARGIN_MSG_BOTTOM;
}
-(CGSize) getDisplaySize:(NSString*) str{
    
    CGSize textSize = {self.view.frame.size.width
        - PADDING_MSG_RECEIVER - PADDING_MSG_SENDER - MARGIN_MSG_RECEIVER- MARGIN_MSG_SENDER,   INTMAX_MAX};
    
    CGSize size = [str boundingRectWithSize:textSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                                    context: nil].size;
    return size;
}



#pragma mark - Keyboard related

// generate animation when keyboard will change
-(void)KeyboardWillChangeFrame: (NSNotification *)notification {
    isAnimating = YES;
    
    // Get the keyboard rect
    CGRect kbBeginrect = [[[notification userInfo]
                           objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect kbEndrect   = [[[notification userInfo]
                           objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[[notification userInfo]
                                objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[[notification userInfo]
                                                        objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    // set animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    
    // calculate frame rect
    CGRect rect = self.view.frame;
    double height_change = kbEndrect.origin.y - kbBeginrect.origin.y;
    rect.size.height += height_change;
    self.view.frame = rect;
    
    // scroll msgs when up or need scroll
    //if (kbEndrect.origin.y < kbBeginrect.origin.y || scrollNeeded) {
        [self.tableView layoutIfNeeded];    // important! recompute size of tableview
        [self ScrollToBottom];
    //}
}

// commit animation & scroll tableview
-(void)keyboardDidChangeFrame:(NSNotification*)notification{
    
    [UIView commitAnimations];  // commit animation
    isAnimating = false;
}

// 结束输入
// 关闭软键盘，并执行发送
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textView) {
        [textField resignFirstResponder];

        NSString *message = self.textView.text;
        if (message.length == 0) return YES;
        
        [appdelegate.xmppStream send:self.session.remoteJid Message:message];
        
        self.textView.text = @"";
        [self.textView resignFirstResponder];
    }
    return YES;
}

// keyboard dismiss
- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil from:nil forEvent:nil];
}

@end
