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
#import "Message.h"
#import "MessageCell.h"
#import "NSDate+Wrapper.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

AppDelegate* appdelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateList:)
     name:EVENT_MESSAGE_RECEIVED
     object:nil];
    [self.tableView reloadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:EVENT_MESSAGE_RECEIVED
     object:nil];
}

- (void) updateList: (NSNotification*) notification
{
    [self.tableView reloadData];
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
    
    return [str boundingRectWithSize:textSize
                             options:NSStringDrawingUsesLineFragmentOrigin//NSStringDrawingUsesFontLeading|
                          attributes:@{}//@{NSFontAttributeName: [UIFont  boldSystemFontOfSize:13]}
                             context: nil].size;
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
    Message* msg = [self.session.msgs objectAtIndex:indexPath.row];
    
    
    // msg text
    cell.msgTextView.text = msg.text;
    
    // msg time
    cell.timeInfo.text = [msg.time toString];
    [cell.timeInfo sizeToFit];
    cell.timeInfo.center = CGPointMake(self.view.frame.size.width/2, MARGIN_TIMEINFO);

    
    // msg img
    CGSize size = [self getTextSize:msg.text];
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

//每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Message* msg = [self.session.msgs objectAtIndex:indexPath.row];
    
    CGSize size = [self getTextSize:msg.text];
    
    int margin_msg_top = MARGIN_MSG_TOP + MARGIN_TIMEINFO;
    return size.height + PADDING_MSG_TOP + PADDING_MSG_BOTTOM + margin_msg_top;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
