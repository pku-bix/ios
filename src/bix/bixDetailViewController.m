//
//  detailViewController.m
//  bix
//
//  Created by dsx on 14-10-1.
//  Copyright (c) 2014年 bix. All rights reserved.
//

#import "bixDetailViewController.h"
#import "Constants.h"
#import "bixSuperCharger.h"
#import "bixHomeCharger.h"
#import "bixDestCharger.h"

@interface bixDetailViewController ()

@end

@implementation bixDetailViewController


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
    
    self.chargerAddress.font = [UIFont systemFontOfSize:16];
    self.chargerAddress.selectable = NO;
    self.chargerAddress.editable = NO;
    self.chargerAddress.scrollEnabled = NO;
    
    self.charger.observer = self;
    [self.charger pull];
}

-(void)modelUpdated:(id)model{
    
    self.chargerType.text = [[self.charger class] description];
    self.chargerParkingnum.text = [NSString stringWithFormat:@"%d", self.charger.parkingnum ];
    self.chargerAddress.text =self.charger.address;
    self.chargerInfo.text = [self chargerInfoString];
}

-(NSString*) chargerInfoString{
    if ([self.charger isKindOfClass:[bixDestCharger class]]) {
        bixDestCharger* c = (bixDestCharger*)self.charger;
        
        return c.comment;
    }
    else if ([self.charger isKindOfClass:[bixSuperCharger class]]){
        bixSuperCharger* c=(bixSuperCharger*)self.charger;
        
        return c.hours;
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
