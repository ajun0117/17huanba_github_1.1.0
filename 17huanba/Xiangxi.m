//
//  Xiangxi.m
//  17huanba
//
//  Created by Chen Hao on 13-1-24.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Xiangxi.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#import "Denglu.h"
#import "Dingdan.h"
#import "GerenDongtai.h"
#import "WriteSixin.h"
#import "StrikeThroughLabel.h"
#import "SVProgressHUD.h"

@interface Xiangxi ()

@end

@implementation Xiangxi
@synthesize myTableView;
@synthesize refreshing;
@synthesize page;
@synthesize sectionHeadView;
@synthesize seg;
@synthesize gdid;
@synthesize dataDic;
@synthesize liuyanArray;
@synthesize myInfoDic;
@synthesize detailGoodsRequest;
@synthesize userMessage_request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [detailGoodsRequest clearDelegatesAndCancel];
    [detailGoodsRequest release];
    
    [userMessage_request clearDelegatesAndCancel];
    [userMessage_request release];
    
    [myTableView release];
    [page release];
    [sectionHeadView release];
    [seg release];
    [gdid release];
    [dataDic release];
    [liuyanArray release];
    [myInfoDic release];
    
    [super dealloc];
}

-(void)viewDidUnload{
    self.myTableView = nil;
    self.page = nil;
    self.sectionHeadView = nil;
    self.seg = nil;
    self.gdid = nil;
    self.dataDic = nil;
    self.liuyanArray = nil;
    self.myInfoDic = nil;
    self.DetailGoodsRequest = nil;
    self.userMessage_request = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled = YES;
    navIV.frame = CGRectMake(0, 0, 320, 44);
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 10, 57, 27);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_gray_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    UILabel *nameL=[[UILabel alloc]initWithFrame:CGRectMake(130, 10, 80, 24)];
    nameL.font=[UIFont boldSystemFontOfSize:17];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"商品详细";
    [navIV addSubview:nameL];
    [nameL release];
    
    UIButton *moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame=CGRectMake(258, 10, 57, 27);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"like_graybtn.png"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(toSave) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:moreBtn];
    [self.view addSubview:navIV];
    [navIV release];
    
//    self.myTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-44-20) pullingDelegate:self];
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-44-20)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    [myTableView release];
    
    self.sectionHeadView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    self.seg = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"商品详情",@"信誉评价", nil]];
    seg.frame = CGRectMake(10, 0, 180, 30);
    seg.selectedSegmentIndex = 0;
    seg.segmentedControlStyle = UISegmentedControlStyleBar;
    [seg setBackgroundImage:[UIImage imageNamed:@"detail_tab_gray.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [seg setBackgroundImage:[UIImage imageNamed:@"detail_tab.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [seg addTarget:self action:@selector(tochangeSegmentValue:) forControlEvents:UIControlEventValueChanged];
    [sectionHeadView addSubview:seg];
    [seg release];
    
    [self requestWithDetailGoods];
}


#pragma mark - 接口部分
-(void)requestWithDetailGoods{
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/default/Viewgd.html")];
    self.detailGoodsRequest = [ASIFormDataRequest requestWithURL:newUrl];
    [detailGoodsRequest setDelegate:self];
    [detailGoodsRequest setPostValue:gdid forKey:@"gdid"];
    [detailGoodsRequest setDidFinishSelector:@selector(finishTheDetailGoods:)];
    [detailGoodsRequest setDidFailSelector:@selector(loginFailed:)];
    [detailGoodsRequest startAsynchronous];
}

-(void)finishTheDetailGoods:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"str    is   %@",str);
    NSDictionary *goodsDic = [str JSONValue];
    [str release];
    NSLog(@"goodsDic   is   %@",goodsDic);
    id theData = [goodsDic objectForKey:@"data"];
    if ([theData isKindOfClass:[NSDictionary class]]) {
        self.dataDic = [goodsDic objectForKey:@"data"];
        [myTableView reloadData];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"对不起" message:@"商品不存在" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    [SVProgressHUD dismiss];
    
    [self userMessage];
}

#pragma mark - 请求登录用户的信息
-(void)userMessage{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Usinfo.html")];
    self.userMessage_request = [ASIFormDataRequest requestWithURL:newUrl];
    [userMessage_request setDelegate:self];
    [userMessage_request setPostValue:token forKey:@"token"];
    [userMessage_request setDidFinishSelector:@selector(finishGetUserMessage:)];
    [userMessage_request setDidFailSelector:@selector(loginFailed:)];
    [userMessage_request startAsynchronous];
}


-(void)finishGetUserMessage:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"userInformation  str   is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    self.myInfoDic = dic;
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - marheds
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toSave{ //收藏该商品
    NSLog(@"我是-收藏 按钮");
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSLog(@"token   is   %@",token);
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue]){ //如果已登录
        NSDictionary *uinfoDic = [dataDic objectForKey:@"uinfo"];
        int identity = [[uinfoDic objectForKey:@"identity"] intValue];
        int tel_indentity = [[uinfoDic objectForKey:@"telident"] intValue];
        
        int myIdentity = [[myInfoDic objectForKey:@"identity"] intValue]; //登录用户认证信息
        int myTel_indentity = [[myInfoDic objectForKey:@"tel_indentity"] intValue];
        
        if (identity == 2 && tel_indentity == 1 && myIdentity == 2 && myTel_indentity == 1) {
            NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/collect.html")];
            ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
            [form_request setDelegate:self];
            [form_request setPostValue:gdid forKey:@"id"];
            [form_request setPostValue:token forKey:@"token"];
            [form_request setDidFinishSelector:@selector(finishSaveTheGoods:)];
            [form_request setDidFailSelector:@selector(loginFailed:)];
            [form_request startAsynchronous];
        }
        else{
            if (identity != 2 && myIdentity ==2) { //买家认证而卖家未认证
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"卖家未通过身份认证，不能执行操作！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            else{ //卖家认证而买家未认证
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您未通过身份认证，不能执行操作！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
    }
    else{ //如果没有登陆
        [self alertViewNotLoginShow];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }
    else{
        Denglu *dengluVC = [[Denglu alloc]init];
        UINavigationController *dengluNav = [[UINavigationController alloc]initWithRootViewController:dengluVC];
        [dengluVC release];
        [self presentModalViewController:dengluNav animated:YES];
        [dengluNav release];
    }
}

-(void)finishSaveTheGoods:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"array is %@",dic);
    NSString *info = [dic objectForKey:@"info"];
    NSLog(@"info-----%@",info);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:info delegate:self cancelButtonTitle:nil otherButtonTitles:@"是",nil];
    [alert show];
    [alert release];
}



-(void)shenqing{
    NSLog(@"我是-申请 按钮");
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue]){ //如果已登录
        NSDictionary *uinfoDic = [dataDic objectForKey:@"uinfo"];
        int identity = [[uinfoDic objectForKey:@"identity"] intValue]; //卖家认证信息
        int tel_indentity = [[uinfoDic objectForKey:@"telident"] intValue];
        
        int myIdentity = [[myInfoDic objectForKey:@"identity"] intValue]; //登录用户认证信息
        int myTel_indentity = [[myInfoDic objectForKey:@"tel_indentity"] intValue];
        
        NSLog(@"%d %d %d %d",identity,tel_indentity,myIdentity,myTel_indentity);
        
        if (identity == 2 && tel_indentity == 1 && myIdentity == 2 && myTel_indentity == 1) {
            Dingdan *dingdanVC = [[Dingdan alloc]init];
            dingdanVC.gidStr = gdid;
            [self.navigationController pushViewController:dingdanVC animated:YES];
            [dingdanVC release];
        }
        else{
            if (identity != 2 && myIdentity ==2) { //买家认证而卖家未认证
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"卖家未通过身份认证，不能执行操作！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            else{ //卖家认证而买家未认证
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您未通过身份认证，不能执行操作！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
    }
    else{ //如果没有登陆
        [self alertViewNotLoginShow];
    }
}

-(void)alertViewNotLoginShow{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您还没有登陆，登陆后继续！" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是",nil];
    [alert show];
    [alert release];
}

-(void)finishShenqing:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"str    is   %@",str);
    [str release];
    //    NSArray *array = [str JSONValue];
    //    NSLog(@"array is %@",array);
}

-(void)gouwuche{ 
    NSLog(@"我是-加入购物车");
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSLog(@"token   is   %@",token);
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue]){ //如果已登录
        
        NSDictionary *uinfoDic = [dataDic objectForKey:@"uinfo"];
        int identity = [[uinfoDic objectForKey:@"identity"] intValue];
        int tel_indentity = [[uinfoDic objectForKey:@"telident"] intValue];
        
        int myIdentity = [[myInfoDic objectForKey:@"identity"] intValue]; //登录用户认证信息
        int myTel_indentity = [[myInfoDic objectForKey:@"tel_indentity"] intValue];
        
        if (identity == 2 && tel_indentity == 1 && myIdentity == 2 && myTel_indentity == 1) {
            NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Addcart.html")];
            ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
            [form_request setDelegate:self];
            [form_request setPostValue:gdid forKey:@"id"];
            [form_request setPostValue:token forKey:@"token"];
            [form_request setDidFinishSelector:@selector(finishGouwuche:)];
            [form_request setDidFailSelector:@selector(loginFailed:)];
            [form_request startAsynchronous];
        }
        else{
            if (identity != 2 && myIdentity ==2) { //买家认证而卖家未认证
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"卖家未通过身份认证，不能执行操作！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            else{ //卖家认证而买家未认证
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您未通过身份认证，不能执行操作！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
    }
    else{
        [self alertViewNotLoginShow];
    }
}

-(void)finishGouwuche:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Gouwuche str    is   %@",str);
    //    NSArray *array = [str JSONValue];
    //    NSLog(@"array is %@",array);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"array is %@",dic);
    NSString *info = [dic objectForKey:@"info"];
    NSLog(@"info-----%@",info);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:info delegate:self cancelButtonTitle:nil otherButtonTitles:@"是",nil];
    [alert show];
    [alert release];
    
}

-(void)finishXinyu:(ASIHTTPRequest *)request{ //信誉评价 请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Xinyustr    is   %@",str);
    [str release];
    NSString *uid = [dataDic objectForKey:@"user_id"];
    NSLog(@"uid    is    %@",uid);
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/default/Comment.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:uid forKey:@"uid"];
    [form_request setDidFinishSelector:@selector(finishLiuyan:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
    
}

-(void)finishLiuyan:(ASIHTTPRequest *)request{ //信誉评价 请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Liuyanstr    is   %@",str);
    NSArray *array = [str JSONValue];
    [str release];
    NSLog(@"array is %@",array);
    self.liuyanArray = array;
    
    [myTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];//刷新section == 1 的一列
    [SVProgressHUD dismiss];

}

-(void)toBigHead:(AsyncImageView *)sender{
    NSLog(@"点击了卖家头像！");
    GerenDongtai *gerenVC = [[GerenDongtai alloc]init];
    gerenVC.userDic = dataDic;
    [self.navigationController pushViewController:gerenVC animated:YES];
    gerenVC.navigationController.navigationBarHidden = YES;
    [gerenVC release];
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    else if(section == 1){
        if (seg.selectedSegmentIndex == 0) { //商品详情
            return 1;
        }
        return [liuyanArray count]+1;   //信誉评价
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return sectionHeadView;
}

-(void)tochangeSegmentValue:(UISegmentedControl *)sender{
    NSLog(@"刷新section == 1 的一列");
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [myTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];//刷新section == 1 的一列
            break;
        }
        case 1:
        {
            [SVProgressHUD showWithStatus:@"加载店铺留言.."];
            NSLog(@"发起信誉评价请求");
            NSString *uid = [dataDic objectForKey:@"user_id"];
            NSLog(@"uid    is    %@",uid);
            NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/default/Cmtavg.html")];
            ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
            [form_request setDelegate:self];
            [form_request setPostValue:uid forKey:@"uid"];
            [form_request setDidFinishSelector:@selector(finishXinyu:)];
            [form_request setDidFailSelector:@selector(loginFailed:)];
            [form_request startAsynchronous];
            break;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) { //商品基本信息列
        if (indexPath.row == 0) {
            return 44;
        }
        else if(indexPath.row == 1){
            return 260;
        }
        else if(indexPath.row == 2){
            return 50;
        }
        else if(indexPath.row == 3){
            return 200;
        }
    }
    else if (indexPath.section == 1){ //商品详情列
        if (seg.selectedSegmentIndex == 0) {
            return 150;
        }
        else{
            if (indexPath.row == 0) {
                return 80;
            }
            else
                return 50;
        }
    }
        return 150+20*2;//温馨提醒是section == 2的一列
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"xiangxiCell";
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
            if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"details_title_bg.png"]];
            
            AsyncImageView *head = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 2, 40, 40)];
            head.image = DEFAULTIMG;
            [head addTarget:self action:@selector(toBigHead:) forControlEvents:UIControlEventTouchUpInside];
                NSString *headStr = [[dataDic objectForKey:@"uinfo"] objectForKey:@"headimg"];
                if (![headStr isEqualToString:@" "]) {
                    head.urlString = THEURL(headStr);
                }
            [cell.contentView addSubview:head];
            [head release];
            
            NSString *userName = [[dataDic objectForKey:@"uinfo"] objectForKey:@"uname"];
            UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 110, 30)];
            nameL.backgroundColor = [UIColor clearColor];
            nameL.text = userName;
            [cell.contentView addSubview:nameL];
            [nameL release];
            
            UILabel *detailL = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, 100, 20)];
            detailL.font = [UIFont systemFontOfSize:12];
            detailL.backgroundColor = [UIColor clearColor];
            detailL.text = @"一起换吧用户";
            [cell.contentView addSubview:detailL];
            [detailL release];
                
                
            UIButton *sixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [sixinBtn setBackgroundImage:[UIImage imageNamed:@"60_20.png"] forState:UIControlStateNormal];
            sixinBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            sixinBtn.frame = CGRectMake(170, 10, 60, 20);
            [sixinBtn setTitle:@"发私信" forState:UIControlStateNormal];
            [sixinBtn addTarget:self action:@selector(sendSixin) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:sixinBtn];
                
                
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [addBtn setBackgroundImage:[UIImage imageNamed:@"80_20.png"] forState:UIControlStateNormal];
            addBtn.frame = CGRectMake(235, 10, 80, 20);
            addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [addBtn setTitle:@"加TA为好友" forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addBtn];
                
            }
        else if (indexPath.row == 1) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone; //取消点击背景效果
            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg_0.png"]];//平铺背景图片
            NSArray *urlStrArray= [dataDic objectForKey:@"gdimg"]; //存放展示图片地址的数组
            int count = [urlStrArray count];
            UIScrollView *picSV = [[UIScrollView alloc]initWithFrame:CGRectMake(40, 10, 230, 230)];
            picSV.contentSize = CGSizeMake(230*count, 230);
            picSV.pagingEnabled = YES;
            picSV.showsHorizontalScrollIndicator = NO;
            picSV.delegate = self;
            picSV.clipsToBounds = NO;//显示超出UIScrollView但还在屏幕内的部分
            
            for (int i=0; i<[urlStrArray count]; ++i) {
                NSDictionary *urlStDic = [urlStrArray objectAtIndex:i];
                AsyncImageView *iM =[[AsyncImageView alloc]initWithFrame:CGRectMake(0+230*i, 0, 220, 230)];
                iM.urlString = THEURL([urlStDic objectForKey:@"smallimg"]);
                [picSV addSubview:iM];
                [iM release];
            }
            [cell.contentView addSubview:picSV];
            [picSV release];
            
            self.page = [[UIPageControl alloc]initWithFrame:CGRectMake((cell.frame.size.width-80)/2,245, 80, 10)];
            page.numberOfPages = [urlStrArray count];
            [cell addSubview:page];
            [page release];
            [self setCurrentPage:page.currentPage];
            page.enabled = NO;
        }
    
        else if(indexPath.row == 2){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString *goodsName = [dataDic objectForKey:@"goods_name"];
            cell.textLabel.text = goodsName;
        }
        
        else if(indexPath.row == 3){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *jiageIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 130, 35)];
            jiageIV.image = [UIImage imageNamed:@"price_bg.png"];
            [cell.contentView addSubview:jiageIV];
            [jiageIV release];
            
            UILabel *priceL = [[UILabel alloc]initWithFrame:CGRectMake(1, 5, 95, 25)];
            priceL.font = [UIFont systemFontOfSize:15];
            priceL.textColor = [UIColor whiteColor];
            priceL.textAlignment = UITextAlignmentCenter;
            priceL.backgroundColor = [UIColor clearColor];
            
            NSString *price = nil;
            NSString *sell_type = [dataDic objectForKey:@"sell_type"];
            NSString *gold = [dataDic objectForKey:@"gold"];
            NSString *silver = [dataDic objectForKey:@"silver"];
            NSString *memoStr = [dataDic objectForKey:@"memo"];
            
            if ([sell_type isEqualToString:@"1"]) {
                price = [NSString stringWithFormat:@"接受%@交换",memoStr];
            }
            else if ([sell_type isEqualToString:@"2"]) {
                price = [NSString stringWithFormat:@"￥%@+%@换币",gold,silver];
                
            }
            else if ([sell_type isEqualToString:@"3"])
            {
                price = [NSString stringWithFormat:@"￥%@+%@换币或%@",gold,silver,memoStr];
            }
            CGSize textSize = [price sizeWithFont:[UIFont systemFontOfSize:15]]; //用来计算文本的宽度 然后动态改变UILable和ImageView的Frame
            NSLog(@"textSize00----000---000--00%@",NSStringFromCGSize(textSize));
            jiageIV.frame = CGRectMake(10, 5, textSize.width+70, 35);
            priceL.frame = CGRectMake(1, 5, textSize.width, 25);
            priceL.text = price;
            
            [jiageIV addSubview:priceL];
            [priceL release];
            
            
            UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 200, 20)];
            timeL.font = [UIFont systemFontOfSize:15];
            timeL.textAlignment = UITextAlignmentLeft;
            timeL.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:timeL];
            [timeL release];
            
            NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[[dataDic objectForKey:@"add_time"] doubleValue]];
            NSString *timeStr = [NSString stringWithFormat:@"%@",timeDate];
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
            [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss zzz"];   //zzz代表+0000 时区格式
            NSDate *date=[dateformatter dateFromString:timeStr];
            [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateString=[dateformatter stringFromDate:date];
            [dateformatter release];
            timeL.text = [NSString stringWithFormat:@"发布时间：%@",dateString];
            
            
            UILabel *addressL = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 300, 20)];
            addressL.font = [UIFont systemFontOfSize:15];
            addressL.textAlignment = UITextAlignmentLeft;
            addressL.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:addressL];
            [addressL release];
            NSString *addressStr = SHENG_SHI_XIAN([dataDic objectForKey:@"sheng"], [dataDic objectForKey:@"shi"], [dataDic objectForKey:@"xian"]);
            addressL.text = [NSString stringWithFormat:@"商品所在地：%@",addressStr];
            
            
            UILabel *youfeiL = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, 300, 20)];
            youfeiL.font = [UIFont systemFontOfSize:15];
            youfeiL.textAlignment = UITextAlignmentLeft;
            youfeiL.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:youfeiL];
            [youfeiL release];
            
            NSString *isfree = [dataDic objectForKey:@"free_delivery"];
            NSString *free_delivery = nil;
            if ([isfree isEqualToString:@"0"]) {
                free_delivery = @"否";
            }
            else{
                free_delivery = @"是";
            }
            NSString *townsmanStr = [dataDic objectForKey:@"freight_townsman"];
            NSString *allopatryStr = [dataDic objectForKey:@"freight_allopatry"];
            youfeiL.text = [NSString stringWithFormat:@"运   费：包邮:%@  同城:%@元 异地:%@元",free_delivery,townsmanStr,allopatryStr];
            
            StrikeThroughLabel *yuanjiaL = [[StrikeThroughLabel alloc]initWithFrame:CGRectMake(10, 105, 300, 20)];
            yuanjiaL.strikeThroughEnabled = YES;
            yuanjiaL.font = [UIFont systemFontOfSize:15];
            yuanjiaL.textAlignment = UITextAlignmentLeft;
            yuanjiaL.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:yuanjiaL];
            [yuanjiaL release];
            NSString *yuanjiaStr = [dataDic objectForKey:@"market_price"];
            yuanjiaL.text = [NSString stringWithFormat:@"原   价：%@",yuanjiaStr];
            
            UILabel *chengseL = [[UILabel alloc]initWithFrame:CGRectMake(10, 125, 300, 20)];
            chengseL.font = [UIFont systemFontOfSize:15];
            chengseL.textAlignment = UITextAlignmentLeft;
            chengseL.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:chengseL];
            [chengseL release];
            
            NSString *isNew = [dataDic objectForKey:@"is_new"];
            NSString *chengseStr = nil;
            if ([isNew isEqualToString:@"1"]) {
                chengseStr = @"二手";
            }
            else{
                chengseStr = @"全新";
            }
            chengseL.text = [NSString stringWithFormat:@"成   色：%@",chengseStr];
            
            UIButton *shenqingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [shenqingBtn setBackgroundImage:[UIImage imageNamed:@"apply_trade.png"] forState:UIControlStateNormal];
            shenqingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [shenqingBtn setTitle:@"申请交易" forState:UIControlStateNormal];
            [shenqingBtn addTarget:self action:@selector(shenqing) forControlEvents:UIControlEventTouchUpInside];
            shenqingBtn.frame = CGRectMake(10, 170, 70, 21);
            [cell.contentView addSubview:shenqingBtn];
            
            UIButton *gouwucheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [gouwucheBtn setBackgroundImage:[UIImage imageNamed:@"add_cart.png"] forState:UIControlStateNormal];
            gouwucheBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [gouwucheBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
            [gouwucheBtn addTarget:self action:@selector(gouwuche) forControlEvents:UIControlEventTouchUpInside];
            gouwucheBtn.frame = CGRectMake(90, 170, 70, 21);
            [cell.contentView addSubview:gouwucheBtn];

        }
    }
    
    else if(indexPath.section == 1){
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (seg.selectedSegmentIndex == 0) {
            
            NSString *htmlStr = [dataDic objectForKey:@"goods_desc"];
            
            UIWebView *webView = [[UIWebView alloc]init];
            webView.scrollView.alwaysBounceVertical = NO;
            webView.scrollView.alwaysBounceHorizontal = NO;
            webView.frame = CGRectMake(0, 0, 320, 150);
//            webView.scalesPageToFit = YES;
//            webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打 
            [webView loadHTMLString:htmlStr baseURL:nil];
            [cell addSubview:webView];
            [webView release];
        }
        else{
            if (indexPath.row == 0) {
                UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(80, 10, 170, 15)];
                UILabel *miaoshuL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 15)];
                miaoshuL.font = [UIFont systemFontOfSize:13];
                miaoshuL.text = @"商品描述:";
                [view1 addSubview:miaoshuL];
                [miaoshuL release];
                for (int i = 0; i<5; ++i) {
                    UIImageView *starIV = [[UIImageView alloc]initWithFrame:CGRectMake(70+17*i, 0, 14, 14)];
                    starIV.image = [UIImage imageNamed:@"star_yellow.png"];
                    [view1 addSubview:starIV];
                    [starIV release];
                }
                [cell addSubview:view1];
                [view1 release];
                
                UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(80, 30, 170, 15)];
                UILabel *fuwuL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 15)];
                fuwuL.font = [UIFont systemFontOfSize:13];
                fuwuL.text = @"服务态度:";
                [view2 addSubview:fuwuL];
                [fuwuL release];
                for (int i = 0; i<5; ++i) {
                    UIImageView *starIV = [[UIImageView alloc]initWithFrame:CGRectMake(70+17*i, 0, 14, 14)];
                    starIV.image = [UIImage imageNamed:@"star_yellow.png"];
                    [view2 addSubview:starIV];
                    [starIV release];
                }
                [cell addSubview:view2];
                [view2 release];
                
                
                UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(80, 50, 170, 15)];
                UILabel *kekaoL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 15)];
                kekaoL.font = [UIFont systemFontOfSize:13];
                kekaoL.text = @"可靠程度:";
                [view3 addSubview:kekaoL];
                [kekaoL release];
                for (int i = 0; i<5; ++i) {
                    UIImageView *starIV = [[UIImageView alloc]initWithFrame:CGRectMake(70+17*i, 0, 14, 14)];
                    starIV.image = [UIImage imageNamed:@"star_yellow.png"];
                    [view3 addSubview:starIV];
                    [starIV release];
                }
                [cell addSubview:view3];
                [view3 release];
                
                }
            
            else{
                cell = [tableView dequeueReusableCellWithIdentifier:indef];
                if (!cell) {
                    cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef] autorelease];
                    AsyncImageView *head = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
                    head.tag = 10;
                    [cell.contentView addSubview:head];
                    [head release];
                    
                    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 100, 20)];
                    nameL.font = [UIFont systemFontOfSize:13];
                    nameL.tag = 20;
                    [cell.contentView addSubview:nameL];
                    [nameL release];
                    
                    UILabel *contentL = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, 100, 20)];
                    contentL.font = [UIFont systemFontOfSize:16];
                    contentL.tag = 30;
                    [cell.contentView addSubview:contentL];
                    [contentL release];
                    
                    UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(250, 30, 70, 15)];
                    timeL.font = [UIFont systemFontOfSize:11];
                    timeL.tag = 40;
                    [cell.contentView addSubview:timeL];
                    [timeL release];
                    
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                AsyncImageView *head = (AsyncImageView *)[cell viewWithTag:10];
                NSDictionary *uinfoDic = [[liuyanArray objectAtIndex:indexPath.row-1] objectForKey:@"uinfo"];
                head.urlString = [uinfoDic objectForKey:THEURL([uinfoDic objectForKey:@"uimg"])];
                
                UILabel *nameL = (UILabel *)[cell viewWithTag:20];
                nameL.text = [uinfoDic objectForKey:@"uname"];
                
                UILabel *contentL = (UILabel *)[cell viewWithTag:30];
                contentL.text = [[liuyanArray objectAtIndex:indexPath.row-1] objectForKey:@"content"];
                
                //时间格式转换
                NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[[[liuyanArray objectAtIndex:indexPath.row-1] objectForKey:@"addtime"] doubleValue]];
                NSString *timeStr = [NSString stringWithFormat:@"%@",timeDate];
                NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
                [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss zzz"];   //zzz代表+0000 时区格式
                NSDate *date=[dateformatter dateFromString:timeStr];
                [dateformatter setDateFormat:@"MM-dd HH:mm"];
                NSString *dateString=[dateformatter stringFromDate:date];
                [dateformatter release];
                UILabel *timeL = (UILabel *)[cell viewWithTag:40];
                timeL.text = dateString;
                
            }
        }
    }
    
    else {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *tipsIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 290, 150)];
        tipsIV.image = [UIImage imageNamed:@"tips_bg.png"];
        [cell.contentView addSubview:tipsIV];
        [tipsIV release];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView !=myTableView) {
        page.currentPage = scrollView.contentOffset.x/230;//page的当前页
        [self setCurrentPage:page.currentPage];
    }
}

- (void) setCurrentPage:(NSInteger)secondPage {
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [page.subviews count]; subviewIndex++) {
        UIImageView* subview = [page.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 18/2;
        size.width = 18/2;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        if (subviewIndex == secondPage) [subview setImage:[UIImage imageNamed:@"circle_focus.png"]];
        else [subview setImage:[UIImage imageNamed:@"circle.png"]];
    }
}

#pragma mark - 添加好友
-(void)addFriend{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue]){ //如果已登录
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]; //登陆用户的ID
        NSLog(@"----%@",uid);
        NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/default/Addfrd.html")];
        ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
        NSString *toidStr = [dataDic objectForKey:@"user_id"];
        [form_request setDelegate:self];
        [form_request setPostValue:uid forKey:@"frmid"];
        [form_request setPostValue:toidStr forKey:@"toid"];
        [form_request setDidFinishSelector:@selector(finishAddFriend:)];
        [form_request setDidFailSelector:@selector(loginFailed:)];
        [form_request startAsynchronous];
    }
    else{ //如果没有登陆
        [self alertViewNotLoginShow];
    }
}

-(void)finishAddFriend:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"申请结果    is   %@",str);
    
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    NSString *infoStr = [dic objectForKey:@"info"];
    NSLog(@"infoStr----%@",infoStr);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:infoStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"是",nil];
    [alert show];
    [alert release];
}

-(void)sendSixin{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"logined"] boolValue]){ //如果已登录
        WriteSixin *sixinVC = [[WriteSixin alloc]init];
        [self.navigationController pushViewController:sixinVC animated:YES];
        [sixinVC release];
        sixinVC.uname = [[dataDic objectForKey:@"uinfo"] objectForKey:@"uname"];
        sixinVC.rmid = @"0"; //主动发私信是rmid为0
        [sixinVC.myTextView becomeFirstResponder];
    }
    else{
        [self alertViewNotLoginShow];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.myTableView = nil;
    self.page = nil;
    self.sectionHeadView = nil;
    self.seg = nil;
    self.gdid = nil;
    self.dataDic = nil;
    self.myInfoDic = nil;
}

@end
