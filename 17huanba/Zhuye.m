//
//  Zhuye.m
//  17huanba
//
//  Created by Chen Hao on 13-1-25.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Zhuye.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "FriendsTimeLine.h" //好友动态
#import "FindYourFriends.h"
#import "MyTanwei.h"
#import "Caogaoxiang.h"
#import "Shoucang.h"
#import "Contacted.h"
#import "Viewed.h"
#import "Message.h"
#import "Sets.h"
#import "Denglu.h"
#import "Gouwuche.h"
#import "FindYourFriends.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "EditGerenXinxi.h"
#import "Lianxifangshi.h"
#import "Address.h"
#import "SVProgressHUD.h"

@interface Zhuye ()

@end

@implementation Zhuye
@synthesize personTableView;
@synthesize exitBtn;
@synthesize exitAlert;
@synthesize head;
@synthesize nameL;
@synthesize QQL;
@synthesize shoujiIV,shenfenIV;

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
    [personTableView release];
    [exitBtn release];
    [exitAlert release];
    RELEASE_SAFELY(head);
    RELEASE_SAFELY(nameL);
    RELEASE_SAFELY(QQL);
    RELEASE_SAFELY(shoujiIV);
    RELEASE_SAFELY(shenfenIV);
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.personTableView = nil;
    self.exitBtn = nil;
    self.exitAlert = nil;
    RELEASE_SAFELY(head);
    RELEASE_SAFELY(nameL);
    RELEASE_SAFELY(QQL);
    RELEASE_SAFELY(shoujiIV);
    RELEASE_SAFELY(shenfenIV);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIView *button = [self.tabBarController.view viewWithTag:100];//找出tabar中间的相机Button
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 1;
    }];
    [self getMessageCount];
}

#pragma mark - 获取badgeValue的值
-(void)getMessageCount{ //获取未读消息的个数
    BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue];
    if (isLogin) { //如果已登陆
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Countmsg.html")];
        ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
        [form_request setDelegate:self];
        //    [form_request setPostValue:gdid forKey:@"id"];
        [form_request setPostValue:token forKey:@"token"];
        [form_request setDidFinishSelector:@selector(finishGetMessageCount:)];
        [form_request setDidFailSelector:@selector(loginMessageCountFailed:)];
        [form_request startAsynchronous];
    }
}

-(void)finishGetMessageCount:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"MessageCount str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSString *messageCount = [dic objectForKey:@"count"];
    if ([messageCount intValue] > 0) {
        Message *messageVC = [self.tabBarController.viewControllers objectAtIndex:4];
        messageVC.tabBarItem.badgeValue = messageCount;
    }
    
    [self getFriendCount]; //发起好友申请通知的个数的请求
}

-(void)loginMessageCountFailed:(ASIHTTPRequest *)request{
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"失败   %@",str);
    [str release];
    [SVProgressHUD dismissWithError:@"请检查网络连接后重试！"];
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
        [form_request startAsynchronous];
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
        self.tabBarItem.badgeValue = friendCount;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    BOOL *isLogined = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue]; //检测是否为已登录
    if (isLogined) {
        [self userMessage];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您还没有登陆，登陆后继续！" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是",nil];
        [alert show];
        [alert release];
    }
    exitBtn.selected = isLogined;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
//    BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue]; //检测是否为已登录
    
    UIImageView *navIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame = CGRectMake(0, 0, 320, 44);
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 10, 57, 27);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"setting_btn_gray.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(toSetsVC) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    self.exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(258, 10, 57, 27);
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    [exitBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [exitBtn setTitle:@"注销" forState:UIControlStateSelected];
    [exitBtn addTarget:self action:@selector(toLoginOrExit:) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:exitBtn];
//    exitBtn.selected = isLogin; //根据登录状态显示按钮文本
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 80, 24)];
    titleL.font = [UIFont boldSystemFontOfSize:17];
    titleL.backgroundColor=[UIColor clearColor];
    titleL.textColor = [UIColor whiteColor];
    titleL.text = @"个人中心";
    [navIV addSubview:titleL];
    [titleL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    UIImageView *headIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 60)];
    headIV.image = [UIImage imageNamed:@"page_top_bg.png"];
    headIV.userInteractionEnabled = YES;
    [self.view addSubview:headIV];
    [headIV release];
    
    self.head = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 5, 45, 45)];
    [head addTarget:self action:@selector(toBigHead:) forControlEvents:UIControlEventTouchUpInside];
    head.layer.cornerRadius = 10;
    head.clipsToBounds = YES;
    head.image = DEFAULTIMG;
    [headIV addSubview:head];
    [head release];
    
    self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 180, 20)];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.font = [UIFont boldSystemFontOfSize:17];
    nameL.textColor = [UIColor blackColor];
    [headIV addSubview:nameL];
    [nameL release];
    
    self.QQL = [[UILabel alloc]initWithFrame:CGRectMake(60, 35, 200, 20)];
    QQL.backgroundColor = [UIColor clearColor];
    QQL.font = [UIFont systemFontOfSize:15];
    QQL.textColor = [UIColor whiteColor];
    [headIV addSubview:QQL];
    [QQL release];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(250, 10, 45, 22);
    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editGerenXinxi) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"page_edit_btn.png"] forState:UIControlStateNormal];
    [headIV addSubview:editBtn];
    
    UIImageView *renzhengIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44+60, 320, 30)]; //显示认证方式
    renzhengIV.image = [UIImage imageNamed:@"identity_bg.png"];
    [self.view addSubview:renzhengIV];
    [renzhengIV release];
    
    UIImageView *emailIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 3, 24, 24)];
    emailIV.image = [UIImage imageNamed:@"identity_email.png"];
    [renzhengIV addSubview:emailIV];
    [emailIV release];
    
    self.shoujiIV = [[UIImageView alloc]initWithFrame:CGRectMake(44, 3, 24, 24)];
    shoujiIV.image = [UIImage imageNamed:@"identity_tel_gray.png"];
    [renzhengIV addSubview:shoujiIV];
    [shoujiIV release];
    
    self.shenfenIV = [[UIImageView alloc]initWithFrame:CGRectMake(78, 3, 24, 24)];
    shenfenIV.image = [UIImage imageNamed:@"identity_ID_gray.png"];
    [renzhengIV addSubview:shenfenIV];
    [shenfenIV release];
    
    self.personTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+60+30, kDeviceWidth, KDeviceHeight-20-44*2-60-30) style:UITableViewStyleGrouped];
    personTableView.delegate = self;
    personTableView.dataSource = self;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    personTableView.backgroundView = view;
    [view release];
    
    [self.view addSubview:personTableView];
    [personTableView release];
}

-(void)userMessage{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Usinfo.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:token forKey:@"token"];
    [form_request setDidFinishSelector:@selector(finishGetUserMessage:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}


-(void)finishGetUserMessage:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"userInformation  str   is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    NSString *headStr = [dic objectForKey:@"headimg"];
    if (![headStr isEqualToString:@" "]){
        head.urlString = THEURL(headStr);
    }
    NSString *nameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"uname"];
    nameL.text = nameStr;
    NSString *qqStr = [dic objectForKey:@"connectemail"];
    QQL.text = [NSString stringWithFormat:@"Email:%@",qqStr];
    
    int identity = [[dic objectForKey:@"identity"] intValue];
    if (identity == 2) {
        shenfenIV.image = [UIImage imageNamed:@"identity_ID.png"];
    }
    else{
        shenfenIV.image = [UIImage imageNamed:@"identity_ID_gray.png"];
    }

    int tel_indentity = [[dic objectForKey:@"tel_indentity"] intValue];
    if (tel_indentity == 1) {
        shoujiIV.image = [UIImage imageNamed:@"identity_tel.png"];
    }
    else{
        shoujiIV.image = [UIImage imageNamed:@"identity_tel_gray.png"];
    }
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
}


-(void)editGerenXinxi{
    BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue];
    if (isLogin) { //如果已登陆
        EditGerenXinxi *gerenXinxiVC = [[EditGerenXinxi alloc]init];
        gerenXinxiVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gerenXinxiVC animated:YES];
        [gerenXinxiVC release];
        
    //    PresonXinxi *gerenXinxiVC = [[PresonXinxi alloc]init];
    //    gerenXinxiVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:gerenXinxiVC animated:YES];
    //    [gerenXinxiVC release];
        
        UIView *button = [self.tabBarController.view viewWithTag:100];//找出tabar中间的相机Button
        //    button.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            button.alpha = 0;
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您还没有登陆，登陆后继续！" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是",nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    else if(section == 1){
        return 4;
    }
    else{
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *moreIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_more_0.png"]];
    cell.accessoryView = moreIV;
    [moreIV release];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"page_list_bg.png"]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            cell.imageView.image = [UIImage imageNamed:@"page_list_1_0.png"];
            cell.textLabel.text = @"好友动态";
        }
        else if(indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"page_list_2_0.png"];
            cell.textLabel.text = @"我的好友";
        }
        else if(indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"page_list_3_0.png"];
            cell.textLabel.text = @"私信";
        }
    }
    else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"page_list_4_0.png"];
            cell.textLabel.text = @"我的摊位";
        }
//        else if(indexPath.row == 1) {
//            cell.imageView.image = [UIImage imageNamed:@"page_list_5_0.png"];
//            cell.textLabel.text = @"草稿箱";
//        }
        else if(indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"page_list_6_0.png"];
            cell.textLabel.text = @"我的收藏";
        }
//        else if(indexPath.row == 3) {
//            cell.imageView.image = [UIImage imageNamed:@"page_list_7_0.png"];
//            cell.textLabel.text = @"联系过的宝贝";
//        }
        else if(indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"page_list_8_0.png"];
            cell.textLabel.text = @"浏览过的宝贝";
        }
//        else if(indexPath.row == 5) {
//            cell.imageView.image = [UIImage imageNamed:@"page_list_9_0.png"];
//            cell.textLabel.text = @"我的仓库";
//        }
//        else if(indexPath.row == 6) {
//            cell.imageView.image = [UIImage imageNamed:@"page_list_10_0.png"];
//            cell.textLabel.text = @"钱包管理";
//        }
        else if(indexPath.row == 3) {
            cell.imageView.image = [UIImage imageNamed:@"page_list_11_0.png"];
            cell.textLabel.text = @"我的购物车";
        }
    }
    else{
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"page_list_12_0.png"];
            cell.textLabel.text = @"个人信息";
        }
        else if(indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"page_list_13_0.png"];
            cell.textLabel.text = @"联系方式";
        }
        else if(indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"page_list_14_0.png"];
            cell.textLabel.text = @"收货地址";
        }
//        else if(indexPath.row == 3) {
//            cell.imageView.image = [UIImage imageNamed:@"page_list_15_0.png"];
//            cell.textLabel.text = @"手机绑定";
//        }
//        else if(indexPath.row == 4) {
//            cell.imageView.image = [UIImage imageNamed:@"page_list_16_0.png"];
//            cell.textLabel.text = @"身份认证";
//        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue];
    if (isLogin) { //如果已登陆
        if (indexPath.section == 0) {   //好友动态
            if (indexPath.row == 0) {
                    FriendsTimeLine *friendsTimeLineVC = [[FriendsTimeLine alloc]init];
                    friendsTimeLineVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:friendsTimeLineVC animated:YES];
                    friendsTimeLineVC.navigationController.navigationBarHidden = YES;
                    [friendsTimeLineVC release];
            }
            else if(indexPath.row == 1) {   //我的好友列表
                FindYourFriends *findFriendsVC = [[FindYourFriends alloc]init];
                findFriendsVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:findFriendsVC animated:YES];
                findFriendsVC.navigationController.navigationBarHidden = YES;
                [findFriendsVC release];
            }
            else if(indexPath.row == 2){    //私信
                Message *messageVC = [[Message alloc]init];
                messageVC.istabMessage = NO;
                messageVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:messageVC animated:YES];
                messageVC.navigationController.navigationBarHidden = YES;
                messageVC.backBtn.hidden = NO;  //从个人中心push出的私信页面才显示返回按钮
                [messageVC release];
            }
        }
        else if(indexPath.section == 1){
            if (indexPath.row == 0) {
                MyTanwei *tanweiVC = [[MyTanwei alloc]init];
                tanweiVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:tanweiVC animated:YES];
                tanweiVC.navigationController.navigationBarHidden = YES;
                [tanweiVC release];
            }
//            else if(indexPath.row == 1) {
//                Caogaoxiang *caogaoxiangVC = [[Caogaoxiang alloc]init];
//                caogaoxiangVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:caogaoxiangVC animated:YES];
//                caogaoxiangVC.navigationController.navigationBarHidden = YES;
//                [caogaoxiangVC release];
//            }
            else if(indexPath.row == 1) {
                Shoucang *shoucangVC = [[Shoucang alloc]init];
                shoucangVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shoucangVC animated:YES];
                shoucangVC.navigationController.navigationBarHidden = YES;
                [shoucangVC release];
            }
//            else if(indexPath.row == 3) {
//                Contacted *contactedVC = [[Contacted alloc]init];
//                contactedVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:contactedVC animated:YES];
//                contactedVC.navigationController.navigationBarHidden = YES;
//                [contactedVC release];
//            }
            else if(indexPath.row == 2) {
                Viewed *viewedVC = [[Viewed alloc]init];
                viewedVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewedVC animated:YES];
                viewedVC.navigationController.navigationBarHidden = YES;
                [viewedVC release];
            }
//            else if(indexPath.row == 5) {
//                Viewed *viewedVC = [[Viewed alloc]init];
//                viewedVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:viewedVC animated:YES];
//                viewedVC.navigationController.navigationBarHidden = YES;
//                [viewedVC release];
//            }
//            else if(indexPath.row == 6) {
//                Viewed *viewedVC = [[Viewed alloc]init];
//                viewedVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:viewedVC animated:YES];
//                viewedVC.navigationController.navigationBarHidden = YES;
//                [viewedVC release];
//            }
            else if(indexPath.row == 3) {
                Gouwuche *cartdVC = [[Gouwuche alloc]init];
                cartdVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cartdVC animated:YES];
                cartdVC.navigationController.navigationBarHidden = YES;
                [cartdVC release];
            }
    }
        else{
            if (indexPath.row == 0) {
                EditGerenXinxi *editGerenXinxiVC = [[EditGerenXinxi alloc]init];
                editGerenXinxiVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:editGerenXinxiVC animated:YES];
                editGerenXinxiVC.navigationController.navigationBarHidden = YES;
                [editGerenXinxiVC release];
            }
            else if (indexPath.row == 1){
                Lianxifangshi *lianxifangshiVC = [[Lianxifangshi alloc]init];
                lianxifangshiVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lianxifangshiVC animated:YES];
                lianxifangshiVC.navigationController.navigationBarHidden = YES;
                [lianxifangshiVC release];
            }
            else if (indexPath.row == 2){
                Address *addressVC = [[Address alloc]init];
                addressVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addressVC animated:YES];
                addressVC.navigationController.navigationBarHidden = YES;
                [addressVC release];
            }
        }   
        UIView *button = [self.tabBarController.view viewWithTag:100];//找出tabar中间的相机Button
        [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 0;
        }];
    }

    else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您还没有登陆，登陆后继续！" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是",nil];
            [alert show];
            [alert release];
        }

   
}

#pragma mark - selfMethods
-(void)toBigHead:(AsyncImageView *)sender{
    NSLog(@"查看大头像按钮");
}

-(void)toFriendsVC:(UIButton *)sender{
    NSLog(@"推出好友列表页面！");
    FindYourFriends *friendsVC = [[FindYourFriends alloc]init];
    friendsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendsVC animated:YES];
    [friendsVC release];
    
    UIView *button = [self.tabBarController.view viewWithTag:100];//找出tabar中间的相机Button
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 0;
    }];
}

//-(void)toFensiVC:(UIButton *)sender{
//    NSLog(@"推出粉丝列表页面！");
//}

-(void)toSetsVC{
    NSLog(@"Push the setsVC！");
    Sets *setVC = [[Sets alloc]init];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
    setVC.navigationController.navigationBarHidden = YES;
    [setVC release];
    
    UIView *button = [self.tabBarController.view viewWithTag:100];//找出tabar中间的相机Button
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 0;
    }];
}

-(void)toLoginOrExit:(UIButton *)sender{
    if (sender.selected) {
    NSLog(@"Exit the user！");
//        sender.highlighted = YES;
        self.exitAlert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"真的要注销登陆么？" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是",nil];
        [exitAlert show];
        [exitAlert release];
    }
    else{
        Denglu *dengluVC = [[Denglu alloc]init];
        UINavigationController *dengluNav = [[UINavigationController alloc]initWithRootViewController:dengluVC];
        [dengluVC release];
        [self presentModalViewController:dengluNav animated:YES];
        [dengluNav release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == exitAlert) {
            if (buttonIndex == 0) {
                //
        }
        else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"logined"]; //登陆状态改为未登陆
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoLogin"];
            exitBtn.selected = NO;
        }
    }
    else{
        if (buttonIndex == 0) {
            //
        }
        else{
            Denglu *dengluVC = [[Denglu alloc]init];
            UINavigationController *dengluNav = [[UINavigationController alloc]initWithRootViewController:dengluVC];
            [dengluVC release];
            [self presentModalViewController:dengluNav animated:YES];
            [dengluNav release];
        }
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
