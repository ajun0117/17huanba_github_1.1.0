//
//  Gouwuche.m
//  17huanba
//
//  Created by Chen Hao on 13-3-2.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "Gouwuche.h"
#import "Save_CartCell.h"
#import "Dingdan.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Xiangxi.h"
#import "SVProgressHUD.h"

#define DELET @"/phone/plogined/Delcart.html"

@interface Gouwuche ()

@end

@implementation Gouwuche
@synthesize cartTableView;
@synthesize cartArray,refreshing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cartArray = [NSMutableArray array];
        page = 0;
    }
    return self;
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
    nameL.text = @"购物车";
    [navIV addSubview:nameL];
    [nameL release];
    [self.view addSubview:navIV];
    [navIV release];
    
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleBtn.frame = CGRectMake(258, 10, 57, 27);
    deleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [deleBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleBtn setTitle:@"完成" forState:UIControlStateSelected];
    [deleBtn addTarget:self action:@selector(toDelete:) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:deleBtn];
    
    self.cartTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-44-20) pullingDelegate:self];
    cartTableView.delegate = self;
    cartTableView.dataSource = self;
    [self.view addSubview:cartTableView];
    [cartTableView release];
    
    [self getCartArrayWithpage:0];
}

-(void)getCartArrayWithpage:(int)p{
    [SVProgressHUD showWithStatus:@"加载中.."];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/plogined/Mycart.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"p"];
    [form_request setDidFinishSelector:@selector(finishGetTheCarts:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetTheCarts:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"购物车 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
//    NSLog(@"dic is %@",dic);
    NSArray *array = [dic objectForKey:@"data"];
    [self.cartArray addObjectsFromArray:array];
    [cartTableView reloadData];
    
    [cartTableView tableViewDidFinishedLoading];
    [SVProgressHUD dismiss];
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
//    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [cartTableView tableViewDidFinishedLoading];
}

#pragma mark = UITableViewDelegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [cartArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"shoucangCell";
    Save_CartCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[[Save_CartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSDictionary *cartDic = [cartArray objectAtIndex:indexPath.row];
    id gdinfo = [cartDic objectForKey:@"gdinfo"];
    if ([gdinfo isKindOfClass:[NSDictionary class]]) {
    NSString *urlStr = [gdinfo objectForKey:@"gdimg"];
        if (![urlStr isEqualToString:@" "]) {
            cell.head.urlString = THEURL(urlStr);
        }
        NSString *goodsName = [gdinfo objectForKey:@"goods_name"];
        cell.nameL.text = goodsName;
        NSString *timeStr = [gdinfo objectForKey:@"add_time"];
        NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
        NSString *timeStrr = [NSString stringWithFormat:@"%@",timeDate];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss zzz"];   //zzz代表+0000 时区格式
        NSDate *date=[dateformatter dateFromString:timeStrr];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString=[dateformatter stringFromDate:date];
        [dateformatter release];
        cell.fangshiL.text = dateString;
        
        [cell.accessBtn setTitle:@"申请交易" forState:UIControlStateNormal];
        [cell.accessBtn addTarget:self action:@selector(toBuy:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        cell.textLabel.text = @"物品不存在！";
        cell.head.frame = CGRectZero;
        cell.accessBtn.frame = CGRectZero;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = [cartArray objectAtIndex:indexPath.row];
    id gdinfo = [dic objectForKey:@"gdinfo"];
    if ([gdinfo isKindOfClass:[NSDictionary class]]) {
        NSString *gdidStr = [dic objectForKey:@"good_id"];
//        NSLog(@"gdidStr   is     %@",gdidStr);
        Xiangxi *xiangxiVC = [[Xiangxi alloc]init];
        xiangxiVC.gdid = gdidStr;
        [self.navigationController pushViewController:xiangxiVC animated:YES];
        xiangxiVC.navigationController.navigationBarHidden = YES;
        [xiangxiVC release];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *cartDic = [cartArray objectAtIndex:indexPath.row];
    NSString *cidStr = [cartDic objectForKey:@"cid"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(DELET)];
    
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:cidStr forKey:@"cid"]; //当前收记录的rec_id
    [form_request setPostValue:token forKey:@"token"];
    [form_request setDidFinishSelector:@selector(finishDeleteTheFriend:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
    
    [cartArray removeObject:cartDic];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

-(void)finishDeleteTheFriend:(ASIHTTPRequest *)request{ //请求成功后的方法
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"删除情况 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
//    NSLog(@"dic is %@",dic);
    
    NSString *info = [dic objectForKey:@"info"];
    NSLog(@"%@",info);
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:info delegate:self cancelButtonTitle:nil otherButtonTitles:@"是",nil];
//    [alert show];
//    [alert release];
}



-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toDelete:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        cartTableView.editing = YES;
    }
    else{
        sender.selected = NO;
        cartTableView.editing = NO;
    }
}

-(void)toBuy:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [cartTableView indexPathForCell:cell]; //获取相应的Cell的indexPath，之后从数组中取值得到该好友的ID
    NSDictionary *cartDic = [cartArray objectAtIndex:indexPath.row];
    NSDictionary *gdinfo = [cartDic objectForKey:@"gdinfo"];
    
    NSString *gdid = [gdinfo objectForKey:@"goods_id"];
    
    Dingdan *dingVC = [[Dingdan alloc]init];
    dingVC.gidStr = gdid;
    [self.navigationController pushViewController:dingVC animated:YES];
    [dingVC release];
    
}

#pragma mark - Scroll
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.cartTableView tableViewDidScroll:scrollView];
}


//当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.cartTableView tableViewDidEndDragging:scrollView];
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
    [self getCartArrayWithpage:page];
}

-(void)refreshPage{
    refreshing = NO;
    page = 0;
    [cartArray removeAllObjects];
    [self getCartArrayWithpage:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
