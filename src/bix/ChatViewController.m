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
#import "ChatMessage.h"

@interface ChatViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vsToolbar;
- (IBAction)Tap:(id)sender;

@end


@implementation ChatViewController

// app scope object
AppDelegate* appdelegate;

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(commitKeyboardAnimations:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(commitKeyboardAnimations:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(updateList:)
                                                 name:EVENT_MESSAGE_RECEIVED    object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(updateList:)
                                                 name:EVENT_MESSAGE_SENT    object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [self updateList:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification   object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification   object:nil];
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
    [self.tableView reloadData];
    [self ScrollToBottom];
}

- (void) ScrollToBottom{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height){
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
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

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    self.vsToolbar.constant = kbFrame.CGRectValue.size.height;
    [self.view layoutIfNeeded];
    [self ScrollToBottom];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    self.vsToolbar.constant = 0;
    [self.view layoutIfNeeded];
    [self ScrollToBottom];
}

- (void)commitKeyboardAnimations:(NSNotification *)notification {
    [UIView commitAnimations];
}


// 结束输入，关闭软键盘，并执行发送
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textView) {
        
        NSString *message = self.textView.text;
        if (message.length == 0) return YES;
        
        [appdelegate.chatter send:self.session.remoteJid Message:message];
        
        self.textView.text = @"";
        //[self.textView resignFirstResponder];
    }
    return YES;
}

// keyboard dismiss
- (IBAction)Tap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil from:nil forEvent:nil];
}

@end
