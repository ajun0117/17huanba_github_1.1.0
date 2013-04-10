//
//  Message.m
//  17huanba
//
//  Created by Chen Hao on 13-1-24.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Message.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Denglu.h"
#import "AsyncImageView.h"
#import "WriteSixin.h"
#import "SVProgressHUD.h"

@interface Message ()

@end

@implementation Message
@synthesize messageTableView;
@synthesize backBtn;
@synthesize messageArray;
@synthesize istabMessage;
@synthesize refreshing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.messageArray = [NSMutableArray array];
        istabMessage = YES;
        page = 0;
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    RELEASE_SAFELY(messageTableView);
    RELEASE_SAFELY(messageArray);
    RELEASE_SAFELY(backBtn);
}

-(void)viewDidUnload{
    [super viewDidUnload];
    RELEASE_SAFELY(messageTableView);
    RELEASE_SAFELY(messageArray);
    RELEASE_SAFELY(backBtn);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (istabMessage) {
        UIView *button = [self.tabBarController.view viewWithTag:100];//找出tabar中间的相机Button
        [UIView animateWithDuration:0.2 animations:^{
            button.alpha = 1;
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    BOOL *isLogined = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue]; //检测是否为已登录
    if (isLogined) {
         [messageArray removeAllObjects];
         [self getTheMessageWithPage:0];
    }
    else{
        [messageArray removeAllObjects]; //删除所有私信内容
        [messageTableView reloadData];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您还没有登陆，登陆后继续！" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是",nil];
        [alert show];
        [alert release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame = CGRectMake(0, 0, 320, 44);
    
    self.backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 10, 57, 27);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_gray_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    backBtn.hidden = YES;
    
    UILabel *nameL=[[UILabel alloc]initWithFrame:CGRectMake(90, 10, 140, 24)];
    nameL.font=[UIFont systemFontOfSize:17];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = UITextAlignmentCenter;
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"私信";
    [navIV addSubview:nameL];
    [nameL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    self.messageTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-44-20) pullingDelegate:self];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    messageTableView.backgroundView = view;
    [view release];
    messageTableView.delegate = self;
    messageTableView.dataSource = self;
    [self.view addSubview:messageTableView];
    [messageTableView release];
}

#pragma mark - 获取用户列表申请列表
-(void)getTheMessageWithPage:(int)p{ //获取登录用户的私信列表
    
    BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue];
    if (isLogin) { //如果已登陆
        [SVProgressHUD showWithStatus:@"获取私信.."];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Letter.html")];
        ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
        [form_request setDelegate:self];
        [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
        [form_request setPostValue:token forKey:@"token"];
        [form_request setDidFinishSelector:@selector(finishGetTheMessage:)];
        [form_request setDidFailSelector:@selector(loginMessFailed:)];
        [form_request startAsynchronous];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您还没有登陆，登陆后继续！" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是",nil];
        [alert show];
        [alert release];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }
    else{
        Denglu *dengluVC = [[Denglu alloc]init];
        [self presentModalViewController:dengluVC animated:YES];
        [dengluVC release];
    }
}

-(void)finishGetTheMessage:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"私信 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"array is %@",dic);
    NSArray *array = [dic objectForKey:@"data"];
    if ([array count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"暂时还没有收到私信" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [messageArray addObjectsFromArray:array];
    [messageTableView reloadData];
    
    [messageTableView tableViewDidFinishedLoading];
    [SVProgressHUD dismiss];
}

-(void)loginMessFailed:(ASIHTTPRequest *)request{
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"失败   %@",str);
    [str release];
    [SVProgressHUD dismissWithError:@"请检查网络连接后重试！"];
}


#pragma mark = UITableViewDelegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messageArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"messageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef] autorelease];
        
        AsyncImageView *head = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        head.image = DEFAULTIMG;
        head.tag = 10;
        [cell.contentView addSubview:head];
        [head release];
        
        UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 150, 20)];
        nameL.backgroundColor = [UIColor clearColor];
        nameL.tag = 20;
        [cell.contentView addSubview:nameL];
        [nameL release];
        
        UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(200, 30, 100, 20)];
        timeL.backgroundColor = [UIColor clearColor];
        timeL.font = [UIFont systemFontOfSize:12];
        timeL.tag = 30;
        [cell.contentView addSubview:timeL];
        [timeL release];
        
        UILabel *contentL = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, 140, 20)];
        contentL.backgroundColor = [UIColor clearColor];
        contentL.tag = 40;
        [cell.contentView addSubview:contentL];
        [contentL release];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *messDic = [messageArray objectAtIndex:indexPath.row];
    NSDictionary *userDic = [messDic objectForKey:@"uinfo"];
    
    AsyncImageView *head = (AsyncImageView *)[cell viewWithTag:10];
    NSString *userImgStr = [userDic objectForKey:@"headimg"];
    if (![userImgStr isEqualToString:@" "]) {
        head.urlString = THEURL(userImgStr);
    }
    UILabel *nameL = (UILabel *)[cell viewWithTag:20];
    nameL.text = [userDic objectForKey:@"uname"];
    
    UILabel *timeL = (UILabel *)[cell viewWithTag:30];
    NSString *timeStr = [messDic objectForKey:@"addtime"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    NSString *timeStrr = [NSString stringWithFormat:@"%@",timeDate];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss zzz"];   //zzz代表+0000 时区格式
    NSDate *date=[dateformatter dateFromString:timeStrr];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString=[dateformatter stringFromDate:date];
    [dateformatter release];
    timeL.text = dateString;
    
    
    UILabel *contentL = (UILabel *)[cell viewWithTag:40];
    contentL.text = [messDic objectForKey:@"msg"];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__FUNCTION__);
    NSDictionary *messDic = [messageArray objectAtIndex:indexPath.row];
    
    NSDictionary *userDic = [messDic objectForKey:@"uinfo"];
    WriteSixin *writeSixinVC = [[WriteSixin alloc]init];
    [self.navigationController pushViewController:writeSixinVC animated:YES];
    [writeSixinVC release];
    writeSixinVC.uname = [userDic objectForKey:@"uname"];
    writeSixinVC.rmid = [messDic objectForKey:@"rmid"];
    [writeSixinVC.myTextView becomeFirstResponder];
}

#pragma mark - Scroll
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.messageTableView tableViewDidScroll:scrollView];
}


//当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.messageTableView tableViewDidEndDragging:scrollView];
}
#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    self.refreshing = YES;
    [self performSelector:@selector(refreshPage) withObject:nil afterDelay:1.f];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

-(void)loadData
{
    page++;
    refreshing = NO;
    [self getTheMessageWithPage:page];
       
    NSLog(@"loadData  loadData  loadData");
}

-(void)refreshPage{
    refreshing = NO;
    page = 0;
    [messageArray removeAllObjects];
    [self getTheMessageWithPage:0];
    
    NSLog(@"refresh  refresh  refresh");
}




-(void)reply:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
}

-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}


//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    UIView *button = [self.tabBarController.view viewWithTag:100];//找出tabar中间的相机Button
//    button.hidden = NO;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
