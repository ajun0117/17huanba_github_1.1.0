//
//  AppDelegate.m
//  17huanba
//
//  Created by Chen Hao on 13-1-16.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "Zhuye.h"
#import "Fabu.h"
#import "Fenlei.h"
//#import "Message.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "HelpVC.h"

@implementation AppDelegate
@synthesize window,shouyeViewController,messageVC;
@synthesize zhuyeVC;

- (void)dealloc
{
    [window release];
    [shouyeViewController release];
    [messageVC release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    //判断程序是否是第一次使用
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]/*如果不是第二次使用*/) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];//设置第二次使用的value值为yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];//设置第一次使用的value值为yes
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        HelpVC *helpv = [[[HelpVC alloc] init] autorelease];
        [self.window setRootViewController:helpv];
    }
    else {
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
    self.window.rootViewController = tabC;
        [tabC release];
        
    BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue];
        if (isLogin) {
            [self getMessageCount];
        }
    }
    
    
    [self.window makeKeyAndVisible];
    
   
    return YES;
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



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
