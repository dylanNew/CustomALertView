//
//  ViewController.m
//  CustomAlertView
//
//  Created by udspj on 14-9-15.
//  Copyright (c) 2014年 Wangdi. All rights reserved.
//

#import "ViewController.h"

#import "SVProgressHUD.h"
#import "CustomAlertView.h"
@interface ViewController ()<CustomAlertViewDelegate>
@property (nonatomic, strong) CustomAlertView *alertView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self.view setBackgroundColor:[UIColor grayColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAlertView:(id)sender
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\n\n" message:@"\n\n" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
////    [alert setBackgroundColor:[UIColor whiteColor]];
//    [alert show];

//    [SVProgressHUD showWithStatus:@"test" maskType:SVProgressHUDMaskTypeBlack];
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"少年，打开您的蓝牙\n获取该商场的独家优惠折扣信息\n省钱有省心哦" message:@"每个楼层都有惊喜哦" image:[UIImage imageNamed:@"Icon-120.png"] delegate:self buttons:@[@"其设置可吧"]];
    [alert showAlertView];
    
}

- (void)customAlertView:(CustomAlertView *)alertView didClickWithIndex:(NSInteger)index
{
    NSLog(@"%i is clicked",index);
}
@end
