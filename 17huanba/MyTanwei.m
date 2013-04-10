//
//  MyTanwei.m
//  17huanba
//
//  Created by Chen Hao on 13-2-22.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "MyTanwei.h"
#import "Save_CartCell.h"
#import "GerenDongtai.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Xiangxi.h"
#import "SVProgressHUD.h"

@interface MyTanwei ()

@end

@implementation MyTanwei
@synthesize tanweiTableView,tanweiArray;
@synthesize refreshing;
@synthesize form_request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tanweiArray = [NSMutableArray array];
        page = 0;
    }
    return self;
}

-(void)dealloc{
    [form_request clearDelegatesAndCancel];
    [form_request release];
    
//    RELEASE_SAFELY(tanweiTableView);
//    RELEASE_SAFELY(tanweiArray);
    [super dealloc];
}

-(void)viewDidUnload{
    RELEASE_SAFELY(tanweiTableView);
    RELEASE_SAFELY(tanweiArray);
    [super viewDidUnload];
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
    
    UILabel *nameL=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 120, 24)];
    nameL.font=[UIFont systemFontOfSize:17];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = UITextAlignmentCenter;
    nameL.textColor = [UIColor whiteColor];
    nameL.text = @"我的摊位";
    [navIV addSubview:nameL];
    [nameL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    self.tanweiTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-44-20) pullingDelegate:self];
    tanweiTableView.delegate = self;
    tanweiTableView.dataSource = self;
    [self.view addSubview:tanweiTableView];
    [tanweiTableView release];
    
    
    [self getTanweiList:0];
    
}

-(void)getTanweiList:(int)p{
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/logined/Shoplist.html")];
    self.form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
//    [form_request setPostValue:@"1" forKey:@"state"]; //成功加为好友的列表
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    [form_request setDidFinishSelector:@selector(finishGetTheTanwei:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetTheTanwei:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"摊位 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    NSArray *array = [dic objectForKey:@"data"];
    [self.tanweiArray addObjectsFromArray:array];
    [tanweiTableView reloadData];
    [tanweiTableView tableViewDidFinishedLoading];
    [SVProgressHUD dismiss];
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark = UITableViewDelegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tanweiArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"shoucangCell";
    Save_CartCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[[Save_CartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    NSDictionary *tanweiDic = [tanweiArray objectAtIndex:indexPath.row];
    NSString *urlStr = [tanweiDic objectForKey:@"gdimg"];
//    if (![urlStr isEqualToString:@" "]) {
    if (![urlStr isKindOfClass:[NSNull class]]) {
        cell.head.urlString = THEURL(urlStr);
    }
//    [cell.head addTarget:self action:@selector(toGerenDongtai:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *goodsName = [tanweiDic objectForKey:@"goods_name"];
    cell.nameL.text = goodsName;
    
    NSString *sell_type = [tanweiDic objectForKey:@"sell_type"];
    NSString *gold = [tanweiDic objectForKey:@"gold"];
    NSString *silver = [tanweiDic objectForKey:@"silver"];
    NSString *memoStr = [tanweiDic objectForKey:@"memo"];
    if ([sell_type isEqualToString:@"1"]) {
        NSString *price = [NSString stringWithFormat:@"接受%@交换",memoStr];
        cell.fangshiL.text = price;
    }
    else if ([sell_type isEqualToString:@"2"]) {
        NSString *price = [NSString stringWithFormat:@"￥%@+%@换币",gold,silver];
        cell.fangshiL.text = price;
    }
    else if ([sell_type isEqualToString:@"3"])
    {
        NSString *price = [NSString stringWithFormat:@"￥%@+%@换币或%@",gold,silver,memoStr];
        cell.fangshiL.text = price;
    }
    [cell.accessBtn setTitle:@"分享" forState:UIControlStateNormal];
    [cell.accessBtn addTarget:self action:@selector(toShare:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"didSelect--didSelect--didSelect");
    Xiangxi *xiangxiVC = [[Xiangxi alloc]init];
    
    NSDictionary *dic = [tanweiArray objectAtIndex:indexPath.row];
    NSString *gdidStr = [dic objectForKey:@"goods_id"];
    NSLog(@"gdidStr   is     %@",gdidStr);
    xiangxiVC.gdid = gdidStr;
    
    [self.navigationController pushViewController:xiangxiVC animated:YES];
    xiangxiVC.navigationController.navigationBarHidden = YES;
    [xiangxiVC release];
}

-(void)toShare:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [tanweiTableView indexPathForCell:cell]; //获取相应的Cell的indexPath，之后从数组中取值得到该好友的ID
    
    NSDictionary *dic = [tanweiArray objectAtIndex:indexPath.row];
    NSString *gid = [dic objectForKey:@"goods_id"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/plogined/Share.html")]; //分享
    self.form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:gid forKey:@"gid"]; //商品ID
    [form_request setPostValue:token forKey:@"token"];
    //    [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    [form_request setDidFinishSelector:@selector(finishFenxiangTheShoucang:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishFenxiangTheShoucang:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"分享收藏 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    NSString *info = [dic objectForKey:@"info"];
    NSLog(@"%@",info);
    
    //        NSArray *array = [dic objectForKey:@"data"];
    //        [self.shouArray addObjectsFromArray:array];
    //        [shoucangTableView reloadData];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:info delegate:self cancelButtonTitle:nil otherButtonTitles:@"是",nil];
    [alert show];
    [alert release];
}

-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}


//-(void)toGerenDongtai:(AsyncImageView *)sender{
//    UITableViewCell *cell = (UITableViewCell *)sender.superview;
//    NSIndexPath *indexPath = [tanweiTableView indexPathForCell:cell]; //获取相应的Cell的indexPath，之后从数组中取值得到该好友的ID
//    
//    NSDictionary *gerenDic = [tanweiArray objectAtIndex:indexPath.row];
//    
//    NSLog(@"点击了卖家头像！");
//    GerenDongtai *gerenVC = [[GerenDongtai alloc]init];
//    gerenVC.userDic = gerenDic;
//    [self.navigationController pushViewController:gerenVC animated:YES];
//    gerenVC.navigationController.navigationBarHidden = YES;
//    
//    
//}

#pragma mark - Scroll
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tanweiTableView tableViewDidScroll:scrollView];
}


//当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tanweiTableView tableViewDidEndDragging:scrollView];
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
    [self getTanweiList:page];

    NSLog(@"loadData  loadData  loadData");
}

-(void)refreshPage{
    refreshing = NO;
    page = 0;
    [tanweiArray removeAllObjects];
    [self getTanweiList:0];
    
    NSLog(@"refresh  refresh  refresh");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
