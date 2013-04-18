//
//  DingdanManage.m
//  一起换吧
//
//  Created by Chen Hao on 13-4-18.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "DingdanManage.h"
#import "JSON.h"
#import "SVProgressHUD.h"
#import "Xiangxi.h"
#import "DingdanCell.h"

@interface DingdanManage ()

@end

@implementation DingdanManage
@synthesize changeIV,kindsBtn,dingdanArray,dingdanTableView,dingdan_request,refreshing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dingdanArray = [NSMutableArray array];
        type = 1; //默认是作为买家
    }
    return self;
}

-(void)dealloc{
    [dingdan_request clearDelegatesAndCancel];
    [dingdan_request release];
    
    [changeIV release];
    [kindsBtn release];
    [dingdanArray release];
    [dingdanTableView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.dingdanTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-44-20)];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    dingdanTableView.backgroundView = view;
    [view release];
    dingdanTableView.delegate = self;
    dingdanTableView.dataSource = self;
    [self.view addSubview:dingdanTableView];
    [dingdanTableView release];
    
    UIImageView *navIV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_nav.png"]];
    navIV.userInteractionEnabled=YES;
    navIV.frame = CGRectMake(0, 0, 320, 44);
    [self.view addSubview:navIV];
    [navIV release];
    
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
    [kindsBtn setTitle:@" 作为买家" forState:UIControlStateNormal];
    [kindsBtn addTarget:self action:@selector(toChangeKinds:) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:kindsBtn];
    
//    self.deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    deleBtn.frame = CGRectMake(258, 10, 57, 27);
//    deleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    [deleBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
//    [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
//    [deleBtn setTitle:@"完成" forState:UIControlStateSelected];
//    [deleBtn addTarget:self action:@selector(toDelete:) forControlEvents:UIControlEventTouchUpInside];
//    [navIV addSubview:deleBtn];
    
    self.changeIV = [[UIImageView alloc]initWithFrame:CGRectMake(104, 44, 112, 164)];
    changeIV.image = [UIImage imageNamed:@"drop_menu_2.png"];
    changeIV.userInteractionEnabled = YES;
    [self.view addSubview:changeIV];
    [changeIV release];
    changeIV.hidden = YES;
    
    UIButton *buyerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyerBtn.frame = CGRectMake(0, 15, 112, 20);
    buyerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [buyerBtn setTitle:@"作为买家" forState:UIControlStateNormal];
    [buyerBtn addTarget:self action:@selector(changeToBuyer:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:buyerBtn];
    
    UIButton *sellerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sellerBtn.frame = CGRectMake(0, 55, 112, 20);
    sellerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sellerBtn setTitle:@"作为卖家" forState:UIControlStateNormal];
    [sellerBtn addTarget:self action:@selector(changeToSeller:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:sellerBtn];
    
//    UIButton *maidaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    maidaoBtn.frame = CGRectMake(0, 95, 112, 20);
//    maidaoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [maidaoBtn setTitle:@"买到的" forState:UIControlStateNormal];
//    [maidaoBtn addTarget:self action:@selector(changeToMaidao:) forControlEvents:UIControlEventTouchUpInside];
//    [changeIV addSubview:maidaoBtn];
//    
//    UIButton *shenheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shenheBtn.frame = CGRectMake(0, 135, 112, 20);
//    shenheBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [shenheBtn setTitle:@"审核中" forState:UIControlStateNormal];
//    [shenheBtn addTarget:self action:@selector(changeToShenhe:) forControlEvents:UIControlEventTouchUpInside];
//    [changeIV addSubview:shenheBtn];
    
//    [self getTheGoodsWithType:@"1" andPage:0];
    [self getTheDingdanWithType:@"1" andPage:0];
}

#pragma mark = UITableViewDelegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dingdanArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"goodsCell";
    DingdanCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[DingdanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //关闭点击效果
    NSDictionary *dingdanDic = [dingdanArray objectAtIndex:indexPath.row];
    
    NSString *imgStr = [dingdanDic objectForKey:@"smallimg"];
    if (![imgStr isEqualToString:@" "]) {
        cell.gdimg.urlString = THEURL(imgStr);
    }
    cell.nameL.text = [dingdanDic objectForKey:@"goods_name"];
    NSString *bianhaoStr = [dingdanDic objectForKey:@"order_sn"];
    cell.bianhaoL.text = [NSString stringWithFormat:@"订单编号：%@",bianhaoStr];
    
    NSString *numStr = [dingdanDic objectForKey:@"goods_number"];
    cell.numberL.text = [NSString stringWithFormat:@"购买数量：%@",numStr];
    
    NSString *toNameStr = [dingdanDic objectForKey:@"uname"];
    cell.toNameL.text = [NSString stringWithFormat:@"对方：%@",toNameStr];
    
    int stateStr = [[dingdanDic objectForKey:@"state"] intValue];
    switch (stateStr) {
        case 0:
            cell.state.text = @"状态：待处理";
            break;
            
        case 1:
            cell.state.text = @"状态：己确认";
            break;
            
        case 2:
            cell.state.text = @"状态：己发货";
            break;
            
        case 3:
            cell.state.text = @"状态：己评论";
            break;
            
        case 4:
            cell.state.text = @"状态：取消";
            break;
            
        case 5:
            cell.state.text = @"状态：己拒绝";
            break;
            
        case 6:
            cell.state.text = @"状态：等待买家付款｜发货";
            break;
            
        default:
            cell.state.text = @"状态：成功交易";
            break;
    }
    
    cell.xiangqingBtn.frame = CGRectMake(250, 75, 60, 20);
    [cell.xiangqingBtn addTarget:self action:@selector(toXiangqing:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    cell.catType.text = [dingdanDic objectForKey:@"catname"];
//    
//    NSString *price = nil;
//    NSString *sell_type = [dingdanDic objectForKey:@"selltype"];
//    NSString *gold = [dingdanDic objectForKey:@"gold"];
//    NSString *silver = [dingdanDic objectForKey:@"silver"];
//    NSString *memoStr = [dingdanDic objectForKey:@"memo"];
//    
//    if ([sell_type isEqualToString:@"1"]) {
//        price = [NSString stringWithFormat:@"接受%@交换",memoStr];
//    }
//    else if ([sell_type isEqualToString:@"2"]) {
//        price = [NSString stringWithFormat:@"￥%@+%@换币",gold,silver];
//        
//    }
//    else if ([sell_type isEqualToString:@"3"])
//    {
//        price = [NSString stringWithFormat:@"￥%@+%@换币或%@",gold,silver,memoStr];
//    }
//    cell.sell_type.text = price;
//    
//    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[[dingdanDic objectForKey:@"lastupdate"] doubleValue]];
//    NSString *timeStr = [NSString stringWithFormat:@"%@",timeDate];
//    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
//    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss zzz"];   //zzz代表+0000 时区格式
//    NSDate *date=[dateformatter dateFromString:timeStr];
//    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *dateString=[dateformatter stringFromDate:date];
//    [dateformatter release];
//    cell.last_update.text = dateString;
//    
//    if (type == 1) { //已上架
//        cell.xiajiaBtn.frame = CGRectMake(270, 5, 45, 20); //下架按钮
//        [cell.xiajiaBtn addTarget:self action:@selector(xiajia:) forControlEvents:UIControlEventTouchUpInside];
//        
//        cell.editBtn.frame = CGRectMake(270, 35, 45, 20); //编辑按钮
//        [cell.editBtn addTarget:self action:@selector(editGoods:) forControlEvents:UIControlEventTouchUpInside];
//        
//        cell.shareBtn.frame = CGRectMake(270, 65, 45, 20); //分享按钮
//        [cell.shareBtn addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    else if(type == 2){ //在库商品
//        cell.shangjiaBtn.frame = CGRectMake(270, 5, 45, 20); //上架按钮
//        [cell.shangjiaBtn addTarget:self action:@selector(shangjia:) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        cell.editBtn.frame = CGRectMake(270, 35, 45, 20); //编辑按钮
//        [cell.editBtn addTarget:self action:@selector(editGoods:) forControlEvents:UIControlEventTouchUpInside];
//        
//        cell.shareBtn.frame = CGRectMake(270, 65, 45, 20); //分享按钮
//        [cell.shareBtn addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    else if(type == 3){ //买到的商品
//        cell.shareBtn.frame = CGRectMake(270, 35, 45, 20); //分享按钮
//        [cell.shareBtn addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    else if(type == 4){ //审核中的商品
//        cell.editBtn.frame = CGRectMake(270, 5, 45, 20); //编辑按钮
//        [cell.editBtn addTarget:self action:@selector(editGoods:) forControlEvents:UIControlEventTouchUpInside];
//        
//        cell.shareBtn.frame = CGRectMake(270, 35, 45, 20); //分享按钮
//        [cell.shareBtn addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
//    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"didSelect--didSelect--didSelect");
    Xiangxi *xiangxiVC = [[Xiangxi alloc]init];
    
//    NSDictionary *dic = [goodsArray objectAtIndex:indexPath.row];
//    NSString *gdidStr = [dic objectForKey:@"goodsid"];
//    NSLog(@"gdidStr   is     %@",gdidStr);
//    xiangxiVC.gdid = gdidStr;
//    
//    [self.navigationController pushViewController:xiangxiVC animated:YES];
//    xiangxiVC.navigationController.navigationBarHidden = YES;
//    [xiangxiVC release];
}

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

#pragma mark - 获取用户通知列表（收到和申请）
-(void)getTheDingdanWithType:(NSString *)shenfenType andPage:(int)p { //获取登录用户商品列表
    [SVProgressHUD showWithStatus:@"加载中.."];
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/goods/Orderlist.html")];
//    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/goods/orderinfo.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:uid forKey:@"uid"]; //用户ID
//    [form_request setPostValue:@"2" forKey:@"oid"];
    [form_request setPostValue:shenfenType forKey:@"type"];

    [form_request setDidFinishSelector:@selector(finishGetTheDingdan:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetTheDingdan:(ASIFormDataRequest *)request{
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"已上架 str    is   %@",str);
//    NSDictionary *dic = [str JSONValue];
//    [str release];
//    NSLog(@"dic is %@",dic);
//    NSArray *buyerArray = [dic objectForKey:@"buyermodel"];
//    NSArray *sellerArray = [dic objectForKey:@"sellermodel"];
    NSArray *Array = [str JSONValue];
    [dingdanArray addObjectsFromArray:Array];
    [dingdanTableView reloadData];
//    id array = [dic objectForKey:@"state"];
//    if ([array isKindOfClass:[NSArray class]]) {
//        [goodsArray addObjectsFromArray:array];
//    }
//    else{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"暂时没有数据哦！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//    }
//    [goodsTableView reloadData];
//    [goodsTableView tableViewDidFinishedLoading];
    [SVProgressHUD dismiss];
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
//    [goodsTableView tableViewDidFinishedLoading];
}

-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 不同选项对应的不同方法
-(void)changeToBuyer:(UIButton *)sender{
    type = 1; //买家
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [dingdanArray removeAllObjects];
    [self getTheDingdanWithType:@"1" andPage:0];
}

-(void)changeToSeller:(UIButton *)sender{
    type = 2; //卖家
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [dingdanArray removeAllObjects];
    [self getTheDingdanWithType:@"2" andPage:0];
}

//#pragma mark - Scroll
////会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    kindsBtn.selected = NO;
//    changeIV.hidden = YES;
//    
//    [self.dingdanTableView tableViewDidScroll:scrollView];
//}
//
////当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    [self.dingdanTableView tableViewDidEndDragging:scrollView];
//}
//#pragma mark - PullingRefreshTableViewDelegate
//- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
//{
//    self.refreshing = YES;
//    [self performSelector:@selector(refreshPage) withObject:nil afterDelay:1.f];
//}
//- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
//{
//    
//    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
//}
//
//-(void)loadData
//{
//    page++;
//    refreshing = NO;
//    NSLog(@"%d",page);
//    if ([kindsBtn.currentTitle isEqualToString:@" 作为买家"]) {
//        [self getTheDingdanWithType:@"1" andPage:page];
//    }
//    else if ([kindsBtn.currentTitle isEqualToString:@" 作为卖家"]){
//        [self getTheDingdanWithType:@"1" andPage:page];
//    }
//    NSLog(@"loadData  loadData  loadData");
//}
//
//-(void)refreshPage{
//    refreshing = NO;
//    page = 0;
//    [dingdanArray removeAllObjects];
//    if ([kindsBtn.currentTitle isEqualToString:@" 作为买家"]) {
//        [self getTheDingdanWithType:@"1" andPage:0];
//    }
//    else if ([kindsBtn.currentTitle isEqualToString:@" 作为卖家"]){
//        [self getTheDingdanWithType:@"1" andPage:0];
//    }
//
//    NSLog(@"refresh  refresh  refresh");
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
