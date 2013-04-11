//
//  GerenDongtai.m
//  17huanba
//
//  Created by Chen Hao on 13-3-14.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "GerenDongtai.h"
#import "WriteShuoshuo.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "FriendTimeLineCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"


@interface GerenDongtai ()

@end

@implementation GerenDongtai
@synthesize changeIV;
@synthesize kindsBtn;
@synthesize friendTableView,refreshing;
@synthesize dongtaiArray;
@synthesize head,nameL,QQL;
@synthesize userDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dongtaiArray = [NSMutableArray array];
        page = 0;
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [changeIV release];
    [kindsBtn release];
    [friendTableView release];
    RELEASE_SAFELY(dongtaiArray);
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.changeIV = nil;
    self.kindsBtn = nil;
    self.friendTableView = nil;
    RELEASE_SAFELY(dongtaiArray);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView *headIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 60)];
    headIV.image = [UIImage imageNamed:@"page_top_bg.png"];
    headIV.userInteractionEnabled = YES;
    [self.view addSubview:headIV];
    [headIV release];
    
    self.head = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 5, 45, 45)];
    head.image = DEFAULTIMG;
    [headIV addSubview:head];
    [head release];
    NSString *headStr = [[userDic objectForKey:@"uinfo"] objectForKey:@"headimg"];
    if (![headStr isEqualToString:@" "]) {
        head.urlString = THEURL(headStr);
    }
    
    self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 20)];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.font = [UIFont boldSystemFontOfSize:17];
    nameL.textColor = [UIColor blackColor];
    [headIV addSubview:nameL];
    [nameL release];
    nameL.text = [[userDic objectForKey:@"uinfo"] objectForKey:@"uname"];
    
    
    self.QQL = [[UILabel alloc]initWithFrame:CGRectMake(60, 35, 150, 20)];
    QQL.backgroundColor = [UIColor clearColor];
    QQL.font = [UIFont systemFontOfSize:15];
    QQL.textColor = [UIColor whiteColor];
    [headIV addSubview:QQL];
    [QQL release];
    QQL.text = [[userDic objectForKey:@"uinfo"] objectForKey:@"email"];
    
    UIImageView *renzhengIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44+60, 320, 30)]; //显示认证方式
    renzhengIV.image = [UIImage imageNamed:@"identity_bg.png"];
    [self.view addSubview:renzhengIV];
    [renzhengIV release];
    
    UIImageView *emailIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 3, 24, 24)];
    emailIV.image = [UIImage imageNamed:@"identity_email.png"];
    [renzhengIV addSubview:emailIV];
    [emailIV release];
    
    NSDictionary *uinfoDic = [userDic objectForKey:@"uinfo"];
    int identity = [[uinfoDic objectForKey:@"identity"] intValue];
    UIImageView *shenfenIV = [[UIImageView alloc]initWithFrame:CGRectMake(78, 3, 24, 24)];
    [renzhengIV addSubview:shenfenIV];
    [shenfenIV release];
    if (identity == 2) {
        shenfenIV.image = [UIImage imageNamed:@"identity_ID.png"];
    }
    else{
        shenfenIV.image = [UIImage imageNamed:@"identity_ID_gray.png"];
    }
    
    int tel_indentity = [[uinfoDic objectForKey:@"tel_indentity"] intValue];
    UIImageView *shoujiIV = [[UIImageView alloc]initWithFrame:CGRectMake(44, 3, 24, 24)];
    [renzhengIV addSubview:shoujiIV];
    [shoujiIV release];
    if (tel_indentity == 1) {
        shoujiIV.image = [UIImage imageNamed:@"identity_tel.png"];
    }
    else{
        shoujiIV.image = [UIImage imageNamed:@"identity_tel_gray.png"];
    }
    
    self.friendTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44+60+30, kDeviceWidth, KDeviceHeight-20-44-60-30) pullingDelegate:self];;
    friendTableView.delegate = self;
    friendTableView.dataSource = self;
    [self.view addSubview:friendTableView];
    [friendTableView release];
    
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame = CGRectMake(0, 0, 320, 44);
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(10, 5, 33, 33);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    self.kindsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    kindsBtn.frame = CGRectMake(80, 10, 150, 24);
    kindsBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [kindsBtn setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateNormal];
    [kindsBtn setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateSelected];
    [kindsBtn setTitle:@" 好友动态" forState:UIControlStateNormal];
    [kindsBtn addTarget:self action:@selector(toChangeKinds:) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:kindsBtn];
    
    [self.view addSubview:navIV];
    [navIV release];
    
    self.changeIV = [[UIImageView alloc]initWithFrame:CGRectMake(104, 44, 112, 124)];
    changeIV.image = [UIImage imageNamed:@"drop_menu.png"];
    changeIV.userInteractionEnabled = YES;
    [self.view addSubview:changeIV];
    [changeIV release];
    changeIV.hidden = YES;
    
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(0, 15, 112, 20);
    friendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [friendBtn setTitle:@"好友动态" forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(changeToFriendDongtai:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:friendBtn];
    
    UIButton *fenxiangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fenxiangBtn.frame = CGRectMake(0, 55, 112, 20);
    fenxiangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenxiangBtn setTitle:@"分享" forState:UIControlStateNormal];
    [fenxiangBtn addTarget:self action:@selector(changeToFenxiang:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:fenxiangBtn];
    
    UIButton *shuoshuoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shuoshuoBtn.frame = CGRectMake(0, 95, 112, 20);
    shuoshuoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shuoshuoBtn setTitle:@"说说" forState:UIControlStateNormal];
    [shuoshuoBtn addTarget:self action:@selector(changeToShuodshuo:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:shuoshuoBtn];
    
    [self getThefriendTimeLine:0 andType:nil];
    
}

-(void)getThefriendTimeLine:(int)p andType:(NSString *)type { //获取登录用户好友的动态列表
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSString *uid = [userDic objectForKey:@"user_id"];
    NSLog(@"----%@",uid);
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/default/Feed.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:uid forKey:@"uid"];
    [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"P"];
    [form_request setPostValue:type forKey:@"type"];
    [form_request setDidFinishSelector:@selector(finishGetFriendsMessage:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}


-(void)finishGetFriendsMessage:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Gouwuche str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    NSArray *dataArray = [dic objectForKey:@"data"];
    if ([dataArray count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"暂时还没有哦！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [dongtaiArray addObjectsFromArray:dataArray];
    [friendTableView reloadData];
    NSLog(@"dongtaiArray----%@",dongtaiArray);
    [friendTableView tableViewDidFinishedLoading];
    [SVProgressHUD dismiss];
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [friendTableView tableViewDidFinishedLoading];
}

#pragma mark = UITableViewDelegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dongtaiArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"dongtaiCell";
    FriendTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[FriendTimeLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGSize unameSize = CGSizeZero;
    CGSize gnameSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    CGSize picSize = CGSizeZero;
    CGSize timeSize = CGSizeZero;
    CGSize sayWebSize = CGSizeZero;
    
    NSDictionary *dic = [dongtaiArray objectAtIndex:indexPath.row];
    NSDictionary *uinfoDic = [dic objectForKey:@"uinfo"];
    NSString *headStr = [uinfoDic objectForKey:@"headimg"];
    if (![headStr isEqualToString:@" "]) {
        cell.head.urlString = THEURL(headStr);
    }
    
    NSString *unameStr = [uinfoDic objectForKey:@"uname"];
    cell.uNameL.text = unameStr;
    unameSize.height = cell.uNameL.frame.size.height;
    
    id content = [dic objectForKey:@"content"];
    if ([content isKindOfClass:[NSDictionary class]]) {
        NSString *type = [dic objectForKey:@"type"];
        if (![type isEqualToString:@"1"]) { //如果不是说说
            NSDictionary *contentDic = [dic objectForKey:@"content"];
            NSString *gnameStr = [contentDic objectForKey:@"uname"];
            cell.gNameL.frame = CGRectMake(50, 25, 260, 20);
            cell.gNameL.text = [NSString stringWithFormat:@"分享了 %@ 的商品",gnameStr];
            gnameSize.height = cell.gNameL.frame.size.height;
            
            NSString *titleStr = [contentDic objectForKey:@"goods_name"];
            cell.titleL.frame = CGRectMake(60, 45, 250, 20);
            cell.titleL.text = titleStr;
            titleSize.height = cell.titleL.frame.size.height;
            
            NSString *imageStr = [contentDic objectForKey:@"gdimg"];
            NSLog(@"gdimg-----%@",imageStr);
            if (![imageStr isKindOfClass:[NSNull class]]) {
                cell.gImage.frame = CGRectMake(50, 70, 80, 80);
                cell.gImage.urlString = THEURL(imageStr);
            }
            picSize.height = cell.gImage.frame.size.height + 10;
            
            sayWebSize.height = 0;
        }
        else{
            gnameSize.height = 0;
            
            NSDictionary *contentDic = [dic objectForKey:@"content"];
            NSString *titleStr = [contentDic objectForKey:@"content"];
            cell.sayWeb.frame = CGRectMake(60, 25, 250, 30);
            [cell.sayWeb loadHTMLString:titleStr baseURL:nil];
            cell.sayWeb.userInteractionEnabled = NO;
            
            sayWebSize.height = cell.sayWeb.frame.size.height;
            
            titleSize.height = 0;
            
            picSize.height = 0;
        }
    }
    else{ //如果该商品已被删除
        cell.gNameL.frame = CGRectMake(50, 25, 260, 20);
        cell.gNameL.text = @"该商品已被删除！";
        gnameSize.height = cell.gNameL.frame.size.height;
    }
    
    NSString *timeStr = [dic objectForKey:@"addtime"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    NSString *timeStrr = [NSString stringWithFormat:@"%@",timeDate];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss zzz"];   //zzz代表+0000 时区格式
    NSDate *date=[dateformatter dateFromString:timeStrr];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString=[dateformatter stringFromDate:date];
    [dateformatter release];
    
    cell.timeL.frame = CGRectMake(50, unameSize.height + gnameSize.height + titleSize.height + sayWebSize.height + picSize.height, 100, 15);
    cell.timeL.text = dateString;
    timeSize.height = cell.timeL.frame.size.height;
    
    CGRect rect = cell.frame;
    rect.size.height = unameSize.height + gnameSize.height + titleSize.height + sayWebSize.height + picSize.height + timeSize.height + 5;
    cell.frame = rect;
    
    return cell;
}

-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)toDingwei{
//    NSLog(@"定位！");
//}

//-(void)toWrite{
//    NSLog(@"写说说。。。");
//    WriteShuoshuo *writeVC = [[WriteShuoshuo alloc]init];
//    [self.navigationController pushViewController:writeVC animated:YES];
//    writeVC.navigationController.navigationBarHidden = YES;
//    [writeVC release];
//}

-(void)toChangeKinds:(UIButton *)sender{
    NSLog(@"更换显示类别！");
    kindsBtn.highlighted = YES;
    if (sender.selected) {
        sender.selected = NO;
        changeIV.hidden = YES;
        
    }
    else{
        sender.selected = YES;
        changeIV.hidden = NO;
    }
}


#pragma mark - Scroll
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    kindsBtn.selected = NO;
    changeIV.hidden = YES;

    [self.friendTableView tableViewDidScroll:scrollView];
}


//当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.friendTableView tableViewDidEndDragging:scrollView];
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
    refreshing = NO;
    page++;
    refreshing = NO;
    [self getThefriendTimeLine:page andType:nil];
    
    NSLog(@"loadData  loadData  loadData");
}

-(void)refreshPage{
    refreshing = NO;
    [dongtaiArray removeAllObjects];
    [self getThefriendTimeLine:0 andType:nil];
    
    NSLog(@"refresh  refresh  refresh");
}

-(void)changeToFriendDongtai:(UIButton *)sender{
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [dongtaiArray removeAllObjects];
    [self getThefriendTimeLine:0 andType:nil];
}

-(void)changeToFenxiang:(UIButton *)sender{
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [dongtaiArray removeAllObjects];
    [self getThefriendTimeLine:0 andType:@"3"];
    
}

-(void)changeToShuodshuo:(UIButton *)sender{
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [dongtaiArray removeAllObjects];
    [self getThefriendTimeLine:0 andType:@"1"];
    
}

//-(void)changeToMydongtai:(UIButton *)sender{
//    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
//    [kindsBtn setTitle:title forState:UIControlStateNormal];
//    kindsBtn.selected = NO;
//    changeIV.hidden = YES;
//    [dongtaiArray removeAllObjects];
//    [self getThefriendTimeLine:0 andType:@"2"];
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
