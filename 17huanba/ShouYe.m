//
//  ShouYe.m
//  17huanba
//
//  Created by Chen Hao on 13-1-24.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "ShouYe.h"
#import "SHKActivityIndicator.h"
#import "AsyncImageView.h"
#import "Xiangxi.h"
//#import "Fabu.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "ListCell.h" //最新商品列表Cell
#import "Message.h"
#import "Zhuye.h"
#import "Seen.h"
#import "List.h"
#import "SVProgressHUD.h"

//#define NEWDOODS THEURL(@"/phone/default/index.html") //最新发布的商品
//#define NEWDOODS @"http://www.17huanba.com/phone/default/detail.html" //最新发布的商品



@interface ShouYe ()

@end

@implementation ShouYe
@synthesize timeLineArray,timeLineTable,refreshing;
@synthesize sv,pageC,AdImageArr;
@synthesize TimeNum,Tend;
@synthesize searSV;
@synthesize searchB;
@synthesize searchDis;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.timeLineArray = [NSMutableArray array]; //初始化最新发布商品的列表数组
        page = 0;
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [timeLineTable release];
    [timeLineArray release];
    [sv release];
    [pageC release];
    [searSV release];
    [searchB release];
    [searchDis release];
    RELEASE_SAFELY(AdImageArr);
    RELEASE_SAFELY(searSV);
    RELEASE_SAFELY(searchB);
    RELEASE_SAFELY(searchDis);
}

/*
 @property(retain,nonatomic)NSArray *AdImageArr; //存放广告图片的数组
 @property(assign,nonatomic)int TimeNum;
 @property(assign,nonatomic)BOOL Tend;
 @property(retain,nonatomic)UIScrollView *searSV;
 @property(retain,nonatomic)UISearchBar *searchB;
 @property(retain,nonatomic)UISearchDisplayController *searchDis;
 
 */


-(void)viewDidUnload
{
    [super viewDidUnload];
    self.timeLineTable = nil;
    self.sv = nil;
    self.pageC = nil;
    self.searSV = nil;
    self.searchB = nil;
    self.searchDis = nil;
    RELEASE_SAFELY(searSV);
    RELEASE_SAFELY(searchB);
    RELEASE_SAFELY(searchDis);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    self.timeLineTable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-44-20) pullingDelegate:self];

    timeLineTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.timeLineTable setDelegate:self];
    [self.timeLineTable setDataSource:self];
    [self.view addSubview:timeLineTable];
    
    self.sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 320*480/800)];
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = NO;
    sv.bounces = NO; //禁止scrollView拖动
    sv.delegate = self;
    [self.view addSubview:sv];
    self.timeLineTable.tableHeaderView = sv;
    [sv release];
 
    self.pageC = [[UIPageControl alloc]initWithFrame:CGRectMake(141, 165, 38, 38)];
    
    pageC.currentPage = 0;
    [self.timeLineTable addSubview:pageC];
    [pageC release];
    pageC.enabled = NO;

    self.searSV = [[UIScrollView alloc]initWithFrame:CGRectMake(290, 10, 320, 44)];
    [self.view addSubview:searSV];
    [searSV release];
    
   UIButton *searBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searBtn.frame = CGRectMake(0, 0, 40, 44);
    [searBtn addTarget:self action:@selector(toSearchVC) forControlEvents:UIControlEventTouchUpInside];
    [searBtn setImage:[UIImage imageNamed:@"side_search.png"] forState:UIControlStateNormal];
    [searSV addSubview:searBtn];
    
    self.searchB = [[UISearchBar alloc]initWithFrame:CGRectMake(40, 0, 320, 44)];
    searchB.backgroundImage = [UIImage imageNamed:@"searchbar_bg.png"];
    searchB.delegate = self;
    searchB.placeholder = @"输入商品的关键字进行搜索";
    [searSV addSubview:searchB];
    [searchB release];
    self.searchDis = [[UISearchDisplayController alloc]initWithSearchBar:searchB contentsController:self];
    
    [self requestTheHomeImage];
}

-(void)startTheRequset:(int) newsPage{
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/default/index.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:[NSNumber numberWithInt:newsPage] forKey:@"p"];
    [form_request setDidFinishSelector:@selector(finishTheNewGoods:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishTheNewGoods:(ASIHTTPRequest *)request{ //请求成功后的方法
    [SVProgressHUD dismiss];
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@" ___   %@",str);
    NSArray *array = [str JSONValue];
    [str release];
    NSLog(@"array is %@",array);
    [timeLineArray addObjectsFromArray:array];
    [timeLineTable reloadData];
    [timeLineTable tableViewDidFinishedLoading];
}

-(void)requestTheHomeImage{
    [SVProgressHUD showWithStatus:@"加载首页数据中..."];
    NSURL *homeImgUrl = [NSURL URLWithString:THEURL(@"/phone/default/homeimg.html")];
    ASIHTTPRequest *ImgRequest = [[ASIHTTPRequest alloc]initWithURL:homeImgUrl];
    ImgRequest.delegate = self;
    [ASIHTTPRequest defaultCache];
    [ImgRequest setDidFinishSelector:@selector(finishTheHomeImg:)];
    [ImgRequest setDidFailSelector:@selector(failTheHomeImg:)];
    [ImgRequest startAsynchronous];
}

-(void)finishTheHomeImg:(ASIHTTPRequest *)request{
    [self startTheRequset:0];//请求最新商品列表
    
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *array = [str JSONValue];
    [str release];
    NSLog(@"arrayImg---- is %@",array);
    self.AdImageArr = array;
    [timeLineTable reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(handleTimer:)  userInfo:nil  repeats: YES];
    pageC.numberOfPages = [AdImageArr count];
    [self AdImg:AdImageArr];
    [self setCurrentPage:pageC.currentPage];  
}

-(void)failTheHomeImg:(ASIHTTPRequest *)request{
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"失败   %@",str);
    [str release];
    [SVProgressHUD dismissWithError:@"请检查网络连接后重试！"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIView *button = [self.tabBarController.view viewWithTag:100];//找出tabar中间的相机Button
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 1;
    }];
//    button.hidden = NO;
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
        [form_request setDidFailSelector:@selector(loginFailed:)];
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
        Zhuye *zhuyeVC = [self.tabBarController.viewControllers objectAtIndex:1];
        zhuyeVC.tabBarItem.badgeValue = friendCount;
    }
}


#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [SVProgressHUD dismiss];
}

-(void)toSearchVC
{
    [UIView animateWithDuration:0.5 animations:^{
        searchB.frame = CGRectMake(0, 0, 320, 44);
        searSV.frame = CGRectMake(0, 0, 320, 44);
    }];
    NSLog(@"点击搜索按钮后push出搜索页面");
}

#pragma mark - 搜索栏代理
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.5 animations:^{
        searchB.frame = CGRectMake(40, 0, 320, 44);
        searSV.frame = CGRectMake(290, 10, 320, 44);
    }];
    NSLog(@"点击取消按钮后收起搜索条");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%s",__FUNCTION__);
    
    NSString *keyword = searchBar.text;
    List *listVC = [[List alloc]init];
    listVC.isKeySearch = YES;
    listVC.keyword = keyword;
    
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
    [listVC release];
    listVC.nameL.text = searchBar.text;
    
    UIView *button = [self.tabBarController.view viewWithTag:100];//找出tabar中间的相机Button
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 0;
    }];
}

-(void)AdImg:(NSArray*)arr{
    [sv setContentSize:CGSizeMake(320*[arr count], 320*480/800)];
    pageC.numberOfPages=[arr count];
    
    for ( int i=0; i<[arr count]; i++) {
        NSDictionary *dic=[arr objectAtIndex:i];
        NSString *urlStr = THEURL([dic objectForKey:@"imgsrc"]);
        
        AsyncImageView *img = [[AsyncImageView alloc]init];
        img.frame = CGRectMake(320*i, 0, 320, 320*480/800);
        img.urlString = urlStr;
        [img addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
        [sv addSubview:img];
    }
}

#pragma mark - 5秒换图片
- (void) handleTimer: (NSTimer *) timer
{
    if (TimeNum % 5 == 0 ) {
        
        if (!Tend) {
            pageC.currentPage++;
            if (pageC.currentPage==pageC.numberOfPages-1) {
                Tend=YES;
            }
        }
        else{
            pageC.currentPage--;
            if (pageC.currentPage==0) {
                Tend=NO;
            }
        }
        
        [UIView animateWithDuration:0.7 //速度0.7秒
                         animations:^{//修改坐标
                             sv.contentOffset = CGPointMake(pageC.currentPage*320,0);
                         }];
    }
    TimeNum ++;
}


#pragma mark - scrollView && page

- (void) setCurrentPage:(NSInteger)secondPage {
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [pageC.subviews count]; subviewIndex++) {
        UIImageView* subview = [pageC.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 22/2;
        size.width = 22/2;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        if (subviewIndex == secondPage) [subview setImage:[UIImage imageNamed:@"circle_focus.png"]];
        else [subview setImage:[UIImage imageNamed:@"circle.png"]];
    }
}



#pragma mark - Scroll
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.timeLineTable tableViewDidScroll:scrollView];
    if (scrollView == self.sv) {
        pageC.currentPage=scrollView.contentOffset.x/320;
        [self setCurrentPage:pageC.currentPage];
    }
}


//当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.timeLineTable tableViewDidEndDragging:scrollView];
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
    [self startTheRequset:page];
    NSLog(@"~~%d",page);
    NSLog(@"loadData loadData loadData");
}

-(void)refreshPage{
    refreshing = NO;
    page = 0;
    [timeLineArray removeAllObjects];
    [self startTheRequset:0];
    NSLog(@"refresh  refresh  refresh");
}


-(void)Action
{
    //点击幻灯片上图片后调用的方法
    NSLog(@"你点击了广告");
}

#pragma mark UITableViewDelegate/DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [timeLineArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ind = @"timeLineCell";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:ind];
    if (!cell) {
        cell = [[[ListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ind]autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    NSDictionary *dic = [timeLineArray objectAtIndex:indexPath.row];
    NSString *goods_nameStr = [dic objectForKey:@"goods_name"];
    cell.nameL.text = goods_nameStr; //物品名称
    NSString *gdimg = [dic objectForKey:@"gdimg"];
    
    if (gdimg) {
        cell.imageV.urlString = THEURL(gdimg); //拼接图片URL
    }
    
//    cell.valueL.text = VALUE([dic objectForKey:@"gold"]); //拼接价格
    NSString *value = nil;
    NSString *sell_type = [dic objectForKey:@"sell_type"];
    NSString *gold = [dic objectForKey:@"gold"];
    NSString *silver = [dic objectForKey:@"silver"];
    NSString *memoStr = [dic objectForKey:@"memo"];
    if ([sell_type isEqualToString:@"1"]) {
        value = [NSString stringWithFormat:@"接受%@交换",memoStr];
    }
    else if ([sell_type isEqualToString:@"2"]) {
        value = [NSString stringWithFormat:@"￥%@+%@换币",gold,silver];
    }
    else if ([sell_type isEqualToString:@"3"])
    {
        value = [NSString stringWithFormat:@"￥%@+%@换币或%@",gold,silver,memoStr];
    }
    cell.valueL.text = value;
    
    cell.yuanValueL.text = VALUE([dic objectForKey:@"market_price"]);
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"add_time"] doubleValue]];
    NSString *timeStr = [NSString stringWithFormat:@"%@",timeDate];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss zzz"];   //zzz代表+0000 时区格式
    NSDate *date=[dateformatter dateFromString:timeStr];
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateString=[dateformatter stringFromDate:date];
    [dateformatter release];
//    2013-03-06 10:08:33.754 17huanba[1286:c07] date--====---2013-03-06 02:06:17 +0000
    
    
    cell.timeL.text = dateString;
//    cell.fangshiL.text = @"当面/在线交易";
    cell.weizhiL.text = SHENG_SHI_XIAN([dic objectForKey:@"sheng"],[dic objectForKey:@"shi"],[dic objectForKey:@"xian"]);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

-(NSString *)stringFromDate:(NSTimeInterval)secs{
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:secs];
    NSString *timeStr = [NSString stringWithFormat:@"%@",timeDate];
    //    NSLog(@"timeStr--00--00--%@",timeStr);
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    //    dateformatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];//指定所处位置
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss zzz"];   //zzz代表+0000 时区格式
    NSDate *date=[dateformatter dateFromString:timeStr];
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateString=[dateformatter stringFromDate:date];
    [dateformatter release];
    return dateString;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"didSelect--didSelect--didSelect");
    Xiangxi *xiangxiVC = [[Xiangxi alloc]init];
    
    NSDictionary *dic = [timeLineArray objectAtIndex:indexPath.row];
    NSString *gdidStr = [dic objectForKey:@"goods_id"];
    NSLog(@"gdidStr   is     %@",gdidStr);
    xiangxiVC.gdid = gdidStr;

    xiangxiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xiangxiVC animated:YES];
    xiangxiVC.navigationController.navigationBarHidden = YES;
    [xiangxiVC release];
    
    UIView *button = [self.tabBarController.view viewWithTag:100];//找出tabar中间的相机Button
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 0;
    }];
    
//    +(void) insertSeenWithGid:(int)gid picStr:(NSString *)picUrlStr title:(NSString *)title value:(NSString *)value yuanValue:(NSString *)yuanValue time:(NSString *)time fangshi:(NSString *)fangshi weizhi:(NSString *)weizhi;
    int gid = [[dic objectForKey:@"goods_id"] intValue];
    NSString *picUrlStr = THEURL([dic objectForKey:@"gdimg"]);
    NSString *title = [dic objectForKey:@"goods_name"];
    
    NSString *value = nil;
    NSString *sell_type = [dic objectForKey:@"sell_type"];
    NSString *gold = [dic objectForKey:@"gold"];
    NSString *silver = [dic objectForKey:@"silver"];
    NSString *memoStr = [dic objectForKey:@"memo"];
    if ([sell_type isEqualToString:@"1"]) {
        value = [NSString stringWithFormat:@"接受%@交换",memoStr];
    }
    else if ([sell_type isEqualToString:@"2"]) {
        value = [NSString stringWithFormat:@"￥%@+%@换币",gold,silver];
    }
    else if ([sell_type isEqualToString:@"3"])
    {
        value = [NSString stringWithFormat:@"￥%@+%@换币或%@",gold,silver,memoStr];
    }
    
    NSString *yuanValue = VALUE([dic objectForKey:@"market_price"]);
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"add_time"] doubleValue]];
    NSString *timeStr = [NSString stringWithFormat:@"%@",timeDate];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss zzz"];   //zzz代表+0000 时区格式
    NSDate *date=[dateformatter dateFromString:timeStr];
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateString=[dateformatter stringFromDate:date];
    [dateformatter release];
    NSString *time = dateString;
    
    NSString *fangshi = @"";
    NSString *weizhi = SHENG_SHI_XIAN([dic objectForKey:@"sheng"],[dic objectForKey:@"shi"],[dic objectForKey:@"xian"]);
    
    [Seen insertSeenWithGid:gid picStr:picUrlStr title:title value:value yuanValue:yuanValue time:time fangshi:fangshi weizhi:weizhi];
}

//-(void)pushViewController{
//    Fabu *fabuVC = [[Fabu alloc]init];
//    [self presentModalViewController:fabuVC animated:YES];
//    [fabuVC release];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
