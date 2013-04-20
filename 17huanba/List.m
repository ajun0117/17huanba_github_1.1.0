//
//  List.m
//  17huanba
//
//  Created by Chen Hao on 13-2-1.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "List.h"
#import "ListCell.h"
#import "Xiangxi.h"
#import "TTSwitch.h"
#import "JSON.h"
#import "SVProgressHUD.h"

#define SEARCh @"/phone/search/index.html"

@interface List ()

@end

@implementation List
@synthesize listTableView;
@synthesize refreshing;
@synthesize cidStr,listArray;
@synthesize nameL;
@synthesize isKeySearch,keyword;
@synthesize form_request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        page = 0;
        self.listArray  = [NSMutableArray array];
        self.isKeySearch = NO;
        self.keyword = nil;
    }
    return self;
}

-(void)dealloc{
    [form_request clearDelegatesAndCancel];
    [form_request release];
    [listTableView release];
    RELEASE_SAFELY(cidStr);
    RELEASE_SAFELY(listArray);
    RELEASE_SAFELY(nameL);
    RELEASE_SAFELY(keyword);
    [super dealloc];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.listTableView = nil;
    RELEASE_SAFELY(cidStr);
    RELEASE_SAFELY(listArray);
    RELEASE_SAFELY(nameL);
    RELEASE_SAFELY(keyword);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame = CGRectMake(0, 0, 320, 44);
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(5, 10, 57, 27);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_gray_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:backBtn];
    
    UIButton *toFenleiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    toFenleiBtn.frame=CGRectMake(258, 10, 57, 27);
    [toFenleiBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    toFenleiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [toFenleiBtn setTitle:@"重选" forState:UIControlStateNormal];
    [toFenleiBtn addTarget:self action:@selector(toFenlei) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:toFenleiBtn];
    
    self.nameL=[[UILabel alloc]initWithFrame:CGRectMake(90, 10, 140, 24)];
    nameL.font=[UIFont systemFontOfSize:17];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = UITextAlignmentCenter;
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"搜索结果";
    [navIV addSubview:nameL];
    [nameL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    UIImageView *segIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bar_background.png"]];
    segIV.frame = CGRectMake(0, 44, 320, 44);
    segIV.userInteractionEnabled = YES;
    [self.view addSubview:segIV];
    [segIV release];
    
    self.listTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-44-20) pullingDelegate:self];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    [self.view addSubview:listTableView];
    [listTableView release];
    
    [self getTheListWithPage:0 andKeyword:keyword];
}

-(void)getTheListWithPage:(int)p andKeyword:(NSString *)theKeyword {
    [SVProgressHUD showWithStatus:@"搜索中.."];
    NSURL *searchUrl = [NSURL URLWithString:THEURL(SEARCh)];
    self.form_request = [ASIFormDataRequest requestWithURL:searchUrl];
    [form_request setDelegate:self];

    if (isKeySearch) {
        [form_request setPostValue:theKeyword forKey:@"keyword"];
    }
    else{
        [form_request setPostValue:cidStr forKey:@"cid"];
    }
    [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    [form_request setDidFinishSelector:@selector(finishGetTheSearch:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}


-(void)finishGetTheSearch:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"搜索结果  str    is   %@",str);
    NSDictionary *searchDic = [str JSONValue];
    [str release];
    NSArray *array = [searchDic objectForKey:@"data"];
    [listArray addObjectsFromArray:array];
    [listTableView reloadData];
    
    [listTableView tableViewDidFinishedLoading];
    [SVProgressHUD dismiss];
    
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
//    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [listTableView tableViewDidFinishedLoading];
}

#pragma mark - UItableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"searchCell";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[ListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *dic = [listArray objectAtIndex:indexPath.row];
    NSString *goods_nameStr = [dic objectForKey:@"goods_name"];
    cell.nameL.text = goods_nameStr; //物品名称
    NSString *gdimgStr = [dic objectForKey:@"gdimg"];
    if (gdimgStr) {
        cell.imageV.urlString = THEURL(gdimgStr); //拼接图片URL
    }
    
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
    cell.weizhiL.text = SHENG_SHI_XIAN([dic objectForKey:@"sheng"],[dic objectForKey:@"shi"],[dic objectForKey:@"xian"]);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Xiangxi *xiangxiVC = [[Xiangxi alloc]init];
    
    NSDictionary *dic = [listArray objectAtIndex:indexPath.row];
    NSString *gdidStr = [dic objectForKey:@"goods_id"];
//    NSLog(@"gdidStr   is     %@",gdidStr);
    xiangxiVC.gdid = gdidStr;
    
    [self.navigationController pushViewController:xiangxiVC animated:YES];
    xiangxiVC.navigationController.navigationBarHidden = YES;
    [xiangxiVC release];
}

#pragma mark - MyMethods
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toFenlei{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Scroll
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.listTableView tableViewDidScroll:scrollView];
}


//当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.listTableView tableViewDidEndDragging:scrollView];
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
    [self getTheListWithPage:page andKeyword:keyword];

//    NSLog(@"loadData loadData loadData");
}

-(void)refreshPage{
    refreshing = NO;
    page = 0;
    [listArray removeAllObjects];
    [self getTheListWithPage:0 andKeyword:keyword];

//    NSLog(@"refresh  refresh  refresh");
}

#pragma mark - ToggleViewDelegate

- (void)selectLeftButton
{
    NSLog(@"LeftButton Selected");
}

- (void)selectRightButton
{
    NSLog(@"RightButton Selected");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.listTableView = nil;
    RELEASE_SAFELY(nameL);
    RELEASE_SAFELY(keyword);
}

@end
