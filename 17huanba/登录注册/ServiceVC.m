//
//  ServiceVC.m
//  一起换吧
//
//  Created by Chen Hao on 13-4-18.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "ServiceVC.h"

@interface ServiceVC ()

@end

@implementation ServiceVC
@synthesize myScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [myScrollView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame = CGRectMake(0, 0, kDeviceWidth, 44);
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 10, 57, 27);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_gray_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    UILabel *nameL=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 120, 24)];
    nameL.font=[UIFont systemFontOfSize:17];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = UITextAlignmentCenter;
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"关于一起换吧";
    [navIV addSubview:nameL];
    [nameL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-20-44)];
    [self.view addSubview:myScrollView];
    [myScrollView release];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 3335)];
    imageView.image=[UIImage imageNamed:@"服务条款.png"];
    [myScrollView addSubview:imageView];
    [imageView release];
    self.myScrollView.contentSize=imageView.frame.size;
}

-(void)fanhui
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
