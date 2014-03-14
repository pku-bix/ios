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

@end

@implementation ChatViewController

AppDelegate* appdelegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
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
    
    //self.navigationController.toolbarHidden = NO;
}

- (void) updateList: (NSNotification*) notification
{
    [self.tableView reloadData];
    
    // scroll to bottom
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.session.msgs count];
}


// get display size of str

- (CGSize) getTextSize:(NSString*) str{
    
    CGSize textSize = {self.view.frame.size.width
        - PADDING_MSG_RECEIVER - PADDING_MSG_SENDER - MARGIN_MSG_RECEIVER- MARGIN_MSG_SENDER,
        INTMAX_MAX};
    
    //NSLog(@"%f", textSize.width);
    CGSize size = [str boundingRectWithSize:textSize
                             options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                             context: nil].size;
    return size;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    
    // msg text
    cell.msgTextView.text = msg.body;
    
    // msg time
    cell.timeInfo.text = [msg.time toString];
    [cell.timeInfo sizeToFit];
    cell.timeInfo.center = CGPointMake(self.view.frame.size.width/2,
                                       MARGIN_TIMEINFO - cell.timeInfo.frame.size.height/2);

    
    // msg img
    CGSize size = [self getTextSize:msg.body];
    UIImage *bgImage = nil;
    
    //NSLog(@"ss%f", size.width);
    
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

//每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XMPPMessage* msg = [self.session.msgs objectAtIndex:indexPath.row];
    
    CGSize size = [self getTextSize:msg.body];
    
    int margin_msg_top = MARGIN_MSG_TOP + MARGIN_TIMEINFO;
    return size.height + PADDING_MSG_TOP + PADDING_MSG_BOTTOM + margin_msg_top + MARGIN_MSG_BOTTOM;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)Send:(id)sender {
    
    //本地输入框中的信息
    NSString *message = self.textView.text;
    
    if (message.length == 0) return;
    
    [appdelegate.xmppStream send:self.session.remoteJid Message:message];
    self.textView.text = @"";
    [self.textView resignFirstResponder];
}

-(void)keyboardWillShow: (NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    
    // Animate the current view out of the way
    [self setViewMovedUp:YES Offset:keyboardRect.size.height];
}

-(void)keyboardWillHide: (NSNotification *)notification{
   
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    [self setViewMovedUp:NO Offset:keyboardRect.size.height];
}

/*-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.textView])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}*/

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp Offset:(int)offset
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        //rect.origin.y -= offset;
        rect.size.height -= offset;
    }
    else
    {
        //rect.origin.y += offset;
        rect.size.height += offset;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = [NSString stringWithFormat: @"%@", self.session.bareJid];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    // message update
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_MESSAGE_RECEIVED
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EVENT_MESSAGE_SENT
                                                  object:nil];
}

// keyboard dismiss
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
@end
