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
    [self.session open];
    
    self.navigationItem.title = [NSString stringWithFormat: @"%@", self.session.peerAccount.username];
    
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

// 必须在此方法中进行UI调整，相关方法区别如下：

// viewWillAppear: 此时子view将被添加到根view，当然这是constraints未生效（于是这是tableview高度是不对的，不能滚动到正确的位置）。
// viewDidAppear: 此时子view已经全部添加，并且布局完毕。这时view已经展示给用户，UI调整过程会被用户看到。
// viewDidLayoutSubviews: 发生在前两者之间，子view已布局完毕，但还没有呈现给用户。
-(void)viewDidLayoutSubviews{
    [self.tableView reloadData];
    [self ScrollToBottomAnimated:NO];
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
    [self ScrollToBottomAnimated:YES];
}

- (void) ScrollToBottomAnimated: (BOOL) animated{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height){
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
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
    int chat_head_space = 0;
    
    if ([self.session msgExpiredAt:indexPath.row]) {
        cell.timeInfo.text = [msg.date toFriendlyString];
       // NSLog(cell.timeInfo.text);
        [cell.timeInfo sizeToFit];
        cell.timeInfo.center = CGPointMake(self.view.frame.size.width/2,
                                               TIMEINFO_HEIGHT - cell.timeInfo.frame.size.height/2);
       // NSLog(@"TimeInfo Height %f", cell.timeInfo.frame.size.height);
        margin_msg_top =MARGIN_MSG_TOP + TIMEINFO_HEIGHT;
        chat_head_space = TIMEINFO_HEIGHT;
        [cell.timeInfo setHidden:NO];
    }
    else{
        [cell.timeInfo setHidden:true];
        margin_msg_top = MARGIN_MSG_TOP;
    }
    
    // set msg text
    cell.msgTextView.text = msg.body;
    
    CGSize size = [self getDisplaySize:msg.body];
    UIImage *bgImage = nil;
    
    CGFloat bgWidth = size.width > 35.0 ? size.width : 35.0;
    CGFloat sendTextWidth = size.width > 35.0 ? size.width : (size.width + 35.0)/2.0;
    CGFloat receiveTextWidth = size.width > 35.0 ? 0.0 : (35.0 - size.width)/2.0;
    
    if (msg.isMine) {
        [cell.msgTextView setFrame:
         CGRectMake(self.view.frame.size.width - sendTextWidth - PADDING_MSG_SENDER - MARGIN_MSG_SENDER - CHAT_HEAD_SHOW_SIZE*12/13- CHAT_HEAD_SHOW_PADDING_LEFT - CHAT_HEAD_SHOW_PADDING_RIGHT,
                    margin_msg_top + PADDING_MSG_TOP+4,
                    size.width,
                    size.height)];

        [cell.bgImageView setFrame:
         CGRectMake(self.view.frame.size.width - bgWidth - MARGIN_MSG_SENDER - PADDING_MSG_SENDER - PADDING_MSG_RECEIVER - CHAT_HEAD_SHOW_SIZE*4/5 - CHAT_HEAD_SHOW_PADDING_LEFT - CHAT_HEAD_SHOW_PADDING_RIGHT,
                    margin_msg_top,
                    bgWidth + PADDING_MSG_RECEIVER + PADDING_MSG_SENDER,
                    size.height + PADDING_MSG_TOP + PADDING_MSG_BOTTOM)];
        
        [cell.chatHeadShow setFrame:
         CGRectMake(self.view.frame.size.width - MARGIN_MSG_SENDER - CHAT_HEAD_SHOW_SIZE - CHAT_HEAD_SHOW_PADDING_LEFT - CHAT_HEAD_SHOW_PADDING_RIGHT,
                    //self.view.frame.size.width - CHAT_HEAD_SHOW_SIZE - CHAT_HEAD_SHOW_PADDING_LEFT - CHAT_HEAD_SHOW_PADDING_RIGHT,
                    cell.bgImageView.frame.size.height-CHAT_HEAD_SHOW_SIZE+chat_head_space - 3,
                    CHAT_HEAD_SHOW_SIZE,
                    CHAT_HEAD_SHOW_SIZE)];
        cell.chatHeadShow.image = [UIImage imageNamed:@"head_show.jpeg"];
        cell.chatHeadShow.layer.masksToBounds = YES;
        cell.chatHeadShow.layer.cornerRadius = CHAT_HEAD_SHOW_SIZE / 2;
        
        bgImage = [[UIImage imageNamed:@"msg_sent_HEMI-100.png"]
                   resizableImageWithCapInsets:UIEdgeInsetsMake(17, 20, 22, 44)
                   resizingMode:UIImageResizingModeStretch];

    }else {
        [cell.msgTextView setFrame:CGRectMake(PADDING_MSG_SENDER + MARGIN_MSG_SENDER + CHAT_HEAD_SHOW_PADDING_LEFT + CHAT_HEAD_SHOW_SIZE*7/8 + CHAT_HEAD_SHOW_PADDING_RIGHT+receiveTextWidth,
                                              margin_msg_top + PADDING_MSG_TOP +4,
                                              size.width,   size.height)];
        [cell.bgImageView setFrame:CGRectMake(MARGIN_MSG_SENDER + CHAT_HEAD_SHOW_PADDING_LEFT + CHAT_HEAD_SHOW_SIZE*2/3+1 + CHAT_HEAD_SHOW_PADDING_RIGHT,
                                              margin_msg_top,
                                              bgWidth + PADDING_MSG_RECEIVER + PADDING_MSG_SENDER,
                                              size.height + PADDING_MSG_TOP + PADDING_MSG_BOTTOM)];
        
        [cell.chatHeadShow setFrame:
         CGRectMake(MARGIN_MSG_SENDER + CHAT_HEAD_SHOW_PADDING_LEFT + CHAT_HEAD_SHOW_PADDING_LEFT,
                    cell.bgImageView.frame.size.height-CHAT_HEAD_SHOW_SIZE+chat_head_space - 3,
                    CHAT_HEAD_SHOW_SIZE,
                    CHAT_HEAD_SHOW_SIZE)];
        cell.chatHeadShow.image = [UIImage imageNamed:@"head_show.jpeg"];
        cell.chatHeadShow.layer.masksToBounds = YES;
        cell.chatHeadShow.layer.cornerRadius = CHAT_HEAD_SHOW_SIZE / 2;
        
        bgImage = [[UIImage imageNamed:@"msg_received_HEMI-100.png"]
                   resizableImageWithCapInsets:UIEdgeInsetsMake(17, 44, 25, 20)
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
        - PADDING_MSG_RECEIVER - PADDING_MSG_SENDER - MARGIN_MSG_RECEIVER- MARGIN_MSG_SENDER - CHAT_HEAD_SHOW_SIZE - CHAT_HEAD_SHOW_PADDING_LEFT - CHAT_HEAD_SHOW_PADDING_RIGHT,   INTMAX_MAX};
    
    CGSize size = [str boundingRectWithSize:textSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}
                                    context: nil].size;
    CGSize _textSize = CGSizeMake(size.width, size.height+6);
    return _textSize;
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
    [self ScrollToBottomAnimated:YES];
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
    [self ScrollToBottomAnimated:YES];
}

- (void)commitKeyboardAnimations:(NSNotification *)notification {
    [UIView commitAnimations];
}


// 结束输入，关闭软键盘，并执行发送
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textView) {
        
        NSString *message = self.textView.text;
        if (message.length == 0) return YES;
        
        [[bixChatProvider defaultChatProvider] send:self.session.peerAccount Message:message];
        
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
