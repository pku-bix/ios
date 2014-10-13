//
//  personInfoViewController.m
//  bix
//
//  Created by dsx on 14-10-13.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "personInfoViewController.h"
#import "CaptureViewController.h"
#import "generalTableView.h"

@interface personInfoViewController ()

@end

@implementation personInfoViewController
{
    UIImageView *imageView;
    CGRect rect;
    UITableView *_tableView;
//    generalTableView *personInfo_generalTableView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rect = [[UIScreen mainScreen]bounds];
    
//    personInfo_generalTableView = [[generalTableView alloc]init];
    
    NSArray * array = [[NSArray alloc]initWithObjects:@"头像", @"名字",@"个性签名", nil];
    NSArray * array2 = [[NSArray alloc]initWithObjects:@"个人ID", @"微信号", @"Tesla车型", nil];
    
    //    self.list = array;
    //    self.list2 = array2;
    
//    personInfo_generalTableView.list = array;
//    personInfo_generalTableView.list2 = array2;
    self.list = array;
    self.list2 = array2;
    
    //用代码来创建 tableview, tableview的高度需要设置成rect.size.height-navigationbar的高度，才不会出现滚动到最下面的行又自动滚动回前面。
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 50, rect.size.width, rect.size.height-100) style:UITableViewStyleGrouped];
    //    table_View.contentSize = CGSizeMake(320, 2000);
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    //设置 dataSource 和 delegate 这两个代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    //不用时，置nil
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}


#pragma mark dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return [general_TableView numberOfSectionsInTableView];
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [general_TableView numberOfRowsInSection:section];
    if (section == 0)
    {
        return [self.list count];
    }
    else
    {
        return [self.list2 count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [general_TableView tableView:tableView cellForRowAtIndexPath:indexPath];
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault  //cell的风格会决定下面cell.detailTextLabel.text是否有效，以及效果是怎么样的。
                reuseIdentifier:TableSampleIdentifier];
    }
    
    UIImage *image = [UIImage imageNamed:@"superChargerPile_90"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0,0.0,image.size.width,image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
  
    
//    UIImage *image0 = [UIImage imageNamed:@"personInfo"];
    NSUInteger row = [indexPath row];
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.list objectAtIndex:row];
        if (row == 0) {
//            cell.accessoryView = image0;
            cell.accessoryView = button;
        }
    }
    else if(indexPath.section == 1)
    {
        cell.textLabel.text = [self.list2 objectAtIndex:row];
    }
    

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    NSLog(@"tableView.rowHeight is %f", tableView.rowHeight);
    return cell;
}
//
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
////    return [general_TableView titleForHeaderInSection:section];
//    
//}
//
//-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
////    return [general_TableView titleForFooterInSection:section];
//}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [general_TableView tableView:tableView heightForRowAtIndexPath:indexPath];
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        return tableView.rowHeight+35;
    }
    else
        return tableView.rowHeight;

}


#pragma mark delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [general_TableView didSelectRowAtIndexPath:indexPath setingViewController:self];
    if ((indexPath.section == 0)&&(indexPath.row == 0)) {
        UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [chooseImageSheet showInView:self.view];
 
    }
    //选中后的反显颜色即刻消失,即选中cell后，cell的高亮立刻消失；
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



#pragma mark UIActionSheetDelegate Method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    switch (buttonIndex) {
        case 0://Take picture
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            }else{
                NSLog(@"模拟器无法打开相机");
            }
            [self presentModalViewController:picker animated:YES];
            break;
            
        case 1://From album
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:picker animated:YES];
            break;
            
        default:
            
            break;
    }
}

#pragma 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    NSData *data;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        CaptureViewController *captureView = [[CaptureViewController alloc] init];
        captureView.delegate = self;
        captureView.image = image;
        //隐藏UIImagePickerController本身的导航栏
        picker.navigationBar.hidden = YES;
        [picker pushViewController:captureView animated:YES];
        
    }
}

#pragma mark - 图片回传协议方法
-(void)passImage:(UIImage *)image
{
    imageView.image = image;
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
