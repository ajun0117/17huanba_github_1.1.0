//
//  GoodsManage.m
//  一起换吧
//
//  Created by Chen Hao on 13-4-13.
//  Copyright (c) 2013年 Chen Hao. All rights reserved.
//

#import "GoodsManage.h"
#import "JSON.h"
#import "SVProgressHUD.h"
#import "Xiangxi.h"
#import "GoodsCell.h"
#import "Fabu.h"

#define XIAJIA @"/phone/goods/Onsale.html"  //商品下架操作
@interface GoodsManage () 

@end

@implementation GoodsManage

@synthesize changeIV,kindsBtn,goodsTableView,goodsArray,goods_request;
@synthesize refreshing,deleBtn,shareVC,theIndexPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.goodsArray = [NSMutableArray array];
        page = 0;
        type = 1; //默认是已上架商品列表
    }
    return self;
}

-(void)dealloc{
    [goods_request clearDelegatesAndCancel];
    [goods_request release];
    
    [changeIV release];
    [kindsBtn release];
    [goodsTableView release];
    [goodsArray release];
    [deleBtn release];
    [shareVC release];
    [theIndexPath release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.goodsTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-44-20) pullingDelegate:self];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_bg.png"]];
    goodsTableView.backgroundView = view;
    [view release];
    goodsTableView.delegate = self;
    goodsTableView.dataSource = self;
    [self.view addSubview:goodsTableView];
    [goodsTableView release];
    
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
    [kindsBtn setTitle:@" 已上架" forState:UIControlStateNormal];
    [kindsBtn addTarget:self action:@selector(toChangeKinds:) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:kindsBtn];
    
    self.deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleBtn.frame = CGRectMake(258, 10, 57, 27);
    deleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [deleBtn setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"] forState:UIControlStateNormal];
    [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleBtn setTitle:@"完成" forState:UIControlStateSelected];
    [deleBtn addTarget:self action:@selector(toDelete:) forControlEvents:UIControlEventTouchUpInside];
    [navIV addSubview:deleBtn];
    
    self.changeIV = [[UIImageView alloc]initWithFrame:CGRectMake(104, 44, 112, 164)];
    changeIV.image = [UIImage imageNamed:@"drop_menu_big.png"];
    changeIV.userInteractionEnabled = YES;
    [self.view addSubview:changeIV];
    [changeIV release];
    changeIV.hidden = YES;
    
    UIButton *shangjiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shangjiaBtn.frame = CGRectMake(0, 15, 112, 20);
    shangjiaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shangjiaBtn setTitle:@"已上架" forState:UIControlStateNormal];
    [shangjiaBtn addTarget:self action:@selector(changeToShangjia:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:shangjiaBtn];
    
    UIButton *zaikuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zaikuBtn.frame = CGRectMake(0, 55, 112, 20);
    zaikuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [zaikuBtn setTitle:@"在库" forState:UIControlStateNormal];
    [zaikuBtn addTarget:self action:@selector(changeToZaiku:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:zaikuBtn];
    
    UIButton *maidaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maidaoBtn.frame = CGRectMake(0, 95, 112, 20);
    maidaoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [maidaoBtn setTitle:@"买到的" forState:UIControlStateNormal];
    [maidaoBtn addTarget:self action:@selector(changeToMaidao:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:maidaoBtn];
    
    UIButton *shenheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shenheBtn.frame = CGRectMake(0, 135, 112, 20);
    shenheBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shenheBtn setTitle:@"审核中" forState:UIControlStateNormal];
    [shenheBtn addTarget:self action:@selector(changeToShenhe:) forControlEvents:UIControlEventTouchUpInside];
    [changeIV addSubview:shenheBtn];
    
    [self getTheGoodsWithType:@"1" andPage:0];
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
-(void)getTheGoodsWithType:(NSString *)listType andPage:(int)p { //获取登录用户商品列表
    [SVProgressHUD showWithStatus:@"加载中.."];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/goods/showlist.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:uid forKey:@"uid"]; //用户ID
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:listType forKey:@"type"];
    [form_request setPostValue:[NSString stringWithFormat:@"%d",p] forKey:@"page"];
    [form_request setDidFinishSelector:@selector(finishGetTheGoods:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishGetTheGoods:(ASIFormDataRequest *)request{
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"已上架 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    id array = [dic objectForKey:@"state"];
    if ([array isKindOfClass:[NSArray class]]) {
        [goodsArray addObjectsFromArray:array];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"暂时没有数据哦！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [goodsTableView reloadData];
    [goodsTableView tableViewDidFinishedLoading];
    [SVProgressHUD dismiss];
}

#pragma mark - 请求失败代理
-(void)loginFailed:(ASIHTTPRequest *)formRequest{
    NSLog(@"formRequest.error-------------%@",formRequest.error);
    NSString *errorStr = [NSString stringWithFormat:@"%@",formRequest.error];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:errorStr delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [goodsTableView tableViewDidFinishedLoading];
}

#pragma mark - Scroll
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    
    [self.goodsTableView tableViewDidScroll:scrollView];
}


//当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.goodsTableView tableViewDidEndDragging:scrollView];
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
    NSLog(@"%d",page);
        if ([kindsBtn.currentTitle isEqualToString:@" 已上架"]) {
            [self getTheGoodsWithType:@"1" andPage:page];
        }
        else if ([kindsBtn.currentTitle isEqualToString:@" 在库"]){
            [self getTheGoodsWithType:@"2" andPage:page];
        }
        else if ([kindsBtn.currentTitle isEqualToString:@" 买到的"]){
            [self getTheGoodsWithType:@"3" andPage:page];
        }
        else if ([kindsBtn.currentTitle isEqualToString:@" 审核中"]){
            [self getTheGoodsWithType:@"4" andPage:page];
        }
    NSLog(@"loadData  loadData  loadData");
}

-(void)refreshPage{
    refreshing = NO;
    page = 0;
    [goodsArray removeAllObjects];
    if ([kindsBtn.currentTitle isEqualToString:@" 已上架"]) {
        [self getTheGoodsWithType:@"1" andPage:0];
    }
    else if ([kindsBtn.currentTitle isEqualToString:@" 在库"]){
        [self getTheGoodsWithType:@"2" andPage:0];
    }
    else if ([kindsBtn.currentTitle isEqualToString:@" 买到的"]){
        [self getTheGoodsWithType:@"3" andPage:0];
    }
    else if ([kindsBtn.currentTitle isEqualToString:@" 审核中"]){
        [self getTheGoodsWithType:@"4" andPage:0];
    }
    NSLog(@"refresh  refresh  refresh");
}

#pragma mark - 不同选项对应的不同方法
-(void)changeToShangjia:(UIButton *)sender{
    deleBtn.hidden = NO;
    type = 1;
    page = 0;
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [goodsArray removeAllObjects];
    [self getTheGoodsWithType:@"1" andPage:0];
}

-(void)changeToZaiku:(UIButton *)sender{
    deleBtn.hidden = NO;
    type = 2;
    page = 0;
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [goodsArray removeAllObjects];
    [self getTheGoodsWithType:@"2" andPage:0];
    
}

-(void)changeToMaidao:(UIButton *)sender{
    deleBtn.hidden = NO;
    type = 3;
    page = 0;
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [goodsArray removeAllObjects];
    [self getTheGoodsWithType:@"3" andPage:0];
    
}

-(void)changeToShenhe:(UIButton *)sender{
    deleBtn.hidden = YES;
    type = 4;
    page = 0;
    NSString *title = [NSString stringWithFormat:@" %@",sender.titleLabel.text];
    [kindsBtn setTitle:title forState:UIControlStateNormal];
    kindsBtn.selected = NO;
    changeIV.hidden = YES;
    [goodsArray removeAllObjects];
    [self getTheGoodsWithType:@"4" andPage:0];
}

#pragma mark = UITableViewDelegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [goodsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indef = @"goodsCell";
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:indef];
    if (!cell) {
        cell = [[GoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indef];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //关闭点击效果
    NSDictionary *goodsDic = [goodsArray objectAtIndex:indexPath.row];
    
    NSString *imgStr = [goodsDic objectForKey:@"midimg"];
        if (![imgStr isEqualToString:@" "]) {
            cell.gdimg.urlString = THEURL(imgStr);
        }
        cell.nameL.text = [goodsDic objectForKey:@"goodsname"];
        
        cell.catType.text = [goodsDic objectForKey:@"catname"];
        
        NSString *price = nil;
        NSString *sell_type = [goodsDic objectForKey:@"selltype"];
        NSString *gold = [goodsDic objectForKey:@"gold"];
        NSString *silver = [goodsDic objectForKey:@"silver"];
        NSString *memoStr = [goodsDic objectForKey:@"memo"];
        
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
        cell.sell_type.text = price;
        
        NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[[goodsDic objectForKey:@"lastupdate"] doubleValue]];
        NSString *timeStr = [NSString stringWithFormat:@"%@",timeDate];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss zzz"];   //zzz代表+0000 时区格式
        NSDate *date=[dateformatter dateFromString:timeStr];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString=[dateformatter stringFromDate:date];
        [dateformatter release];
        cell.last_update.text = dateString;
    
    if (type == 1) { //已上架
        cell.xiajiaBtn.frame = CGRectMake(270, 5, 45, 20); //下架按钮
        [cell.xiajiaBtn addTarget:self action:@selector(xiajia:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.editBtn.frame = CGRectMake(270, 35, 45, 20); //编辑按钮
        [cell.editBtn addTarget:self action:@selector(editGoods:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.shareBtn.frame = CGRectMake(270, 65, 45, 20); //分享按钮
        [cell.shareBtn addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if(type == 2){ //在库商品
        cell.shangjiaBtn.frame = CGRectMake(270, 5, 45, 20); //上架按钮
        [cell.shangjiaBtn addTarget:self action:@selector(shangjia:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.editBtn.frame = CGRectMake(270, 35, 45, 20); //编辑按钮
        [cell.editBtn addTarget:self action:@selector(editGoods:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.shareBtn.frame = CGRectMake(270, 65, 45, 20); //分享按钮
        [cell.shareBtn addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if(type == 3){ //买到的商品
        cell.shareBtn.frame = CGRectMake(270, 35, 45, 20); //分享按钮
        [cell.shareBtn addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(type == 4){ //审核中的商品
        cell.editBtn.frame = CGRectMake(270, 5, 45, 20); //编辑按钮
        [cell.editBtn addTarget:self action:@selector(editGoods:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.shareBtn.frame = CGRectMake(270, 35, 45, 20); //分享按钮
        [cell.shareBtn addTarget:self action:@selector(shareGoods:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"didSelect--didSelect--didSelect");
    Xiangxi *xiangxiVC = [[Xiangxi alloc]init];
    
    NSDictionary *dic = [goodsArray objectAtIndex:indexPath.row];
    NSString *gdidStr = [dic objectForKey:@"goodsid"];
    NSLog(@"gdidStr   is     %@",gdidStr);
    xiangxiVC.gdid = gdidStr;
    
    [self.navigationController pushViewController:xiangxiVC animated:YES];
    xiangxiVC.navigationController.navigationBarHidden = YES;
    [xiangxiVC release];
}

#pragma mark - 删除部分
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (type != 4) {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *goodsDic = [goodsArray objectAtIndex:indexPath.row];
    NSString *gidStr = [goodsDic objectForKey:@"goodsid"];
    [self caozuoWithType:@"3" andGoodsID:gidStr];
    [goodsArray removeObject:goodsDic];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark - 商品操作的一系列方法
-(void)xiajia:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [goodsTableView indexPathForCell:cell];
    NSDictionary *goodDic = [goodsArray objectAtIndex:indexPath.row];
    NSString *gidStr = [goodDic objectForKey:@"goodsid"];
    NSLog(@"goodsID  is %@",gidStr);
    [self caozuoWithType:@"2" andGoodsID:gidStr];
}

-(void)shangjia:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [goodsTableView indexPathForCell:cell];
    NSDictionary *goodDic = [goodsArray objectAtIndex:indexPath.row];
    NSString *gidStr = [goodDic objectForKey:@"goodsid"];
    [self caozuoWithType:@"1" andGoodsID:gidStr];
}

-(void)editGoods:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [goodsTableView indexPathForCell:cell];
    NSDictionary *goodDic = [goodsArray objectAtIndex:indexPath.row];
    NSString *gidStr = [goodDic objectForKey:@"goodsid"];
    
    Fabu *fabuVC = [[Fabu alloc]init];
    fabuVC.isEdit = YES;
    fabuVC.goodsID = gidStr;
    fabuVC.hidesBottomBarWhenPushed = YES;//隐藏底部的tabbar
    UIView *button = [self.view viewWithTag:100];
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 0;
    }];
    [self.navigationController pushViewController:fabuVC animated:YES];
    fabuVC.navigationController.navigationBarHidden = YES;//显示自定义的Nav
    [fabuVC release];
    
}

-(void)shareGoods:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    self.theIndexPath = [goodsTableView indexPathForCell:cell];
    NSDictionary *goodDic = [goodsArray objectAtIndex:theIndexPath.row];
    NSString *gidStr = [goodDic objectForKey:@"goodsid"];
    NSString *goodsName = [goodDic objectForKey:@"goodsname"];
    NSString *price = nil;
    NSString *sell_type = [goodDic objectForKey:@"selltype"];
    NSString *gold = [goodDic objectForKey:@"gold"];
    NSString *silver = [goodDic objectForKey:@"silver"];
    NSString *memoStr = [goodDic objectForKey:@"memo"];

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
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.17huanba.com/view/%@.html",gidStr];
    
    
    self.shareVC = [[KYShareViewController alloc] init];
    shareVC.shareText = [NSString stringWithFormat:@"偶有闲置%@一枚，以%@兜售，求置换哦，不知道亲们是否喜欢？%@",goodsName,price,urlStr];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", @"腾讯微博", @"人人网",@"我的动态",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
    
}

#pragma mark - uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        shareVC.shareType = SinaWeibo;
        shareVC.title = @"分享到新浪微博";
        [self.navigationController pushViewController:shareVC animated:YES];
    }
    else if (buttonIndex == 1) {
        shareVC.shareType = Tencent;
        shareVC.title = @"分享到腾讯微博";
        [self.navigationController pushViewController:shareVC animated:YES];
    }
    else if (buttonIndex == 2) {
        shareVC.shareType = RenrenShare;
        shareVC.title = @"分享到人人网";
        [self.navigationController pushViewController:shareVC animated:YES];
    }
    else if (buttonIndex == 3) {
        NSDictionary *goodDic = [goodsArray objectAtIndex:theIndexPath.row];
        NSString *gidStr = [goodDic objectForKey:@"goodsid"];
        [self caozuoWithType:@"4" andGoodsID:gidStr];
    }
}

#pragma mark - 对商品操作的请求
-(void)caozuoWithType:(NSString *)caozuoType andGoodsID:(NSString *)gid{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSURL *newUrl = [NSURL URLWithString:THEURL(@"/phone/goods/Onsale.html")];
    ASIFormDataRequest *form_request = [ASIFormDataRequest requestWithURL:newUrl];
    [form_request setDelegate:self];
    [form_request setPostValue:uid forKey:@"uid"]; //用户ID
    [form_request setPostValue:token forKey:@"token"];
    [form_request setPostValue:caozuoType forKey:@"type"];
    [form_request setPostValue:gid forKey:@"goodsid"];
    [form_request setDidFinishSelector:@selector(finishCaozuo:)];
    [form_request setDidFailSelector:@selector(loginFailed:)];
    [form_request startAsynchronous];
}

-(void)finishCaozuo:(ASIFormDataRequest *)request{
    NSData *data = request.responseData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"操作 str    is   %@",str);
    NSDictionary *dic = [str JSONValue];
    [str release];
    NSLog(@"dic is %@",dic);
    NSString *state = [dic objectForKey:@"state"];
    NSLog(@"%@",state);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:state delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [goodsTableView reloadData];
}

-(void)toDelete:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        goodsTableView.editing = YES;
    }
    else{
        sender.selected = NO;
        goodsTableView.editing = NO;
    }
}

-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
