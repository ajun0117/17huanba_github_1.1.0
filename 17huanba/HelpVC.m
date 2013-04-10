//
//  HelpVC.m
//  找地儿
//
//  Created by Ibokan on 12-11-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HelpVC.h"
#import "Fenlei.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@implementation HelpVC
@synthesize helpScrollView;
@synthesize shouyeViewController;
@synthesize messageVC,zhuyeVC;
@synthesize pageC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [helpScrollView release];
    [shouyeViewController release];
    [messageVC release];
    [zhuyeVC release];
    [pageC release];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.helpScrollView = nil;
    self.shouyeViewController = nil;
    self.messageVC = nil;
    self.zhuyeVC = nil;
    self.pageC = nil;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor=[UIColor blackColor];
    self.helpScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, KDeviceHeight-20)];
    helpScrollView.pagingEnabled=YES;
    helpScrollView.delegate = self;
    helpScrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i=0; i<4; i++) {
        UIImageView *imv=[[UIImageView alloc]initWithFrame:CGRectMake(0+320*i, 0, 320, KDeviceHeight-20)];
        if (iPhone5) {
            imv.image=[UIImage imageNamed:[NSString stringWithFormat:@"help_5_%d.png",i+1]];
        }
        else{
            imv.image=[UIImage imageNamed:[NSString stringWithFormat:@"help%d.png",i+1]];
        }
        imv.tag=100+i;
        imv.userInteractionEnabled=YES;
        [self.helpScrollView addSubview:imv];
    }
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    if (iPhone5) {
        button.frame=CGRectMake(90, 230, 150, 50);
    }
    else{
        button.frame=CGRectMake(90, 190, 150, 50);
    }
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [(UIImageView *)[self.helpScrollView viewWithTag:103] addSubview:button];
    
    helpScrollView.contentSize=CGSizeMake(320*4, KDeviceHeight-20);
    [self.view addSubview:helpScrollView];
    
    self.pageC = [[UIPageControl alloc]initWithFrame:CGRectMake(130, KDeviceHeight-20-75, 60, 20)];
    [self.view addSubview:pageC];
    pageC.numberOfPages = 4;
    pageC.currentPage = 0;
    [pageC release];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    pageC.currentPage = x/320;
    NSLog(@"%f",x);
}

-(void)dismiss
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        
        UINavigationController *shouyeNVC;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            self.shouyeViewController = [[[ShouYe alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
            shouyeViewController.tabBarItem = [[[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"home.png"] tag:0]autorelease];
            [shouyeViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"home_selected.png"] withFinishedUnselectedImage:nil];
            shouyeNVC = [[[UINavigationController alloc]initWithRootViewController:shouyeViewController]autorelease];
        } else {
            self.shouyeViewController = [[[ShouYe alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
            shouyeNVC = [[[UINavigationController alloc]initWithRootViewController:shouyeViewController]autorelease];
        }
        
        self.zhuyeVC = [[[Zhuye alloc]init]autorelease];
        zhuyeVC.tabBarItem = [[[UITabBarItem alloc]initWithTitle:@"个人主页" image:[UIImage imageNamed:@"geren.png"] tag:0]autorelease];
        [zhuyeVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"geren_selected.png"] withFinishedUnselectedImage:nil];
        UINavigationController *zhuyeNVC = [[[UINavigationController alloc]initWithRootViewController:zhuyeVC]autorelease];
        
        UIViewController *fabuVC = [[UIViewController alloc]init];
        fabuVC.tabBarItem = [[[UITabBarItem alloc]initWithTitle:nil image:nil tag:0]autorelease];
        
        Fenlei *fenleiVC = [[[Fenlei alloc]init]autorelease];
        fenleiVC.tabBarItem = [[[UITabBarItem alloc]initWithTitle:@"分类" image:[UIImage imageNamed:@"fenlei.png"] tag:0]autorelease];
        [fenleiVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"fenlei_selected.png"] withFinishedUnselectedImage:nil];
        UINavigationController *fenleiNVC = [[[UINavigationController alloc]initWithRootViewController:fenleiVC]autorelease];
        
        self.messageVC = [[Message alloc]init];
        messageVC.tabBarItem = [[[UITabBarItem alloc]initWithTitle:@"私信" image:[UIImage imageNamed:@"sixin.png"] tag:0]autorelease];
        [messageVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"sixin_selected.png"] withFinishedUnselectedImage:nil];
        UINavigationController *messageNVC = [[[UINavigationController alloc]initWithRootViewController:messageVC]autorelease];
        
        NSArray *array = [NSArray arrayWithObjects:shouyeNVC,zhuyeNVC,fabuVC,fenleiNVC,messageNVC, nil];
        [shouyeNVC release];
        [zhuyeNVC release];
        [fabuVC release];
        [fenleiNVC release];
        [messageNVC release];
        BaseViewController *tabC = [[BaseViewController alloc]init];
        tabC.viewControllers = array;
        
        [tabC addCenterButtonWithImage:[UIImage imageNamed:@"camera.png"] highlightImage:nil];
        
        BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue];
        if (isLogin) {
            [self getMessageCount];
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:tabC animated:YES];
        [tabC release];
    }
    else{
        self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;//渐变动画效果
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)getMessageCount{
    BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue];
    if (isLogin) { //如果已登陆
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Countmsg.html")];
        ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
        [form_request setDelegate:self];
        //    [form_request setPostValue:gdid forKey:@"id"];
        [form_request setPostValue:token forKey:@"token"];
        [form_request setDidFinishSelector:@selector(finishGetMessageCount:)];
        [form_request setDidFailSelector:@selector(loginFailed:)];
        [form_request startSynchronous];
    }
}

-(void)finishGetMessageCount:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"MsgCount str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSString *messageCount = [dic objectForKey:@"count"];
    if ([messageCount intValue] > 0) {
        messageVC.tabBarItem.badgeValue = messageCount;
    }
    [self getFriendCount];
}

-(void)getFriendCount{ //获取好友申请通知的个数
    BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue];
    if (isLogin) { //如果已登陆
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Countfd.html")];
        ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
        [form_request setDelegate:self];
        //    [form_request setPostValue:gdid forKey:@"id"];
        [form_request setPostValue:token forKey:@"token"];
        [form_request setDidFinishSelector:@selector(finishGetFriendCount:)];
        [form_request setDidFailSelector:@selector(loginFailed:)];
        [form_request startSynchronous];
    }
}

-(void)finishGetFriendCount:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"FriendCount str    is   %@",str);
    
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSString *friendCount = [dic objectForKey:@"count"];
    if ([friendCount intValue] > 0) {
        zhuyeVC.tabBarItem.badgeValue = friendCount;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
