//
//  BanbenxinxiVC.m
//  找地儿
//
//  Created by Ibokan on 12-11-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanbenxinxiVC.h"

@implementation BanbenxinxiVC
@synthesize myScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc{
    [myScrollView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationController.navigationBarHidden=YES;
//    UIImageView *topView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
//    topView.image=[UIImage imageNamed:@"标题栏bg.png"];
//    topView.userInteractionEnabled=YES;
//    UIImageView *imv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"标题栏-logo.png"]];
//    imv.frame=CGRectMake(100, 5, 100, 38);
//    [topView addSubview:imv];
//    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame=CGRectMake(0, 0, 50, 44);
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:leftBtn];
//    [self.view addSubview:topView];
    
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
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 600)];
    imageView.image=[UIImage imageNamed:@"ios about-1.1.0.png"];
    [myScrollView addSubview:imageView];
    [imageView release];
    self.myScrollView.contentSize=imageView.frame.size;
    // Do any additional setup after loading the view from its nib.
}

-(void)fanhui
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setMyScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
